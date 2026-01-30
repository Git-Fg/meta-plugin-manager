# CLI Automation Reference

## Navigation

| If you need... | Read this section... |
| :------------- | :------------------- |
| Quick reference | ## Quick Reference |
| Claude automates | ## What Claude Automates |
| Authentication gates | ## Authentication Gates |
| Human action required | ## When Human Action is Required |
| Summary | ## Summary |

## TL;DR

Claude automates ALL CLI/API operations. Only manual human actions are email links, SMS codes, manual approvals, and 3D Secure flows.

---

## Quick Reference

| Action                        | Claude does it?                   |
| ----------------------------- | --------------------------------- |
| Deploy to Vercel              | YES                               |
| Create Stripe webhook         | YES                               |
| Run xcodebuild                | YES                               |
| Write .env file               | YES                               |
| Create Upstash DB             | YES                               |
| Install npm packages          | YES                               |
| Create GitHub repo            | YES                               |
| Run tests                     | YES                               |
| Create Supabase project       | NO (then CLI for everything else) |
| Click email verification link | NO                                |
| Enter credit card with 3DS    | NO                                |

**Default answer: YES.** Unless explicitly in the "NO" category, Claude automates it.

## What Claude Automates

### Vercel

- `vercel --yes` - Create and deploy projects
- `vercel env add` - Set environment variables
- `vercel --prod` - Trigger deployments
- `vercel ls` - Get deployment URLs

### Stripe

- Stripe API via curl/fetch - Create webhook endpoints
- `stripe trigger` - Trigger test events
- Manage customers/products via API

### Databases

- `supabase` CLI - Initialize, link, migrate, deploy functions
- `upstash` CLI - Create Redis/Kafka databases
- `pscale` CLI - Create databases, branches, deploy requests

### GitHub

- `gh repo create` - Create repo
- `gh secret set` - Manage secrets
- `gh workflow run` - Trigger workflows

### Build & Test

- `npm run build` - Run builds
- `npm test` - Run tests
- `xcodebuild` - Build iOS/macOS projects

## Authentication Gates

When Claude tries to use CLI/API and gets authentication error:

1. This is NOT a failure - it's a gate
2. Create `checkpoint:human-action` dynamically
3. Provide exact authentication steps
4. Verify after authentication
5. Retry the original task

## EDGE: When Human Action is Required

- Email verification links (no API)
- SMS 2FA codes (no API)
- Manual account approvals (no automation path)
- Credit card 3D Secure flows

## Summary

The rule: If Claude CAN do it, Claude MUST do it.

---

## ANTI-PATTERN: Common Mistakes

❌ **Wrong:**
"I can't run this command, it needs authentication" → Ask user to do it

✅ **Correct:**
Run command → Get auth error → Create checkpoint:human-action with exact steps → Verify → Retry

❌ **Wrong:**
"This requires a browser" → Skip operation

✅ **Correct:**
Check if browser automation is possible → Use MCP tools → Escalate only if truly required

❌ **Wrong:**
"Manual process required" → Assume no automation exists

✅ **Correct:**
Research API/CLI options → Try automation → Document gate if truly required
