#!/usr/bin/env python3
"""
Tool Analyzer for Claude Code stream-json logs
Analyzes tool usage patterns and skill invocations
"""

import json
import sys
from collections import defaultdict, Counter
from typing import Dict, List, Any

def analyze_json_log(json_path: str) -> Dict[str, Any]:
    """Analyze JSON log file and extract patterns"""

    with open(json_path, 'r') as f:
        lines = f.readlines()

    # Parse JSON lines
    events = []
    for i, line in enumerate(lines, 1):
        line = line.strip()
        if not line:
            continue
        try:
            events.append(json.loads(line))
        except json.JSONDecodeError as e:
            print(f"Warning: Failed to parse line {i}: {e}")
            continue

    # Analysis data structures
    analysis = {
        'summary': {},
        'tool_usage': defaultdict(int),
        'skill_calls': [],
        'execution_pattern': {
            'type': 'unknown',
            'chains': []
        },
        'success_rate': {'success': 0, 'total': 0},
        'skill_flow': [],
        'timeline': []
    }

    # Track skill call relationships
    skill_call_stack = []
    current_assistant_uuid = None

    # Process events
    for event in events:
        event_type = event.get('type', 'unknown')
        timestamp = event.get('uuid', '')

        # System init event
        if event_type == 'system' and event.get('subtype') == 'init':
            analysis['summary']['available_tools'] = len(event.get('tools', []))
            analysis['summary']['available_skills'] = len(event.get('skills', []))
            analysis['summary']['available_agents'] = len(event.get('agents', []))
            analysis['summary']['session_id'] = event.get('session_id')
            analysis['summary']['model'] = event.get('model')
            analysis['summary']['permission_mode'] = event.get('permissionMode')
            continue

        # Assistant messages
        if event_type == 'assistant':
            content = event.get('message', {}).get('content', [])
            current_assistant_uuid = event.get('uuid', '')

            # Track tool usage in assistant messages
            for item in content:
                if item.get('type') == 'tool_use':
                    tool_name = item.get('name')
                    if tool_name:
                        analysis['tool_usage'][tool_name] += 1

                        # Track skill calls
                        if tool_name == 'Skill':
                            skill_name = item.get('input', {}).get('skill')
                            if skill_name:
                                skill_info = {
                                    'name': skill_name,
                                    'caller_uuid': current_assistant_uuid,
                                    'timestamp': timestamp
                                }
                                analysis['skill_calls'].append(skill_info)
                                skill_call_stack.append(skill_info)

            # Record in timeline
            usage = event.get('message', {}).get('usage', {})
            if usage:
                analysis['timeline'].append({
                    'type': 'assistant',
                    'uuid': current_assistant_uuid,
                    'input_tokens': usage.get('input_tokens', 0),
                    'output_tokens': usage.get('output_tokens', 0),
                    'tool_use_count': len([item for item in content if item.get('type') == 'tool_use'])
                })

        # User messages (tool results)
        elif event_type == 'user':
            content = event.get('message', {}).get('content', [])
            parent_id = event.get('parent_tool_use_id')

            for item in content:
                if item.get('type') == 'tool_result':
                    tool_result = item.get('tool_use_result', {})
                    success = tool_result.get('success', False)
                    command = tool_result.get('commandName')

                    # Track skill completion
                    if parent_id and command:
                        # Find matching skill call
                        matching_call = None
                        for call in analysis['skill_calls']:
                            if call['name'] == command:
                                matching_call = call
                                break

                        if matching_call:
                            matching_call['success'] = success
                            matching_call['completed'] = True
                            matching_call['agent_id'] = tool_result.get('agentId')
                            matching_call['status'] = tool_result.get('status', 'unknown')

                    # Record in timeline
                    analysis['timeline'].append({
                        'type': 'tool_result',
                        'parent_id': parent_id,
                        'command': command,
                        'success': success,
                        'status': tool_result.get('status', 'unknown')
                    })

        # Final result
        elif event_type == 'result':
            result = event
            analysis['summary']['duration_ms'] = result.get('duration_ms', 0)
            analysis['summary']['total_cost_usd'] = result.get('total_cost_usd', 0)
            analysis['summary']['total_turns'] = result.get('num_turns', 0)
            analysis['success_rate']['total'] = 1
            if result.get('is_error') == False:
                analysis['success_rate']['success'] = 1

            # Collect usage stats
            usage = result.get('usage', {})
            if usage:
                analysis['summary']['total_input_tokens'] = usage.get('input_tokens', 0)
                analysis['summary']['total_output_tokens'] = usage.get('output_tokens', 0)
                analysis['summary']['server_tool_use'] = usage.get('server_tool_use', {})

    # Determine execution pattern
    skill_names = [call['name'] for call in analysis['skill_calls']]
    if len(skill_names) > 1:
        # Check for chain pattern
        unique_skills = list(dict.fromkeys(skill_names))  # Preserve order, remove duplicates
        if len(unique_skills) > 1:
            analysis['execution_pattern']['type'] = 'skill_chain'
            analysis['execution_pattern']['chains'] = unique_skills
            analysis['skill_flow'] = [
                {
                    'from': unique_skills[i],
                    'to': unique_skills[i+1] if i+1 < len(unique_skills) else 'completed',
                    'relationship': 'sequential_call'
                }
                for i in range(len(unique_skills) - 1)
            ]

    # Calculate success rate for skills
    completed_skills = [call for call in analysis['skill_calls'] if call.get('completed')]
    if completed_skills:
        analysis['success_rate']['skills'] = {
            'success': sum(1 for call in completed_skills if call.get('success')),
            'total': len(completed_skills)
        }

    return analysis

