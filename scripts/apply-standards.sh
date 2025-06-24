#!/bin/bash
# 🎯 Apply MAUGUS GitHub Standards to any repository
# Usage: ./apply-standards.sh [repo-name]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get the org .github repo path
ORG_GITHUB_PATH="$HOME/.github"

# Function to print colored output
print_step() {
    echo -e "${BLUE}▶ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    print_error "Not in a git repository!"
    exit 1
fi

# Get repository info
REPO_NAME=$(basename `git rev-parse --show-toplevel`)
REPO_OWNER=$(git remote get-url origin | sed -E 's/.*[:/]([^/]+)\/[^/]+\.git/\1/')
CURRENT_BRANCH=$(git branch --show-current)

echo "🚀 Applying MAUGUS Standards to $REPO_OWNER/$REPO_NAME"
echo "================================================"

# 1. Copy templates
print_step "Copying issue and PR templates..."
mkdir -p .github/ISSUE_TEMPLATE .github/workflows
cp -r "$ORG_GITHUB_PATH/.github/ISSUE_TEMPLATE/"* .github/ISSUE_TEMPLATE/
cp "$ORG_GITHUB_PATH/.github/PULL_REQUEST_TEMPLATE.md" .github/
print_success "Templates copied"

# 2. Copy workflows
print_step "Copying GitHub Actions workflows..."
cp "$ORG_GITHUB_PATH/.github/workflows/"*.yml .github/workflows/
print_success "Workflows copied"

# 3. Copy other files
print_step "Copying CONTRIBUTING.md and CODEOWNERS..."
cp "$ORG_GITHUB_PATH/CONTRIBUTING.md" .
cp "$ORG_GITHUB_PATH/CODEOWNERS" .github/
print_success "Documentation files copied"

# 4. Sync labels
print_step "Syncing labels..."
if command -v gh &> /dev/null; then
    # Delete existing labels (optional - comment out if you want to keep existing)
    # gh label list --json name -q '.[].name' | xargs -I {} gh label delete {} --yes 2>/dev/null || true
    
    # Create new labels from our standard set
    cat "$ORG_GITHUB_PATH/labels/labels.json" | jq -r '.[] | "\(.name) \(.color) \(.description)"' | while IFS=' ' read -r name color description; do
        gh label create "$name" --color "$color" --description "$description" --force 2>/dev/null || \
        gh label edit "$name" --color "$color" --description "$description" 2>/dev/null || \
        print_warning "Could not create/update label: $name"
    done
    print_success "Labels synced"
else
    print_warning "GitHub CLI not installed - skipping label sync"
    echo "  Install with: brew install gh"
fi

# 5. Set up branch protection
print_step "Setting up branch protection..."
if command -v gh &> /dev/null; then
    # Main branch protection
    gh api repos/$REPO_OWNER/$REPO_NAME/branches/main/protection \
        --method PUT \
        -f required_status_checks='{"strict":true,"contexts":["CI / node-ci","CI / python-ci","CI / go-ci"]}' \
        -f enforce_admins=false \
        -f required_pull_request_reviews='{"required_approving_review_count":1,"dismiss_stale_reviews":true}' \
        -f restrictions=null \
        -f allow_force_pushes=false \
        -f allow_deletions=false \
        2>/dev/null && print_success "Main branch protected" || print_warning "Could not protect main branch"
    
    # Develop branch protection (if exists)
    if git show-ref --verify --quiet refs/heads/develop; then
        gh api repos/$REPO_OWNER/$REPO_NAME/branches/develop/protection \
            --method PUT \
            -f required_status_checks='{"strict":true,"contexts":["CI / node-ci","CI / python-ci","CI / go-ci"]}' \
            -f enforce_admins=false \
            -f required_pull_request_reviews='{"required_approving_review_count":1}' \
            -f restrictions=null \
            -f allow_force_pushes=false \
            -f allow_deletions=false \
            2>/dev/null && print_success "Develop branch protected" || print_warning "Could not protect develop branch"
    fi
else
    print_warning "GitHub CLI not installed - skipping branch protection"
fi

# 6. Create necessary files if they don't exist
print_step "Creating additional files..."

# Create .gitignore if it doesn't exist
if [ ! -f .gitignore ]; then
    cat > .gitignore << 'EOF'
# Dependencies
node_modules/
.venv/
vendor/

# Build outputs
dist/
build/
*.pyc
__pycache__/

# Environment
.env
.env.local
.env.*.local

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Testing
coverage/
.coverage
*.cover
.pytest_cache/

# Misc
*.bak
*.tmp
EOF
    print_success "Created .gitignore"
fi

# 7. Stage changes
print_step "Staging changes..."
git add .github/ CONTRIBUTING.md CODEOWNERS .gitignore 2>/dev/null || true

# 8. Summary
echo ""
echo "📋 Summary"
echo "=========="
print_success "Templates installed"
print_success "Workflows configured"
print_success "Documentation added"

if command -v gh &> /dev/null; then
    print_success "Labels synced"
    print_success "Branch protection configured"
else
    print_warning "Install GitHub CLI for full functionality:"
    echo "         brew install gh (macOS)"
    echo "         sudo apt install gh (Ubuntu/Debian)"
fi

echo ""
echo "📝 Next steps:"
echo "1. Review and commit changes:"
echo "   git commit -m 'chore: apply MAUGUS GitHub standards'"
echo ""
echo "2. Push to GitHub:"
echo "   git push origin $CURRENT_BRANCH"
echo ""
echo "3. If this is a new repo, consider:"
echo "   - Adding a README.md"
echo "   - Setting up secrets for CI/CD"
echo "   - Configuring project settings"
echo ""
echo "🎉 Done! Your repository now follows MAUGUS standards."