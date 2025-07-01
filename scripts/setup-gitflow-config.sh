#!/bin/bash
# 🌳 MAUGUS GitFlow Configuration Script
# Configures local git settings for quality-first GitFlow workflow

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

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

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    print_error "Not in a git repository!"
    echo "Please run this script from inside a git repository."
    exit 1
fi

echo "🌳 Configuring MAUGUS GitFlow Settings"
echo "====================================="

# 1. Configure merge behavior (NEVER fast-forward for feature merges)
print_step "Configuring merge behavior..."
git config --local merge.ff false
print_success "merge.ff = false (always create merge commits for features)"

# 2. Configure pull behavior (ONLY fast-forward for clean pulls)
print_step "Configuring pull behavior..."
git config --local pull.ff only
print_success "pull.ff = only (safe pulls without unnecessary merge commits)"

# 3. Configure branch behavior
print_step "Configuring branch auto-setup..."
git config --local branch.autosetupmerge always
git config --local branch.autosetuprebase always
print_success "Auto-setup for tracking and rebase configured"

# 4. Add helpful GitFlow aliases
print_step "Adding GitFlow aliases..."

# Visual git graph
git config --local alias.graph "log --graph --pretty=format:'%C(auto)%h%d %s %C(green)(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all"
print_info "Added: git graph (beautiful visual git history)"

# Quick navigation
git config --local alias.develop "checkout develop"
print_info "Added: git develop (quick switch to develop branch)"

git config --local alias.main "checkout main"  
print_info "Added: git main (quick switch to main branch)"

# Safe develop sync
git config --local alias.sync-develop "!git checkout develop && git pull origin develop"
print_info "Added: git sync-develop (safe develop synchronization)"

git config --local alias.sync-main "!git checkout main && git pull origin main"
print_info "Added: git sync-main (safe main synchronization)"

# Feature workflow
git config --local alias.feature-start "checkout -b"
print_info "Added: git feature-start <branch-name> (create feature branch)"

git config --local alias.feature-finish "merge --no-ff"
print_info "Added: git feature-finish <branch-name> (merge with visible commit)"

# Quality helpers
git config --local alias.last "log -1 HEAD --stat"
print_info "Added: git last (show last commit details)"

git config --local alias.unstage "reset HEAD --"
print_info "Added: git unstage <file> (unstage files)"

print_success "GitFlow aliases configured"

# 5. Verify current branch and suggest workflow
print_step "Analyzing current repository..."

CURRENT_BRANCH=$(git branch --show-current)
HAS_DEVELOP=$(git show-ref --verify --quiet refs/heads/develop && echo "yes" || echo "no")
HAS_MAIN=$(git show-ref --verify --quiet refs/heads/main && echo "yes" || echo "no")

echo ""
echo "📊 Repository Analysis:"
echo "======================"
echo "Current branch: $CURRENT_BRANCH"
echo "Has develop branch: $HAS_DEVELOP"
echo "Has main branch: $HAS_MAIN"

# 6. Setup recommendations
echo ""
echo "🎯 GitFlow Setup Recommendations:"
echo "================================="

if [ "$HAS_DEVELOP" = "no" ]; then
    print_warning "No 'develop' branch found!"
    echo "To create develop branch from main:"
    echo "  git checkout main"
    echo "  git checkout -b develop"
    echo "  git push -u origin develop"
    echo ""
fi

if [ "$CURRENT_BRANCH" = "main" ]; then
    print_info "You're on main branch. For development work:"
    echo "  git sync-develop  # Switch to develop and sync"
    echo "  git feature-start feature/123-new-feature"
    echo ""
elif [ "$CURRENT_BRANCH" = "develop" ]; then
    print_success "You're on develop branch - perfect for starting new features!"
    echo "  git feature-start feature/123-new-feature"
    echo ""
else
    print_info "You're on branch: $CURRENT_BRANCH"
    echo "To start a new feature:"
    echo "  git sync-develop  # Sync with latest develop"
    echo "  git feature-start feature/123-new-feature"
    echo ""
fi

# 7. Display configured settings for verification
echo "🔧 Configured Git Settings:"
echo "==========================="
echo "merge.ff = $(git config --local merge.ff)"
echo "pull.ff = $(git config --local pull.ff)"
echo "branch.autosetupmerge = $(git config --local branch.autosetupmerge)"
echo "branch.autosetuprebase = $(git config --local branch.autosetuprebase)"

echo ""
echo "🎯 Available GitFlow Commands:"
echo "=============================="
echo "git graph                    # Visual git history"
echo "git develop                  # Switch to develop"
echo "git main                     # Switch to main"
echo "git sync-develop             # Safe develop sync"
echo "git sync-main                # Safe main sync"
echo "git feature-start <name>     # Create feature branch"
echo "git feature-finish <name>    # Merge with --no-ff"
echo "git last                     # Show last commit"
echo "git unstage <file>           # Unstage files"

echo ""
print_success "MAUGUS GitFlow configuration complete!"
echo ""
echo "📚 For complete GitFlow standards, see:"
echo "   https://github.com/MAUGUS2/.github/blob/main/docs/maugus-gitflow-standards.md"
echo ""
echo "🔍 To verify your setup anytime, run:"
echo "   git config --local --list | grep -E '(merge|pull|alias)'"