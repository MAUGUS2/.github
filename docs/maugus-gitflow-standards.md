# 🌳 MAUGUS GitFlow Standards - Quality-First Development

> **Professional Git workflow with visual merges, automated quality gates, and protection against common development pitfalls**

## 🎯 Overview

The MAUGUS GitFlow ensures:
- ✅ **Visual merge history** - Clear feature boundaries in git graph
- ✅ **Quality gates** - Automated checks before every commit
- ✅ **Rollback safety** - Easy to revert entire features with single command
- ✅ **Team consistency** - Identical workflow for all developers
- ✅ **Debugging efficiency** - Clear history for `git bisect` and troubleshooting
- ✅ **Anti-fast-forward protection** - Impossible to accidentally create linear history

## 🌳 Branch Strategy

```
main ← develop ← feature/<issue>-<description>
```

### Branch Hierarchy
- **`main`** - Production releases (protected, no direct commits)
- **`develop`** - Development base (protected, only via PR or --no-ff merges)
- **`feature/<issue>-<brief-description>`** - Feature development
- **`hotfix/<issue>-<brief-description>`** - Emergency production fixes
- **`release/<version>`** - Release preparation (optional)

### Branch Naming Convention
```bash
feature/123-add-user-authentication
fix/124-resolve-memory-leak
docs/125-update-api-documentation
hotfix/126-critical-security-patch
refactor/127-optimize-database-queries
```

## 🛡️ Git Configuration (Anti-Fast-Forward Protection)

### Core Protection Settings
```bash
# NEVER fast-forward merges (preserves feature structure)
git config --local merge.ff false

# ONLY fast-forward pulls (prevents unnecessary merge commits)
git config --local pull.ff only

# Auto-setup tracking branches
git config --local branch.autosetupmerge always
git config --local branch.autosetuprebase always
```

### Why These Settings Work

| Configuration | Purpose | Prevents | Example |
|---------------|---------|----------|----------|
| `merge.ff = false` | Forces merge commits for features | Linear history hiding feature boundaries | Always creates visible merge nodes |
| `pull.ff = only` | Clean synchronization | Unnecessary merge commits when pulling | Fast-forward or error (safe) |
| Auto-setup branches | Consistent tracking | Manual branch configuration errors | Automatic remote tracking |

## 🚀 GitFlow Aliases

### Automatic Setup
```bash
# Visual git graph
git graph                    # Beautiful git history visualization

# Safe navigation  
git develop                  # Quick switch to develop branch
git main                     # Quick switch to main branch
git sync-develop             # Checkout develop + pull origin develop
git sync-main                # Checkout main + pull origin main

# Feature workflow
git feature-start <name>     # Create feature branch from current
git feature-finish <name>    # Merge with --no-ff (visual commit)

# Quality helpers
git last                     # Show last commit with details
git unstage <file>           # Unstage specific files
```

## 🎯 Step-by-Step Workflow

### 1. Repository Setup (One-time)
```bash
# Apply MAUGUS standards (includes GitFlow configuration)
curl -sSL https://raw.githubusercontent.com/MAUGUS2/.github/main/scripts/apply-standards.sh | bash

# Verify GitFlow configuration
git config --local --list | grep -E "(merge|pull|alias)"

# Check visual git graph
git graph -10
```

### 2. Start New Feature
```bash
# Always start from latest develop
git sync-develop                          # Alias: checkout develop + pull
git feature-start feature/123-add-auth    # Create feature branch

# Verify branch structure
git branch --show-current                 # Should show: feature/123-add-auth
git graph -5                              # Verify clean branch point
```

### 3. Development with Quality Gates
```bash
# Make your changes...
# Edit files, implement feature

# MANDATORY quality checks before every commit:
pnpm lint && pnpm type-check && pnpm test && pnpm build
# or: npm run lint && npm run type-check && npm run test && npm run build
# or: make quality-check

# Commit with conventional format:
git add .
git commit -m "feat(auth): add JWT token validation middleware

Implements secure token validation for protected API routes.
Includes comprehensive error handling for expired and invalid tokens.
Adds middleware integration with Express.js authentication flow.

Key changes:
- JWT signature verification with configurable secret
- Token expiration validation with grace period
- Custom error responses for different failure modes
- Unit tests covering all authentication scenarios
- Integration with existing user session management

Implements Issue #123"

# Push feature branch
git push -u origin feature/123-add-auth
```

