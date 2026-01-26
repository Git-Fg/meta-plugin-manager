---
name: deploy-production
description: Deploy application to production
disable-model-invocation: true
user-invocable: true
context: fork
agent: Plan
allowed-tools: Read, Bash(docker:*), Bash(kubectl:*)
---

## DEPLOYMENT_START

⚠️ **DANGER ZONE** - Production Deployment

You are deploying $ARGUMENTS to production. This is a safety-critical operation.

⚠️ **CRITICAL SAFETY CHECK**: You must verify all pre-deployment requirements BEFORE proceeding.

**Pre-Deployment Verification Checklist**:

- [ ] All tests pass locally (`npm test` or `yarn test`)
- [ ] Recent commits are reviewed and approved
- [ ] Database migrations are tested and ready
- [ ] Backups are current and tested
- [ ] Deployment plan is documented
- [ ] Rollback plan is prepared
- [ ] Monitoring and alerts are configured
- [ ] Team is notified of deployment window

**DO NOT PROCEED** unless ALL items are verified.

**Deployment Steps** (if safe to proceed):

1. **Verify pre-deployment checklist** (completed above)

2. **Build Docker image**:
   ```bash
   docker build -t myapp:$VERSION .
   docker tag myapp:$VERSION myapp:latest
   ```

3. **Push to registry**:
   ```bash
   docker push myapp:$VERSION
   docker push myapp:latest
   ```

4. **Update Kubernetes**:
   ```bash
   kubectl apply -f manifests/production/
   kubectl rollout status deployment/myapp
   ```

5. **Monitor deployment**:
   ```bash
   kubectl get pods -l app=myapp
   ```

**Rollback Procedure** (if deployment fails):
```bash
kubectl rollout undo deployment/myapp
```

**Expected Output**:
```
Production Deployment: INITIATED
Pre-flight Checks: ✓ PASSED
Docker Build: ✓ COMPLETE
Registry Push: ✓ COMPLETE
Kubernetes Update: ✓ COMPLETE
Deployment Status: SUCCESS

## DEPLOYMENT_COMPLETE
```

Execute deployment with full safety checks.

## DEPLOYMENT_COMPLETE
