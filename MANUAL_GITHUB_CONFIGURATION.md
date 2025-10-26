# Manual GitHub Configuration Steps

This guide covers the remaining GitHub configuration steps that need to be completed manually via the GitHub web interface.

## Repository Information
- **Repository**: https://github.com/bringoneops/terraform-infrastructure
- **Owner**: bringoneops
- **AWS Account ID**: 008151864528
- **AWS Region**: us-east-1

## Completed Steps ✅

1. ✅ GitHub repository created
2. ✅ All workflow files pushed to main branch
3. ✅ Environment configuration files pushed (dev, staging, prod)
4. ✅ `develop` and `staging` branches created
5. ✅ AWS OIDC provider configured
6. ✅ IAM roles created for all environments
7. ✅ S3 state buckets and DynamoDB tables created

## Required Manual Configuration Steps

### Step 1: Configure GitHub Environments

You need to create three GitHub Environments with specific secrets and protection rules.

#### 1.1 Create Dev Environment

1. Go to: https://github.com/bringoneops/terraform-infrastructure/settings/environments
2. Click **"New environment"**
3. Name: `dev`
4. Click **"Configure environment"**

**Add Environment Secret:**
- Click **"Add secret"**
- Name: `AWS_ROLE_ARN`
- Value: `arn:aws:iam::008151864528:role/dev-terraform-role`
- Click **"Add secret"**

**Protection Rules:**
- ✅ Leave "Required reviewers" unchecked (auto-deploy)
- ✅ Leave "Wait timer" at 0 (immediate deployment)
- Deployment branches: Select **"Protected branches only"**

#### 1.2 Create Staging Environment

1. Click **"New environment"**
2. Name: `staging`
3. Click **"Configure environment"**

**Add Environment Secret:**
- Click **"Add secret"**
- Name: `AWS_ROLE_ARN`
- Value: `arn:aws:iam::008151864528:role/staging-terraform-role`
- Click **"Add secret"**

**Protection Rules:**
- ✅ Leave "Required reviewers" unchecked (auto-deploy)
- ✅ Leave "Wait timer" at 0 (immediate deployment)
- Deployment branches: Select **"Protected branches only"**

#### 1.3 Create Prod Environment

1. Click **"New environment"**
2. Name: `prod`
3. Click **"Configure environment"**

**Add Environment Secret:**
- Click **"Add secret"**
- Name: `AWS_ROLE_ARN`
- Value: `arn:aws:iam::008151864528:role/prod-terraform-role`
- Click **"Add secret"**

**Protection Rules:**
- ✅ **Enable "Required reviewers"**
- Add yourself or team members as required reviewers
- Minimum: 1 reviewer
- ✅ Optional: Enable "Wait timer" (e.g., 5 minutes for final safety check)
- Deployment branches: Select **"Protected branches only"**

### Step 2: Configure Branch Protection Rules

Protect the main branches to enforce the SDLC workflow.

#### 2.1 Protect Main Branch

1. Go to: https://github.com/bringoneops/terraform-infrastructure/settings/branches
2. Click **"Add branch protection rule"**
3. Branch name pattern: `main`

**Settings to Enable:**
- ✅ **Require a pull request before merging**
  - ✅ Require approvals: 1
  - ✅ Dismiss stale pull request approvals when new commits are pushed
- ✅ **Require status checks to pass before merging**
  - ✅ Require branches to be up to date before merging
  - Search and add these required status checks:
    - `terraform-validate (prod)`
    - `terraform-plan (prod)`
    - `security-scan (prod)`
- ✅ **Require conversation resolution before merging**
- ✅ **Do not allow bypassing the above settings**
- ✅ **Restrict who can push to matching branches**
  - Add only CI/CD service accounts or maintainers

Click **"Create"** to save.

#### 2.2 Protect Staging Branch

1. Click **"Add branch protection rule"**
2. Branch name pattern: `staging`

**Settings to Enable:**
- ✅ **Require a pull request before merging**
  - ✅ Require approvals: 1
- ✅ **Require status checks to pass before merging**
  - ✅ Require branches to be up to date before merging
  - Required status checks:
    - `terraform-validate (staging)`
    - `terraform-plan (staging)`
    - `security-scan (staging)`
