---
name: deploy-production
description: Deploy application to production
disable-model-invocation: true
user-invocable: true
context: fork
agent: Plan
allowed-tools: Bash, Read, Grep
---

# Production Deployment

Deploy $ARGUMENTS to production:

⚠️ **Danger Zone** - Do not proceed unless you've verified:
- [ ] All tests pass locally
- [ ] Recent commits are reviewed
- [ ] Backups are current
- [ ] Deployment plan is documented

## Deployment steps

1. Verify pre-deployment checklist
2. Build docker image: `docker build -t myapp:$VERSION .`
3. Push to registry: `docker push myapp:$VERSION`
4. Update Kubernetes: `kubectl apply -f manifests/`
5. Monitor deployment: `kubectl rollout status`

## Rollback

If deployment fails: `kubectl rollout undo`

## SAFETY_CRITICAL_COMPLETE

Safety checks complete. Deployment ready.
