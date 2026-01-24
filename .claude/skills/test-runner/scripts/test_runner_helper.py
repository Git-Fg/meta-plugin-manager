#!/usr/bin/env python3
"""
Helper script for test-runner complex operations
Purpose: JSON parsing, batch operations, and lifecycle tracking
Usage: Call from test-runner skill for complex operations
Natural language instructions remain in SKILL.md
"""

import json
import sys
import os
from pathlib import Path
from typing import Optional, Dict, Any, List
from dataclasses import dataclass, field
from datetime import datetime

# Configuration - default test plan location
DEFAULT_TEST_PLAN = Path("tests/skill_test_plan.json")


@dataclass
class TestResult:
    """Represents a test execution result"""
    autonomy_score: int = 0
    grade: str = "Unknown"
    permission_denials: int = 0
    completion_markers: int = 0
    duration_ms: int = 0
    ndjson_lines: int = 0
    valid_ndjson: bool = False
    
    @classmethod
    def from_json_file(cls, file_path: Path) -> 'TestResult':
        """Parse test result from JSON file"""
        with open(file_path) as f:
            data = json.load(f)
            
        # Extract permission denials count
        permission_denials = data.get('result', {}).get('permission_denials', [])
        denials_count = len(permission_denials) if isinstance(permission_denials, list) else 0
        
        # Calculate autonomy score
        if denials_count == 0:
            autonomy_score = 100
            grade = "Excellence"
        elif denials_count <= 3:
            autonomy_score = 90
            grade = "Good"
        elif denials_count <= 5:
            autonomy_score = 80
            grade = "Acceptable"
        else:
            autonomy_score = 70
            grade = "Fail"
            
        # Count completion markers
        completion_markers = 0
        for line in data:
            content = line.get('content', [])
            if isinstance(content, list):
                for item in content:
                    if isinstance(item, dict) and 'text' in item:
                        if 'COMPLETE' in str(item['text']):
                            completion_markers += 1
            
        # Get duration and line count
        duration_ms = data.get('result', {}).get('duration_ms', 0)
        ndjson_lines = 0  # This would need to be passed or calculated externally
        
        return cls(
            autonomy_score=autonomy_score,
            grade=grade,
            permission_denials=denials_count,
            completion_markers=completion_markers,
            duration_ms=duration_ms,
            ndjson_lines=ndjson_lines,
            valid_ndjson=ndjson_lines == 3
        )
    
    def to_dict(self) -> Dict[str, Any]:
        """Convert to dictionary for JSON output"""
        return {
            'autonomy_score': self.autonomy_score,
            'grade': self.grade,
            'permission_denials': self.permission_denials,
            'completion_markers': self.completion_markers,
            'duration_ms': self.duration_ms,
            'ndjson_lines': self.ndjson_lines,
            'valid_ndjson': self.valid_ndjson
        }