### 4. Create Pull Request
```bash
# Option A: GitHub CLI (recommended)
gh pr create --title "feat(auth): add JWT token validation middleware" \
             --body "$(cat <<'EOF'
## Summary
Implements JWT token validation middleware for secure API access.

## Changes
- Add JWT validation middleware with comprehensive error handling
- Implement token expiration and signature verification  
- Add extensive unit tests for all authentication scenarios
- Update API documentation with authentication examples
- Integrate with existing Express.js middleware stack

## Testing
- [x] Unit tests pass locally (npm test)
- [x] Integration tests with various token scenarios
- [x] Manual testing with valid/invalid/expired tokens
- [x] Performance testing with high request volume
- [x] Security testing with malformed tokens

## Quality Gates
- [x] ESLint passes without warnings
- [x] TypeScript compilation successful
- [x] All tests pass with >90% coverage
- [x] Build process completes successfully
- [x] No secrets or credentials committed

## Breaking Changes
None - backward compatible implementation.

## Documentation
- Updated API documentation with authentication examples
- Added inline code comments for complex validation logic
- Updated README with authentication setup instructions

Implements Issue #123
EOF
)"

# Option B: GitHub Web Interface
# Navigate to repository and click "Compare & pull request"
```

### 5. Merge Feature (After PR Approval)
```bash
# Option A: Via GitHub UI (recommended)
# - Use "Create a merge commit" option (NOT "Squash and merge")
# - GitHub automatically uses --no-ff for merge commits

# Option B: Local merge (advanced users)
git checkout develop
git pull origin develop
git feature-finish feature/123-add-auth

# Add descriptive merge message
git commit --amend -m "merge(auth): integrate Issue #123 - JWT token validation

Merges feature/123-add-auth into develop.
Implements secure JWT token validation middleware for API protection.

Key functionality integrated:
- JWT signature verification with configurable secrets
- Token expiration validation with customizable grace periods
- Comprehensive error handling for authentication failures
- Extensive unit and integration test coverage
- Performance-optimized middleware integration

This merge establishes the authentication foundation for secure API access
across the application, enabling future authorization features and user
session management.

Implements Issue #123"

# Push and cleanup
git push origin develop
git branch -d feature/123-add-auth                    # Delete local branch
git push origin --delete feature/123-add-auth        # Delete remote branch
```

## 🎨 Visual Git Graph Result

With proper `--no-ff` merges, your git graph will display:

```
*   merge(auth): integrate Issue #123 - JWT validation
|\  
| * feat(auth): add comprehensive unit tests
| * feat(auth): implement token expiration handling  
| * feat(auth): add JWT validation middleware
|/  
*   merge(api): integrate Issue #122 - API foundation
|\  
| * feat(api): add error handling middleware
| * feat(api): setup tRPC router configuration
| * feat(api): add type-safe route definitions
|/  
* chore(init): initialize project structure
```

## 🔧 Quality Gates Integration

### Pre-commit Hooks (Husky Setup)
```json
{
  "husky": {
    "hooks": {
      "pre-commit": "lint-staged",
      "commit-msg": "commitlint -E HUSKY_GIT_PARAMS"
    }
  },
  "lint-staged": {
    "*.{js,jsx,ts,tsx}": [
      "eslint --fix",
      "prettier --write"
    ],
    "*.{json,md,yml,yaml}": [
      "prettier --write"
    ]
  },
  "commitlint": {
    "extends": ["@commitlint/config-conventional"]
  }
}
```

### GitHub Actions Integration
```yaml
name: Quality Gates
on: 
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'pnpm'
      
      - name: Install dependencies
        run: pnpm install --frozen-lockfile
      
      - name: Run quality gates
        run: |
          pnpm lint
          pnpm type-check
          pnpm test
          pnpm build
      
      - name: Check git graph integrity
        run: |
          # Verify no fast-forward merges in recent history
          if git log --oneline --merges -10 | grep -v "Merge pull request"; then
            echo "✅ Git graph shows proper merge commits"
          else
            echo "❌ Fast-forward merges detected - check GitFlow configuration"
            exit 1
          fi
```

## 🚫 Anti-Patterns (Quality Killers)

### ❌ Never Do These
```bash
# NEVER: Fast-forward merges
git merge feature/branch              # Creates linear history

# NEVER: Direct commits to protected branches  
git checkout develop
git commit -m "quick fix"             # Should be in feature branch + PR

# NEVER: Skip quality gates
git commit -m "fix stuff"             # No lint/test/build verification

# NEVER: Generic commit messages
git commit -m "updates"               # Provides no context
git commit -m "fix"                   # Meaningless
git commit -m "changes"               # Useless for debugging

# NEVER: Large commits
git add . && git commit -m "everything"  # Should be logical, focused commits

# NEVER: Force push to shared branches
git push --force origin develop      # Destroys team history
```

### ✅ Always Do These
```bash
# ALWAYS: Create merge commits for features
git merge --no-ff feature/branch     # Visual merge boundaries

# ALWAYS: Work in feature branches
git checkout -b feature/123-new-feature  # Isolated development

# ALWAYS: Run quality gates
pnpm lint && pnpm test && pnpm build     # Before every commit

# ALWAYS: Write descriptive commits
git commit -m "feat(auth): add OAuth2 integration with Google provider"

# ALWAYS: Keep commits focused
# One logical change per commit, easy to review and revert
```

## 🔍 Verification Commands

