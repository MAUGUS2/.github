# Contributing Guide

Thank you for considering contributing to **MAUGUS** projects! 🎉  
All code, comments and communication must be in English.

## 🚀 Workflow at a glance

1. Pick (or open) an Issue labelled `status/ready`
2. Create a branch `<type>/<issue-id>-<description>` (e.g., `feat/123-add-dark-mode`)
3. Open a **draft PR** early; CI will run automatically
4. Keep the PR ≤ 800 LOC; mark minor comments as "nit"
5. After approval, merge; the PR auto-closes the Issue and the Project board updates

## 📋 Before You Start

### Prerequisites
- Git configured with your GitHub account
- Node.js 20+ / Python 3.11+ / Go 1.21+ (depending on project)
- pnpm / Poetry / Go modules (depending on project)
- Your favorite code editor

### Setup
```bash
# Clone the repository
git clone https://github.com/MAUGUS2/<project>.git
cd <project>

# Install dependencies
pnpm install      # for Node.js projects
poetry install    # for Python projects
go mod download   # for Go projects

# Run tests to ensure everything works
pnpm test
poetry run pytest
go test ./...
```

## 🔄 Development Workflow

### 1. Find or Create an Issue
- Check the [Issues](https://github.com/MAUGUS2/<project>/issues) page
- Look for issues labeled `status/ready` or `meta/good-first-issue`
- If creating a new issue, use our templates and wait for approval

### 2. Create a Feature Branch
```bash
# Sync with latest main
git checkout main
git pull origin main

# Create your branch
git checkout -b <type>/<issue-number>-<brief-description>

# Examples:
# feat/156-add-export-functionality
# fix/157-resolve-auth-timeout
# docs/158-update-api-examples
```

Branch types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

### 3. Make Your Changes
- Write clean, readable code
- Follow the project's style guide
- Add/update tests for your changes
- Keep commits small and focused

### 4. Commit Guidelines
We use [Conventional Commits](https://www.conventionalcommits.org/):

```bash
<type>(<scope>): <subject>

<body>

<footer>
```

Examples:
```bash
feat(auth): add JWT refresh token support

Implements automatic token refresh when the access token expires.
Tokens are stored securely in httpOnly cookies.

Fixes #123

---

fix(ui): correct button alignment on mobile

The submit button was overlapping with the footer on small screens.
Added proper margin and tested on multiple devices.

Fixes #124
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code changes that neither fix bugs nor add features
- `test`: Adding or updating tests
- `chore`: Maintenance tasks
- `ci`: CI/CD changes
- `perf`: Performance improvements

### 5. Open a Pull Request
```bash
# Push your branch
git push -u origin <your-branch>
```

Then:
1. Go to GitHub and click "Compare & pull request"
2. Use the PR template
3. Mark as **draft** initially
4. Link the related issue: "Fixes #123"
5. Ensure all checks pass

### 6. Code Review Process
- Respond to all feedback
- Mark resolved conversations
- Push fixes as new commits (don't force-push during review)
- Once approved, squash commits if needed

## 📏 Code Standards

### General Rules
- **English only**: All code, comments, commits, and documentation
- **Line limit**: Keep PRs under 800 lines of code
- **Test coverage**: Maintain or improve test coverage
- **No secrets**: Never commit passwords, tokens, or keys

### Language-Specific

#### JavaScript/TypeScript
- Use ESLint + Prettier configuration
- Prefer functional programming patterns
- Use TypeScript for new code
- Write JSDoc comments for public APIs

#### Python
- Follow PEP 8
- Use type hints
- Format with Black
- Lint with Ruff
- Document with docstrings

#### Go
- Run `gofmt` and `goimports`
- Follow [Effective Go](https://golang.org/doc/effective_go)
- Write table-driven tests
- Document exported functions

## 🏷️ Label Guide

### Type Labels
- `type/bug` - Something broken
- `type/feature` - New functionality
- `type/docs` - Documentation
- `type/test` - Testing
- `type/chore` - Maintenance

### Priority Labels
- `priority/critical` - Drop everything
- `priority/high` - This iteration
- `priority/medium` - Next iteration
- `priority/low` - Backlog

### Status Labels
- `status/ready` - Ready to work on
- `status/in-progress` - Being worked on
- `status/blocked` - Waiting on something
- `status/review` - In code review

## 🚫 What Not to Do

- Don't force-push to shared branches
- Don't commit directly to main/develop
- Don't merge without CI passing
- Don't ignore test failures
- Don't submit huge PRs (> 800 LOC)
- Don't commit generated files
- Don't use TODO comments without creating an issue

## 🎯 Tips for Success

1. **Start small**: Pick simple issues first
2. **Ask questions**: We're here to help
3. **Test locally**: Run all tests before pushing
4. **Document changes**: Update README/docs if needed
5. **Be patient**: Reviews take time
6. **Stay positive**: We're all learning

## 📞 Getting Help

- 💬 [GitHub Discussions](https://github.com/MAUGUS2/discussions) - General questions
- 🐛 [Issues](https://github.com/MAUGUS2/<project>/issues) - Bug reports
- 📧 [Email](mailto:contact@maugus.dev) - Private concerns

## 🙏 Recognition

Contributors are recognized in:
- The project README
- Release notes
- Our [Contributors page](https://github.com/MAUGUS2/<project>/graphs/contributors)

Thank you for making our projects better! 🚀