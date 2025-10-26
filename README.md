# Terraform Infrastructure with GitHub Actions CI/CD

Production-grade Terraform infrastructure with automated CI/CD pipelines using GitHub Actions and AWS OIDC authentication.

## 🏗️ Architecture

This repository implements a complete SDLC (Software Development Life Cycle) with three environments:

- **Development** (`develop` branch) - Auto-deploy for rapid iteration
- **Staging** (`staging` branch) - Auto-deploy for integration testing
- **Production** (`main` branch) - Manual approval required for deployments

## 🚀 Features

### Security & Best Practices
- ✅ **AWS OIDC Authentication** - No long-lived credentials stored in GitHub
- ✅ **Least Privilege IAM Roles** - Separate roles per environment
- ✅ **State Encryption** - S3 backend with AES-256 encryption
- ✅ **State Locking** - DynamoDB for concurrent execution protection
- ✅ **Branch Protection** - Required reviews and status checks
- ✅ **Security Scanning** - tfsec and checkov automated scans

### CI/CD Pipeline
- ✅ **Automated Validation** - Syntax checking and formatting
- ✅ **Security Scanning** - Pre-deployment security checks
- ✅ **Cost Estimation** - Infracost integration (optional)
- ✅ **Plan Review** - PR comments with detailed plans
- ✅ **Deployment Tracking** - GitHub Issues for failures
- ✅ **Environment Protection** - Manual approvals for production

## 📁 Repository Structure

```
.
├── .github/
│   └── workflows/
│       ├── terraform-plan.yml      # PR validation workflow
│       └── terraform-apply.yml     # Deployment workflow
├── environments/
│   ├── dev/
│   │   ├── backend.tf             # Dev S3 backend config
│   │   └── main.tf                # Dev infrastructure
│   ├── staging/
│   │   ├── backend.tf             # Staging S3 backend config
│   │   └── main.tf                # Staging infrastructure
│   └── prod/
│       ├── backend.tf             # Prod S3 backend config
│       └── main.tf                # Prod infrastructure
├── infra-mcp-tf/                  # CI/CD infrastructure (Terraform)
│   ├── github-actions-cicd.tf     # AWS OIDC, IAM roles, S3, DynamoDB
│   └── backend-enhancements.tf    # State backend configuration
├── GITHUB_ACTIONS_SETUP.md        # Detailed setup guide
├── GITHUB_REPO_SETUP.sh          # Automated setup script
└── README.md
```

## 🔧 AWS Infrastructure

### OIDC Provider
```
arn:aws:iam::008151864528:oidc-provider/token.actions.githubusercontent.com
```

### IAM Roles
| Environment | Role ARN | Branch |
|-------------|----------|--------|
| Dev | `arn:aws:iam::008151864528:role/dev-terraform-role` | `develop` |
| Staging | `arn:aws:iam::008151864528:role/staging-terraform-role` | `staging` |
| Production | `arn:aws:iam::008151864528:role/prod-terraform-role` | `main` |

### State Backends
| Environment | S3 Bucket | DynamoDB Table |
|-------------|-----------|----------------|
| Dev | `terraform-state-dev-008151864528-us-east-1` | `terraform-state-locks-dev` |
| Staging | `terraform-state-staging-008151864528-us-east-1` | `terraform-state-locks-staging` |
| Production | `terraform-state-prod-008151864528-us-east-1` | `terraform-state-locks-prod` |

## 🚦 SDLC Workflow

### 1. Development Flow
```bash
# Create feature branch
git checkout -b feature/add-vpc

# Make changes to environments/dev/
# Commit and push
git add environments/dev/
git commit -m "Add VPC configuration"
git push origin feature/add-vpc

# Create PR to develop branch
# GitHub Actions will:
#   ✓ Validate Terraform syntax
#   ✓ Run security scans
#   ✓ Generate plan and post to PR
```

### 2. Deploy to Development
```bash
# Merge PR to develop
# GitHub Actions will:
#   ✓ Automatically deploy to dev environment
#   ✓ Post deployment summary
```

### 3. Promote to Staging
```bash
git checkout staging
git merge develop
git push origin staging

# GitHub Actions will:
#   ✓ Automatically deploy to staging environment
```