### Check GitFlow Configuration
```bash
# Verify git settings
git config --local --list | grep -E "(merge|pull|alias)"

# Expected output:
# merge.ff=false
# pull.ff=only
# alias.graph=log --graph...
# alias.develop=checkout develop
# etc.

# Test git graph visualization
git graph -10

# Verify branch protection (requires GitHub CLI)
gh api repos/OWNER/REPO/branches/main/protection
gh api repos/OWNER/REPO/branches/develop/protection
```

### Verify Repository Health
```bash
# Check for fast-forward merges (should be none)
git log --oneline --merges -20 | head -10

# Verify branch structure
git branch -a

# Check recent commits follow conventional format
git log --oneline -10

# Verify no large commits (>800 lines changed)
git log --stat --oneline -10 | grep -E "files? changed"
```

## 🛠 Troubleshooting

### Common Issues and Solutions

#### 1. Fast-forward merges still happening
```bash
# Problem: merge.ff not set correctly
git config --local merge.ff false

# Verify setting
git config --local merge.ff  # Should output: false
```

#### 2. Pull creates unnecessary merge commits
```bash
# Problem: pull.ff not configured
git config --local pull.ff only

# Alternative: always rebase on pull
git config --local pull.rebase true
```

#### 3. Aliases not working
```bash
# Re-apply GitFlow aliases
curl -sSL https://raw.githubusercontent.com/MAUGUS2/.github/main/scripts/setup-gitflow-config.sh | bash

# Verify aliases exist
git config --local --get-regexp alias
```

#### 4. Branch protection not working
```bash
# Check GitHub CLI authentication
gh auth status

# Re-apply protection
gh api repos/OWNER/REPO/branches/main/protection --method PUT \
  -f required_status_checks='{"strict":true,"contexts":["CI"]}' \
  -f enforce_admins=false \
  -f required_pull_request_reviews='{"required_approving_review_count":1}'
```

## 🎓 Advanced GitFlow Techniques

### Interactive Rebase for Clean History
```bash
# Clean up commits before merging (use carefully)
git rebase -i develop

# Squash fixup commits, reword messages
# Only do this on feature branches before merging
```

### Cherry-pick for Hotfixes
```bash
# For urgent fixes that need to go to main immediately
git checkout main
git cherry-pick <commit-hash>
git checkout develop  
git cherry-pick <commit-hash>  # Apply to develop too
```

### Release Branches
```bash
# For coordinated releases
git checkout develop
git checkout -b release/v1.2.0
# Final testing, version bumps, changelog
git checkout main
git merge --no-ff release/v1.2.0
git tag v1.2.0
git checkout develop
git merge --no-ff release/v1.2.0
```

## 📊 Metrics and Monitoring

### Track GitFlow Health
```bash
# Count merge commits vs direct commits
git log --oneline --merges | wc -l     # Should be high
git log --oneline --no-merges | wc -l  # Feature commits

# Average PR size (lines changed)
git log --stat --since="1 month ago" | grep "files changed"

# Time between feature start and merge
git log --pretty=format:"%h %s %cr" --grep="merge.*:" -10
```

## 🤝 Team Guidelines

### For New Team Members
1. **Run setup script** when joining any MAUGUS project
2. **Use GitFlow aliases** for consistent workflow
3. **Never skip quality gates** - they're there for a reason
4. **Always use PR workflow** - no direct commits to main/develop
5. **Ask questions** about GitFlow before breaking it

### For Project Leads
1. **Enable branch protection** on all repositories
2. **Require PR reviews** before merge (minimum 1 reviewer)
3. **Set up automated quality gates** in CI/CD
4. **Monitor git graph quality** during code reviews
5. **Educate team** on GitFlow benefits and anti-patterns

### For Code Reviewers
1. **Check git graph** - ensure clean merge structure
2. **Verify quality gates** passed before approval
3. **Review commit messages** for conventional format
4. **Ensure single responsibility** - one feature per PR
5. **Test merge preview** before approving

## 📚 Additional Resources

- [Conventional Commits Specification](https://www.conventionalcommits.org/)
- [Git Flow Branching Model](https://nvie.com/posts/a-successful-git-branching-model/)
- [MAUGUS GitHub Standards](https://github.com/MAUGUS2/.github)
- [GitHub Flow Documentation](https://guides.github.com/introduction/flow/)
- [Semantic Versioning](https://semver.org/)

## 🔄 Version History

| Version | Date | Changes |
|---------|------|----------|
| 1.0.0 | 2025-07-01 | Initial MAUGUS GitFlow standards |

---

<p align="center">
  <strong>Made with ❤️ by MAUGUS Team</strong><br>
  <a href="https://github.com/MAUGUS2/.github">Organization Standards</a> •
  <a href="https://github.com/MAUGUS2/.github/issues">Report Issues</a> •
  <a href="mailto:contact@maugus.dev">Contact</a>
</p>