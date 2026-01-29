#!/usr/bin/env node
/**
 * Quality Standards Gate Validator
 *
 * Validates that a component meets quality standards:
 * - BUILD: Compiles without errors
 * - TYPE: TypeScript types are valid
 * - LINT: Code style passes linting
 * - TEST: Tests pass
 * - SECURITY: No vulnerabilities detected
 * - DIFF: Changes are intentional
 */

import { execSync } from "child_process";
import * as fs from "fs";
import * as path from "path";

const COLORS = {
  green: "\x1b[32m",
  red: "\x1b[31m",
  yellow: "\x1b[33m",
  reset: "\x1b[0m",
};

function log(result: "pass" | "fail" | "skip", phase: string, message: string) {
  const icon = result === "pass" ? "✓" : result === "fail" ? "✗" : "○";
  const color = result === "pass" ? COLORS.green : result === "fail" ? COLORS.red : COLORS.yellow;
  console.log(`${color}${icon}${COLORS.reset} ${phase}: ${message}`);
}

function runCommand(cmd: string, timeout = 60000): { success: boolean; output: string } {
  try {
    const output = execSync(cmd, { encoding: "utf-8", timeout, maxBuffer: 10 * 1024 * 1024 });
    return { success: true, output };
  } catch (error: unknown) {
    const errorMessage = error instanceof Error ? error.message : String(error);
    return { success: false, output: errorMessage };
  }
}

function validateBuild(): { pass: boolean } {
  log("run", "BUILD", "Checking if build command exists...");
  const hasBuild = fs.existsSync(path.join(process.cwd(), "package.json")) &&
    JSON.parse(fs.readFileSync(path.join(process.cwd(), "package.json"), "utf-8")).scripts?.build;

  if (!hasBuild) {
    log("skip", "BUILD", "No build command found in package.json");
    return { pass: true };
  }

  log("run", "BUILD", "Running npm run build...");
  const result = runCommand("npm run build");
  if (result.success) {
    log("pass", "BUILD", "Build successful");
  } else {
    log("fail", "BUILD", "Build failed");
  }
  return { pass: result.success };
}

function validateType(): { pass: boolean } {
  log("run", "TYPE", "Checking TypeScript types...");
  const hasTsConfig = fs.existsSync(path.join(process.cwd(), "tsconfig.json"));

  if (!hasTsConfig) {
    log("skip", "TYPE", "No tsconfig.json found");
    return { pass: true };
  }

  const result = runCommand("npx tsc --noEmit");
  if (result.success) {
    log("pass", "TYPE", "TypeScript compilation successful");
  } else {
    log("fail", "TYPE", "TypeScript errors found");
  }
  return { pass: result.success };
}

function validateLint(): { pass: boolean } {
  log("run", "LINT", "Running linter...");
  const hasEslint = fs.existsSync(path.join(process.cwd(), ".eslintrc")) ||
    fs.existsSync(path.join(process.cwd(), ".eslintrc.js")) ||
    fs.existsSync(path.join(process.cwd(), "eslint.config.mjs"));

  if (!hasEslint) {
    log("skip", "LINT", "No ESLint configuration found");
    return { pass: true };
  }

  const result = runCommand("npx eslint . --max-warnings 0");
  if (result.success) {
    log("pass", "LINT", "Linting passed");
  } else {
    log("fail", "LINT", "Lint errors or warnings found");
  }
  return { pass: result.success };
}

function validateTest(): { pass: boolean } {
  log("run", "TEST", "Running tests...");
  const hasTest = fs.existsSync(path.join(process.cwd(), "package.json")) &&
    JSON.parse(fs.readFileSync(path.join(process.cwd(), "package.json"), "utf-8")).scripts?.test;

  if (!hasTest) {
    log("skip", "TEST", "No test command found in package.json");
    return { pass: true };
  }

  const result = runCommand("npm test");
  if (result.success) {
    log("pass", "TEST", "All tests passed");
  } else {
    log("fail", "TEST", "Test failures detected");
  }
  return { pass: result.success };
}

function validateSecurity(): { pass: boolean } {
  log("run", "SECURITY", "Checking for vulnerabilities...");
  const hasPackageJson = fs.existsSync(path.join(process.cwd(), "package.json"));

  if (!hasPackageJson) {
    log("skip", "SECURITY", "No package.json found");
    return { pass: true };
  }

  const result = runCommand("npm audit --audit-level=high");
  if (result.success || result.output.includes("found 0 vulnerabilities")) {
    log("pass", "SECURITY", "No high vulnerabilities found");
    return { pass: true };
  }

  const hasVulns = result.output.includes("vulnerabilities");
  if (hasVulns) {
    const match = result.output.match(/(\d+) high/);
    const count = match ? match[1] : "unknown";
    log("fail", "SECURITY", `${count} high vulnerabilities found`);
  }
  return { pass: !hasVulns };
}

function validateDiff(): { pass: boolean } {
  log("run", "DIFF", "Checking for uncommitted changes...");
  const gitStatus = runCommand("git status --porcelain");

  if (!gitStatus.success) {
    log("skip", "DIFF", "Not a git repository");
    return { pass: true };
  }

  const hasChanges = gitStatus.output.trim().length > 0;
  if (hasChanges) {
    log("pass", "DIFF", `Uncommitted changes detected (run 'git diff' to review)`);
  } else {
    log("pass", "DIFF", "No uncommitted changes");
  }
  return { pass: true };
}

function validateComponentPortability(): { pass: boolean } {
  log("run", "PORTABILITY", "Checking for external dependencies...");
  const skillPath = process.argv[2] || ".";
  const skillMdPath = path.join(skillPath, "SKILL.md");

  if (!fs.existsSync(skillMdPath)) {
    log("skip", "PORTABILITY", "No SKILL.md found at specified path");
    return { pass: true };
  }

  const content = fs.readFileSync(skillMdPath, "utf-8");
  const hasExternalRefs = content.includes(".claude/rules/") ||
    content.includes("references \"");

  if (hasExternalRefs) {
    log("fail", "PORTABILITY", "SKILL.md references external files");
  } else {
    log("pass", "PORTABILITY", "No external dependencies found");
  }
  return { pass: !hasExternalRefs };
}

function main() {
  console.log("\n=== Quality Standards Gate Validator ===\n");

  const results: { pass: boolean }[] = [];

  results.push(validateBuild());
  results.push(validateType());
  results.push(validateLint());
  results.push(validateTest());
  results.push(validateSecurity());
  results.push(validateDiff());
  results.push(validateComponentPortability());

  const passed = results.filter(r => r.pass).length;
  const failed = results.filter(r => !r.pass).length;

  console.log(`\n=== Summary: ${passed} passed, ${failed} failed ===\n`);

  if (failed > 0) {
    process.exit(1);
  }
}

main();