### 4. Promote to Production
```bash
git checkout main
git merge staging
git push origin main

# GitHub Actions will:
#   ✓ Generate plan
#   ✓ Wait for manual approval (2 reviewers required)
#   ✓ Deploy to production after approval
```

## 📋 Setup Instructions

### Prerequisites
- AWS Account with admin access
- GitHub account with repository access
- GitHub CLI (`gh`) installed
- Terraform >= 1.0 installed

### Quick Start

1. **Run the setup script:**
```bash
chmod +x GITHUB_REPO_SETUP.sh
./GITHUB_REPO_SETUP.sh
```

2. **Or follow manual steps in:**
- `GITHUB_ACTIONS_SETUP.md` - Comprehensive setup guide

### Manual Configuration

If the automated script fails, configure these manually:

#### GitHub Environments
Navigate to: `Settings → Environments`

Create three environments with these secrets:

**Dev Environment:**
- `AWS_ROLE_ARN`: `arn:aws:iam::008151864528:role/dev-terraform-role`
- `AWS_REGION`: `us-east-1`

**Staging Environment:**
- `AWS_ROLE_ARN`: `arn:aws:iam::008151864528:role/staging-terraform-role`
- `AWS_REGION`: `us-east-1`

**Prod Environment:**
- `AWS_ROLE_ARN`: `arn:aws:iam::008151864528:role/prod-terraform-role`
- `AWS_REGION`: `us-east-1`
- Protection rules: 2 required reviewers

#### Branch Protection
Navigate to: `Settings → Branches`

Configure for `main`, `staging`, and `develop`:
- ✅ Require pull request reviews (1-2 approvers)
- ✅ Require status checks: `terraform-validate`, `security-scan`, `terraform-plan`
- ✅ Require conversation resolution
- ✅ Do not allow bypassing

## 🧪 Testing

### Local Testing
```bash
# Validate Terraform
cd environments/dev
terraform init
terraform validate
terraform fmt -check

# Run security scans
tfsec .
checkov -d .
```

### PR Testing
All PRs automatically trigger:
1. Terraform validation
2. Security scanning (tfsec, checkov)
3. Plan generation
4. Cost estimation (if configured)

## 📊 Monitoring

### View Deployments
- GitHub Actions tab: https://github.com/bringoneops/terraform-infrastructure/actions
- Environment deployments: https://github.com/bringoneops/terraform-infrastructure/deployments

### Deployment Failures
Failed deployments automatically create GitHub Issues with:
- Error details
- Environment affected
- Deployment logs link

## 🔒 Security

### Best Practices Implemented
- ✅ No long-lived AWS credentials
- ✅ OIDC token-based authentication
- ✅ Least privilege IAM policies
- ✅ Encrypted S3 state buckets
- ✅ DynamoDB state locking
- ✅ Branch protection rules
- ✅ Required code reviews
- ✅ Automated security scanning

### Security Scanning
- **tfsec**: Static analysis for security issues
- **checkov**: Policy-as-code security scanning

## 💰 Cost Management

### Infracost Integration (Optional)
Add `INFRACOST_API_KEY` secret to enable cost estimation in PRs.

Sign up at: https://www.infracost.io/

## 🤝 Contributing

1. Create feature branch from `develop`
2. Make changes
3. Create PR with detailed description
4. Wait for CI checks to pass
5. Get required approvals
6. Merge after approval

## 📚 Documentation

- [GitHub Actions Setup Guide](GITHUB_ACTIONS_SETUP.md) - Complete setup instructions
- [AWS OIDC Configuration](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services)
- [Terraform S3 Backend](https://www.terraform.io/docs/language/settings/backends/s3.html)

## 📝 License

This infrastructure code is maintained by bringoneops.

## 🆘 Support

For issues or questions:
1. Check the [GitHub Actions Setup Guide](GITHUB_ACTIONS_SETUP.md)
2. Review workflow logs in the Actions tab
3. Create an issue in this repository

## 🔄 Workflow Status

![Terraform Plan](https://github.com/bringoneops/terraform-infrastructure/workflows/Terraform%20Plan/badge.svg)
![Terraform Apply](https://github.com/bringoneops/terraform-infrastructure/workflows/Terraform%20Apply/badge.svg)