class TestPlanManager:
    """Manages test plan JSON operations"""
    
    def __init__(self, plan_path: Path = DEFAULT_TEST_PLAN):
        self.plan_path = plan_path
        self.data = self._load_plan()
    
    def _load_plan(self) -> Dict[str, Any]:
        """Load test plan JSON"""
        if not self.plan_path.exists():
            print(f"ERROR: Test plan not found: {self.plan_path}")
            sys.exit(1)
        
        with open(self.plan_path) as f:
            return json.load(f)
    
    def _save_plan(self) -> None:
        """Save test plan JSON"""
        with open(self.plan_path, 'w') as f:
            json.dump(self.data, f, indent=2)
    
    def get_all_tests(self) -> List[Dict[str, Any]]:
        """Get all tests - handles both flat structure and phased structure"""
        # Check if it's a flat structure (single test object)
        if 'test_id' in self.data:
            return [self.data]

        # Otherwise, handle phased structure
        tests = []
        for phase in self.data.get('test_plan', {}).get('phases', []):
            if 'tests' in phase and phase['tests']:
                tests.extend(phase['tests'])
        return tests
    
    def find_next_test(self) -> Optional[str]:
        """Find the next NOT_STARTED test"""
        # Check if it's a flat structure (single test object)
        if 'test_id' in self.data:
            if self.data.get('status') == 'NOT_STARTED':
                return self.data.get('test_id')
            return None

        # Otherwise, handle phased structure
        for phase in self.data.get('test_plan', {}).get('phases', []):
            for test in phase.get('tests', []):
                if test.get('status') == 'NOT_STARTED':
                    return test.get('test_id')
        return None
    
    def update_test_status(self, test_id: str, status: str,
                          autonomy: Optional[str] = None,
                          duration: Optional[str] = None) -> None:
        """Update test status and metrics"""
        # Check if it's a flat structure (single test object)
        if 'test_id' in self.data:
            if self.data.get('test_id') == test_id:
                self.data['status'] = status

                if autonomy:
                    self.data['autonomy_score'] = int(autonomy)

                if duration:
                    self.data['duration_ms'] = int(duration)

                self._save_plan()
                print(f"Updated test {test_id} to status {status}")
                return
            else:
                print(f"ERROR: Test {test_id} not found")
                sys.exit(1)

        # Otherwise, handle phased structure
        found = False
        for phase in self.data.get('test_plan', {}).get('phases', []):
            for test in phase.get('tests', []):
                if test.get('test_id') == test_id:
                    found = True
                    test['status'] = status

                    if autonomy:
                        test['autonomy_score'] = int(autonomy)

                    if duration:
                        test['duration_ms'] = int(duration)
                    break

        if not found:
            print(f"ERROR: Test {test_id} not found")
            sys.exit(1)

        self._save_plan()
        print(f"Updated test {test_id} to status {status}")
    
    def get_progress(self) -> Dict[str, int]:
        """Get test progress statistics"""
        tests = self.get_all_tests()
        total = len(tests)
        completed = sum(1 for t in tests if t.get('status') == 'COMPLETED')
        failed = sum(1 for t in tests if t.get('status') == 'FAILED')
        not_started = sum(1 for t in tests if t.get('status') == 'NOT_STARTED')
        
        return {
            'total': total,
            'completed': completed,
            'failed': failed,
            'not_started': not_started
        }
    
    def update_lifecycle_stage(self, test_id: str, stage: str) -> None:
        """Update test lifecycle stage"""
        # Check if it's a flat structure (single test object)
        if 'test_id' in self.data:
            if self.data.get('test_id') == test_id:
                self.data['lifecycle_stage'] = stage
                self._save_plan()
                print(f"Updated test {test_id} to lifecycle stage: {stage}")
                return
            else:
                print(f"ERROR: Test {test_id} not found")
                sys.exit(1)

        # Otherwise, handle phased structure
        found = False
        for phase in self.data.get('test_plan', {}).get('phases', []):
            for test in phase.get('tests', []):
                if test.get('test_id') == test_id:
                    found = True
                    test['lifecycle_stage'] = stage
                    break

        if not found:
            print(f"ERROR: Test {test_id} not found")
            sys.exit(1)

        self._save_plan()
        print(f"Updated test {test_id} to lifecycle stage: {stage}")
    
    def mark_phase_complete(self, phase_number: int) -> None:
        """Mark a phase as complete (phased structure only)"""
        # Check if it's a flat structure
        if 'test_id' in self.data:
            print("ERROR: Phase operations not available for flat test structure")
            sys.exit(1)

        # Handle phased structure
        for phase in self.data.get('test_plan', {}).get('phases', []):
            if phase.get('phase') == phase_number:
                phase['status'] = 'COMPLETED'
                break

        self._save_plan()
        print(f"Marked phase {phase_number} as complete")
    
    def add_finding(self, test_id: str, finding: str) -> None:
        """Add finding to test record"""
        # Check if it's a flat structure (single test object)
        if 'test_id' in self.data:
            if self.data.get('test_id') == test_id:
                if 'findings' not in self.data:
                    self.data['findings'] = []
                self.data['findings'].append(finding)
                self._save_plan()
                print(f"Added finding to test {test_id}")
                return
            else:
                print(f"ERROR: Test {test_id} not found")
                sys.exit(1)

        # Otherwise, handle phased structure
        found = False
        for phase in self.data.get('test_plan', {}).get('phases', []):
            for test in phase.get('tests', []):
                if test.get('test_id') == test_id:
                    found = True
                    if 'findings' not in test:
                        test['findings'] = []
                    test['findings'].append(finding)
                    break

        if not found:
            print(f"ERROR: Test {test_id} not found")
            sys.exit(1)

        self._save_plan()
        print(f"Added finding to test {test_id}")