def print_analysis(analysis: Dict[str, Any]):
    """Print formatted analysis results"""

    print("=" * 80)
    print("CLAUDE CODE EXECUTION ANALYSIS")
    print("=" * 80)

    # Summary
    print("\n📊 SUMMARY")
    print("-" * 80)
    summary = analysis['summary']
    print(f"Session ID: {summary.get('session_id', 'N/A')}")
    print(f"Model: {summary.get('model', 'N/A')}")
    print(f"Permission Mode: {summary.get('permission_mode', 'N/A')}")
    print(f"Duration: {summary.get('duration_ms', 0):,} ms")
    print(f"Total Turns: {summary.get('total_turns', 0)}")
    print(f"Total Cost: ${summary.get('total_cost_usd', 0):.6f}")
    print(f"Input Tokens: {summary.get('total_input_tokens', 0):,}")
    print(f"Output Tokens: {summary.get('total_output_tokens', 0):,}")

    # Execution Pattern
    print("\n🔗 EXECUTION PATTERN")
    print("-" * 80)
    pattern = analysis['execution_pattern']
    print(f"Type: {pattern['type']}")
    if pattern['chains']:
        print("Skill Chain:")
        for i, skill in enumerate(pattern['chains'], 1):
            print(f"  {i}. {skill}")

    if analysis['skill_flow']:
        print("\nFlow Relationships:")
        for flow in analysis['skill_flow']:
            print(f"  {flow['from']} → {flow['to']}")

    # Skill Invocations
    print("\n🎯 SKILL INVOCATIONS")
    print("-" * 80)
    if analysis['skill_calls']:
        for i, call in enumerate(analysis['skill_calls'], 1):
            status = "✅" if call.get('success') else "❌"
            completed = " (completed)" if call.get('completed') else ""
            agent_id = f" | Agent: {call.get('agent_id')}" if call.get('agent_id') else ""
            exec_status = f" | Status: {call.get('status')}" if call.get('status') else ""
            print(f"{i}. {status} {call['name']}{completed}{agent_id}{exec_status}")
    else:
        print("No skill invocations found")

    # Success Rate
    print("\n📈 SUCCESS RATE")
    print("-" * 80)
    if 'skills' in analysis['success_rate']:
        skills_rate = analysis['success_rate']['skills']
        percentage = (skills_rate['success'] / skills_rate['total'] * 100) if skills_rate['total'] > 0 else 0
        print(f"Skills: {skills_rate['success']}/{skills_rate['total']} ({percentage:.1f}%)")

    overall_rate = analysis['success_rate']
    if overall_rate['total'] > 0:
        overall_percentage = (overall_rate['success'] / overall_rate['total'] * 100)
        print(f"Overall: {overall_rate['success']}/{overall_rate['total']} ({overall_percentage:.1f}%)")

    # Tool Usage
    print("\n🛠️  TOOL USAGE BREAKDOWN")
    print("-" * 80)
    if analysis['tool_usage']:
        sorted_tools = sorted(analysis['tool_usage'].items(), key=lambda x: x[1], reverse=True)
        for tool, count in sorted_tools:
            print(f"  {tool}: {count}")
    else:
        print("No tool usage recorded")

    # Timeline
    print("\n⏱️  EXECUTION TIMELINE")
    print("-" * 80)
    if analysis['timeline']:
        for i, entry in enumerate(analysis['timeline'], 1):
            if entry['type'] == 'assistant':
                print(f"{i}. Assistant Message")
                print(f"   UUID: {entry['uuid']}")
                print(f"   Input: {entry['input_tokens']} tokens | Output: {entry['output_tokens']} tokens")
                print(f"   Tool Uses: {entry['tool_use_count']}")
            elif entry['type'] == 'tool_result':
                status = "✅" if entry.get('success') else "❌"
                print(f"{i}. {status} {entry['command']} ({entry.get('status', 'unknown')})")

    # Environment
    print("\n🌐 ENVIRONMENT")
    print("-" * 80)
    print(f"Available Tools: {summary.get('available_tools', 0)}")
    print(f"Available Skills: {summary.get('available_skills', 0)}")
    print(f"Available Agents: {summary.get('available_agents', 0)}")

    # Verification Details
    print("\n✅ VERIFICATION DETAILS")
    print("-" * 80)
    print("Pattern Validation:")
    if pattern['type'] == 'skill_chain':
        print("  ✓ Multi-skill execution detected")
        if len(pattern['chains']) >= 3:
            print("  ✓ Chain of 3+ skills validated")
        if analysis['skill_flow']:
            print("  ✓ Sequential flow documented")

    if 'skills' in analysis['success_rate']:
        rate = analysis['success_rate']['skills']
        if rate['success'] == rate['total']:
            print("  ✓ All skills completed successfully")
        else:
            print(f"  ⚠ {rate['total'] - rate['success']} skill(s) failed")

    print("\n" + "=" * 80)

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: python simple_tool_analyzer.py <path_to_json_log>")
        sys.exit(1)

    json_path = sys.argv[1]
    try:
        analysis = analyze_json_log(json_path)
        print_analysis(analysis)
    except Exception as e:
        print(f"Error analyzing file: {e}", file=sys.stderr)
        import traceback
        traceback.print_exc()
        sys.exit(1)