- ✅ **Require conversation resolution before merging**

Click **"Create"** to save.

#### 2.3 Protect Develop Branch

1. Click **"Add branch protection rule"**
2. Branch name pattern: `develop`

**Settings to Enable:**
- ✅ **Require status checks to pass before merging**
  - ✅ Require branches to be up to date before merging
  - Required status checks:
    - `terraform-validate (dev)`
    - `terraform-plan (dev)`
    - `security-scan (dev)`

Click **"Create"** to save.

### Step 3: Verify Configuration

After completing the above steps, verify the setup:

1. **Check Environments**:
   - Go to: https://github.com/bringoneops/terraform-infrastructure/settings/environments
   - Confirm all 3 environments exist (dev, staging, prod)
   - Verify each has the `AWS_ROLE_ARN` secret set

2. **Check Branch Protection**:
   - Go to: https://github.com/bringoneops/terraform-infrastructure/settings/branches
   - Confirm protection rules for: main, staging, develop

3. **Test the Pipeline**:
   ```bash
   # Create a test branch
   git checkout develop
   git checkout -b feature/test-pipeline
   
   # Make a small change
   echo "# Test" >> environments/dev/test.txt
   git add environments/dev/test.txt
   git commit -m "test: Verify CI/CD pipeline"
   git push origin feature/test-pipeline
   
   # Create PR to develop
   gh pr create --base develop --title "Test CI/CD Pipeline" --body "Testing automated workflow"
   ```

## SDLC Workflow Summary

Once configured, your workflow will be:

1. **Feature Development**:
   ```
   feature/* → develop (auto-deploys to dev)
   ```

2. **Staging Release**:
   ```
   develop → staging (auto-deploys to staging)
   ```

3. **Production Release**:
   ```
   staging → main (requires approval, deploys to prod)
   ```

## AWS Resources Created

The following AWS resources are already deployed and ready to use:

### OIDC Provider
- ARN: `arn:aws:iam::008151864528:oidc-provider/token.actions.githubusercontent.com`

### IAM Roles
- Dev: `arn:aws:iam::008151864528:role/dev-terraform-role`
- Staging: `arn:aws:iam::008151864528:role/staging-terraform-role`
- Prod: `arn:aws:iam::008151864528:role/prod-terraform-role`

### S3 State Buckets
- Dev: `terraform-state-dev-008151864528-us-east-1`
- Staging: `terraform-state-staging-008151864528-us-east-1`
- Prod: `terraform-state-prod-008151864528-us-east-1`

### DynamoDB Lock Tables
- Dev: `terraform-state-locks-dev`
- Staging: `terraform-state-locks-staging`
- Prod: `terraform-state-locks-prod`

## Security Features Enabled

✅ OIDC authentication (no long-lived credentials)
✅ Least privilege IAM roles per environment
✅ Security scanning (tfsec, checkov)
✅ Encrypted S3 state with versioning
✅ State locking with DynamoDB
✅ Point-in-time recovery for state
✅ Lifecycle policies for cost optimization
✅ CloudWatch logging for S3 operations

## Troubleshooting

### Issue: Status checks not appearing in PR
**Solution**: The status checks only appear after the first workflow run. Push a commit to trigger the workflows.

### Issue: Workflow fails with "could not assume role"
**Solution**: 
1. Verify the environment secret `AWS_ROLE_ARN` is set correctly
2. Check the IAM role trust policy allows GitHub Actions
3. Verify the repository name matches in the OIDC conditions

### Issue: Terraform state lock errors
**Solution**: Check DynamoDB table exists and the IAM role has permissions to read/write locks.

## Next Steps

After completing manual configuration:

1. ✅ Test the pipeline with a feature branch
2. ✅ Verify dev environment auto-deploys
3. ✅ Test promotion to staging
4. ✅ Test production deployment with approval
5. ✅ Monitor CloudWatch logs for any issues
6. ✅ Review security scan results
7. ✅ Add actual infrastructure to environment configs

## Support

For issues or questions:
- Review workflow logs: https://github.com/bringoneops/terraform-infrastructure/actions
- Check AWS CloudWatch logs in us-east-1
- Review this documentation: https://github.com/bringoneops/terraform-infrastructure
