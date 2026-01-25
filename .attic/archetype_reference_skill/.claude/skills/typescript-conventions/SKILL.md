---
name: typescript-conventions
description: >
  TypeScript code standards for this team. Use when writing TypeScript,
  reviewing types, or architecting modules. Apply these patterns
  automatically whenever writing TypeScript.
user-invocable: false
disable-model-invocation: false
allowed-tools: Read
---

# TypeScript Conventions

When writing TypeScript, follow these conventions:

## Type Strictness

- Always use strict mode: `"strict": true`
- Never use `any` (use `unknown` instead)
- Define explicit return types for functions

## Module Organization

- File structure: `src/<domain>/<feature>/<File.ts>`
- Export only public interfaces from index.ts
- Keep files under 300 lines

## Error Handling

- Never throw bare errors; use typed error classes
- Always include context: `new ValidationError('message', { context })`

## Naming Conventions

- Use PascalCase for types and interfaces
- Use camelCase for variables and functions
- Use UPPER_CASE for constants
- Prefix private members with underscore

## EXAMPLES

See [examples/](examples/) for compliant code samples.

## REFERENCE_SKILL_COMPLETE