def find_next_test(manager: TestPlanManager) -> None:
    """Command: find-next"""
    next_test = manager.find_next_test()
    if next_test:
        print(next_test)
    else:
        print("No more tests to run")
        sys.exit(1)


def update_status(manager: TestPlanManager, test_id: str, status: str,
                 autonomy: Optional[str] = None,
                 duration: Optional[str] = None) -> None:
    """Command: update-status"""
    if not test_id or not status:
        print("ERROR: test_id and status are required")
        sys.exit(1)
    
    manager.update_test_status(test_id, status, autonomy, duration)


def show_progress(manager: TestPlanManager) -> None:
    """Command: progress"""
    progress = manager.get_progress()
    print(f"Progress: {progress['completed']}/{progress['total']} completed, "
          f"{progress['failed']} failed, {progress['not_started']} remaining")


def analyze_output(file_path: str) -> None:
    """Command: analyze"""
    path = Path(file_path)

    if not path.exists():
        print(f"ERROR: Output file not found: {path}")
        sys.exit(1)

    # Read NDJSON (newline-delimited JSON)
    try:
        with open(path) as f:
            lines = f.readlines()
        ndjson_lines = len(lines)

        # Parse all JSON objects
        data = []
        for line in lines:
            line = line.strip()
            if line:
                try:
                    data.append(json.loads(line))
                except json.JSONDecodeError:
                    pass  # Skip invalid lines

        if ndjson_lines != 3:
            print(f"WARNING: Expected 3 lines, got {ndjson_lines}")
    except Exception as e:
        print(f"ERROR: Failed to parse file: {path}")
        print(f"Run 'jq . < \"{path}\"' to see validation details")
        sys.exit(2)

    # Extract result object (last line typically contains result)
    result_obj = None
    for item in data:
        if isinstance(item, dict) and item.get('type') == 'result':
            result_obj = item
            break

    if not result_obj:
        result_obj = data[-1] if data else {}

    # Calculate metrics
    permission_denials = result_obj.get('permission_denials', [])
    denials_count = len(permission_denials) if isinstance(permission_denials, list) else 0

    # Calculate autonomy score
    if denials_count == 0:
        autonomy_score = 100
        grade = "Excellence"
    elif denials_count <= 3:
        autonomy_score = 90
        grade = "Good"
    elif denials_count <= 5:
        autonomy_score = 80
        grade = "Acceptable"
    else:
        autonomy_score = 70
        grade = "Fail"

    # Count completion markers
    completion_markers = 0
    for item in data:
        content = item.get('content', [])
        if isinstance(content, list):
            for c in content:
                if isinstance(c, dict) and 'text' in c:
                    if 'COMPLETE' in str(c['text']):
                        completion_markers += 1

    # Get duration
    duration_ms = result_obj.get('duration_ms', 0)

    print(f"Autonomy: {autonomy_score}% ({grade})")
    print(f"Permission denials: {denials_count}")
    print(f"Completion markers: {completion_markers}")
    print(f"Duration: {duration_ms}ms")

    # Output JSON for automation
    print("\n---")
    result_dict = {
        'autonomy_score': autonomy_score,
        'grade': grade,
        'permission_denials': denials_count,
        'completion_markers': completion_markers,
        'duration_ms': duration_ms,
        'ndjson_lines': ndjson_lines,
        'valid_ndjson': ndjson_lines == 3
    }
    print(json.dumps(result_dict, indent=2))


