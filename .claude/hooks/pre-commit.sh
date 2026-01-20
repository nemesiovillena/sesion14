#!/bin/bash

# Products&Inventory - Pre-commit Hook
# Este script se ejecuta antes de cada commit para verificar calidad

set -e

echo "🔍 Running pre-commit checks..."

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Track if any check fails
FAILED=0

# 1. Check for debug statements
echo -n "Checking for debug statements... "
if git diff --cached --name-only | xargs grep -l "dd(\|dump(\|var_dump(\|print_r(" 2>/dev/null; then
    echo -e "${RED}FAILED${NC}"
    echo "❌ Found debug statements. Please remove them before committing."
    FAILED=1
else
    echo -e "${GREEN}OK${NC}"
fi

# 2. Check for .env file
echo -n "Checking for .env file... "
if git diff --cached --name-only | grep -q "^\.env$"; then
    echo -e "${RED}FAILED${NC}"
    echo "❌ Attempting to commit .env file. This is not allowed."
    FAILED=1
else
    echo -e "${GREEN}OK${NC}"
fi

# 3. Check for secrets in code
echo -n "Checking for hardcoded secrets... "
PATTERNS="password\s*=\s*['\"][^'\"]+['\"]|api_key\s*=\s*['\"][^'\"]+['\"]|secret\s*=\s*['\"][^'\"]+['\"]"
if git diff --cached --name-only | xargs grep -lE "$PATTERNS" 2>/dev/null | grep -v ".env.example"; then
    echo -e "${YELLOW}WARNING${NC}"
    echo "⚠️  Possible hardcoded secrets detected. Please review."
else
    echo -e "${GREEN}OK${NC}"
fi

# 4. PHP Syntax Check
echo -n "Checking PHP syntax... "
SYNTAX_ERROR=0
for FILE in $(git diff --cached --name-only | grep "\.php$"); do
    if [ -f "$FILE" ]; then
        php -l "$FILE" > /dev/null 2>&1 || SYNTAX_ERROR=1
    fi
done
if [ $SYNTAX_ERROR -eq 1 ]; then
    echo -e "${RED}FAILED${NC}"
    echo "❌ PHP syntax errors found."
    FAILED=1
else
    echo -e "${GREEN}OK${NC}"
fi

# 5. Run PHP CS Fixer (if available)
echo -n "Checking code style... "
if [ -f "vendor/bin/pint" ]; then
    if ! vendor/bin/pint --test > /dev/null 2>&1; then
        echo -e "${YELLOW}WARNING${NC}"
        echo "⚠️  Code style issues found. Run 'make lint' to fix."
    else
        echo -e "${GREEN}OK${NC}"
    fi
else
    echo -e "${YELLOW}SKIPPED${NC} (pint not installed)"
fi

# 6. Run PHPStan (if available)
echo -n "Running static analysis... "
if [ -f "vendor/bin/phpstan" ]; then
    if ! vendor/bin/phpstan analyse --no-progress > /dev/null 2>&1; then
        echo -e "${RED}FAILED${NC}"
        echo "❌ PHPStan found errors. Run 'make analyze' for details."
        FAILED=1
    else
        echo -e "${GREEN}OK${NC}"
    fi
else
    echo -e "${YELLOW}SKIPPED${NC} (phpstan not installed)"
fi

# 7. Check file size (max 300 lines for PHP files)
echo -n "Checking file sizes... "
SIZE_WARNING=0
for FILE in $(git diff --cached --name-only | grep "\.php$"); do
    if [ -f "$FILE" ]; then
        LINES=$(wc -l < "$FILE")
        if [ "$LINES" -gt 300 ]; then
            echo -e "${YELLOW}WARNING${NC}"
            echo "⚠️  $FILE has $LINES lines (max recommended: 300)"
            SIZE_WARNING=1
        fi
    fi
done
if [ $SIZE_WARNING -eq 0 ]; then
    echo -e "${GREEN}OK${NC}"
fi

# 8. Check commit message format (if possible)
# This requires the commit-msg hook, but we can remind here
echo ""
echo "📝 Remember: Commit messages should follow format: type(scope): description"
echo "   Examples: feat(cart): add checkout functionality"
echo "             fix(auth): resolve login redirect issue"
echo ""

# Final result
if [ $FAILED -eq 1 ]; then
    echo -e "${RED}❌ Pre-commit checks failed. Please fix the issues above.${NC}"
    exit 1
else
    echo -e "${GREEN}✅ All pre-commit checks passed!${NC}"
    exit 0
fi