def detect_tool_usage(file_path: str) -> None:
    """Command: detect-tools"""
    path = Path(file_path)

    if not path.exists():
        print(f"ERROR: Output file not found: {path}")
        sys.exit(1)

    # Read NDJSON
    with open(path) as f:
        lines = f.readlines()

    # Parse all JSON objects
    data = []
    for line in lines:
        line = line.strip()
        if line:
            try:
                data.append(json.loads(line))
            except json.JSONDecodeError:
                pass  # Skip invalid lines

    # Count tool invocations (check nested content in assistant messages)
    tools_used = {
        'Skill': 0,
        'TaskList': 0,
        'Read': 0,
        'WriteEdit': 0,
        'Bash': 0
    }

    for item in data:
        # Check at top level
        if item.get('type') == 'tool_use':
            name = item.get('name', '')
            if name == 'Skill':
                tools_used['Skill'] += 1
            elif name in ['TaskList', 'TaskCreate', 'TaskUpdate', 'TaskGet']:
                tools_used['TaskList'] += 1
            elif name == 'Read':
                tools_used['Read'] += 1
            elif name in ['Write', 'Edit']:
                tools_used['WriteEdit'] += 1
            elif name == 'Bash':
                tools_used['Bash'] += 1

        # Check in assistant message content (nested structure)
        message = item.get('message', {})
        content = message.get('content', [])
        if isinstance(content, list):
            for c in content:
                if isinstance(c, dict) and c.get('type') == 'tool_use':
                    name = c.get('name', '')
                    if name == 'Skill':
                        tools_used['Skill'] += 1
                    elif name in ['TaskList', 'TaskCreate', 'TaskUpdate', 'TaskGet']:
                        tools_used['TaskList'] += 1
                    elif name == 'Read':
                        tools_used['Read'] += 1
                    elif name in ['Write', 'Edit']:
                        tools_used['WriteEdit'] += 1
                    elif name == 'Bash':
                        tools_used['Bash'] += 1

    total = sum(tools_used.values())

    output = {
        'tools_used': tools_used,
        'total_tool_invocations': total
    }

    print(json.dumps(output, indent=2))


def analyze_execution(file_path: str) -> None:
    """Command: analyze-execution"""
    print("=== COMPREHENSIVE TEST ANALYSIS ===\n")

    path = Path(file_path)

    # Read NDJSON
    with open(path) as f:
        lines = f.readlines()

    # Parse all JSON objects
    data = []
    for line in lines:
        line = line.strip()
        if line:
            try:
                data.append(json.loads(line))
            except json.JSONDecodeError:
                pass  # Skip invalid lines

    # Run analyze
    analyze_output(file_path)
    print()

    # Run detect-tools
    detect_tool_usage(file_path)
    print()

    # Tool invocation details
    print("### Tool Invocation Details")
    tool_counts = {}
    for item in data:
        # Check top level
        if item.get('type') == 'tool_use':
            name = item.get('name', 'Unknown')
            tool_counts[name] = tool_counts.get(name, 0) + 1

        # Check in assistant message content
        message = item.get('message', {})
        content = message.get('content', [])
        if isinstance(content, list):
            for c in content:
                if isinstance(c, dict) and c.get('type') == 'tool_use':
                    name = c.get('name', 'Unknown')
                    tool_counts[name] = tool_counts.get(name, 0) + 1

    if tool_counts:
        for tool, count in sorted(tool_counts.items()):
            print(f"{tool}: {count} invocations")
    else:
        print("No tool invocations found")

    print()

    # Execution patterns
    print("### Execution Patterns")
    # Check for forked execution
    forked = False
    for item in data:
        message = item.get('message', {})
        content = message.get('content', [])
        if isinstance(content, list):
            for c in content:
                if isinstance(c, dict) and 'text' in c:
                    if 'context: fork' in str(c['text']):
                        forked = True
                        break

    if forked:
        print("✅ Forked execution detected")
    else:
        print("ℹ️ No forked execution detected")

    # Check autonomy
    result_obj = None
    for item in data:
        if isinstance(item, dict) and item.get('type') == 'result':
            result_obj = item
            break

    if result_obj:
        denials = len(result_obj.get('permission_denials', []))
        if denials == 0:
            print("✅ Fully autonomous execution")
        else:
            print(f"⚠️ Required {denials} permission prompts")


def lifecycle_stage(manager: TestPlanManager, test_id: str, stage: str) -> None:
    """Command: lifecycle-stage"""
    if not test_id or not stage:
        print("ERROR: test_id and stage are required")
        sys.exit(1)
    
    manager.update_lifecycle_stage(test_id, stage)


def phase_complete(manager: TestPlanManager, phase_number: int) -> None:
    """Command: phase-complete"""
    if not phase_number:
        print("ERROR: phase number required")
        sys.exit(1)
    
    manager.mark_phase_complete(phase_number)


def add_finding(manager: TestPlanManager, test_id: str, finding: str) -> None:
    """Command: add-finding"""
    if not test_id or not finding:
        print("ERROR: test_id and finding are required")
        sys.exit(1)
    
    manager.add_finding(test_id, finding)


def main():
    """Main CLI entry point"""
    if len(sys.argv) < 2:
        print("Usage: test_runner_helper.py <command> [args...]")
        print("\nCommands:")
        print("  find-next          - Find the next test to run")
        print("  update-status      - Update test status")
        print("  progress          - Show test progress")
        print("  analyze           - Analyze test output")
        print("  detect-tools      - Detect tool usage")
        print("  analyze-execution - Comprehensive analysis")
        print("  lifecycle-stage   - Update test lifecycle stage")
        print("  phase-complete    - Mark phase as complete")
        print("  add-finding       - Add finding to test")
        sys.exit(1)
    
    command = sys.argv[1]
    manager = TestPlanManager()
    
    if command == "find-next":
        find_next_test(manager)
    elif command == "update-status":
        if len(sys.argv) < 4:
            print("Usage: update-status <test_id> <status> [autonomy] [duration]")
            sys.exit(1)
        autonomy = sys.argv[4] if len(sys.argv) > 4 else None
        duration = sys.argv[5] if len(sys.argv) > 5 else None
        update_status(manager, sys.argv[2], sys.argv[3], autonomy, duration)
    elif command == "progress":
        show_progress(manager)
    elif command == "analyze":
        if len(sys.argv) < 3:
            print("Usage: analyze <output_file>")
            sys.exit(1)
        analyze_output(sys.argv[2])
    elif command == "detect-tools":
        if len(sys.argv) < 3:
            print("Usage: detect-tools <output_file>")
            sys.exit(1)
        detect_tool_usage(sys.argv[2])
    elif command == "analyze-execution":
        if len(sys.argv) < 3:
            print("Usage: analyze-execution <output_file>")
            sys.exit(1)
        analyze_execution(sys.argv[2])
    elif command == "lifecycle-stage":
        if len(sys.argv) < 4:
            print("Usage: lifecycle-stage <test_id> <stage>")
            sys.exit(1)
        lifecycle_stage(manager, sys.argv[2], sys.argv[3])
    elif command == "phase-complete":
        if len(sys.argv) < 3:
            print("Usage: phase-complete <phase_number>")
            sys.exit(1)
        phase_complete(manager, int(sys.argv[2]))
    elif command == "add-finding":
        if len(sys.argv) < 4:
            print("Usage: add-finding <test_id> <finding>")
            sys.exit(1)
        # Join all remaining args as finding text
        finding = ' '.join(sys.argv[3:])
        add_finding(manager, sys.argv[2], finding)
    else:
        print(f"Unknown command: {command}")
        sys.exit(1)


if __name__ == "__main__":
    main()
