#!/bin/bash
# Initialize a new repo in the preferred worktree directory structure and create its GitHub remote
# Usage: init-repo.sh <repo-name> [--description <description>] [--public]

set -e

REPO_NAME=""
VISIBILITY="private"
DESCRIPTION=""

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --public)
            VISIBILITY="public"
            shift
            ;;
        --private)
            VISIBILITY="private"
            shift
            ;;
        --description)
            if [[ -z "$2" ]]; then
                echo "Error: --description requires a value"
                echo "Usage: init-repo.sh <repo-name> [--description <description>] [--public]"
                exit 1
            fi
            DESCRIPTION="$2"
            shift 2
            ;;
        -*)
            echo "Error: Unknown option '$1'"
            echo "Usage: init-repo.sh <repo-name> [--description <description>] [--public]"
            exit 1
            ;;
        *)
            if [[ -z "$REPO_NAME" ]]; then
                REPO_NAME="$1"
            else
                echo "Error: Unexpected argument '$1'"
                echo "Usage: init-repo.sh <repo-name> [--description <description>] [--public]"
                exit 1
            fi
            shift
            ;;
    esac
done

if [[ -z "$REPO_NAME" ]]; then
    echo "Error: Repo name is required"
    echo "Usage: init-repo.sh <repo-name> [--description <description>] [--public]"
    exit 1
fi

if [[ -z "$CODE_ROOT" ]]; then
    echo "Error: CODE_ROOT environment variable is not set"
    exit 1
fi

REPO_PATH="$CODE_ROOT/$REPO_NAME/trunk/$REPO_NAME"

if [[ -d "$REPO_PATH" ]]; then
    echo "Error: Directory already exists: $REPO_PATH"
    exit 1
fi

# Get GitHub username for repo creation
GH_USER=$(gh api user --jq '.login')
if [[ -z "$GH_USER" ]]; then
    echo "Error: Could not determine GitHub username. Ensure gh is authenticated."
    exit 1
fi

# Create directory structure
mkdir -p "$REPO_PATH"
# Create empty worktrees directory alongside trunk
mkdir -p "$CODE_ROOT/$REPO_NAME/worktrees"

# Initialize git repo with trunk as default branch
git init -b trunk "$REPO_PATH"

# Create initial .gitignore
echo "" > "$REPO_PATH/.gitignore"

# Initial commit
git -C "$REPO_PATH" add .gitignore
git -C "$REPO_PATH" commit -m "Initial commit"

# Create GitHub repo and add as remote
gh repo create "$GH_USER/$REPO_NAME" "--$VISIBILITY" --description "$DESCRIPTION"
git -C "$REPO_PATH" remote add origin "git@github.com:$GH_USER/$REPO_NAME.git"

# Push initial commit
git -C "$REPO_PATH" push -u origin trunk

echo ""
echo "Repo initialized successfully"
echo "Path: $REPO_PATH"
echo "GitHub: https://github.com/$GH_USER/$REPO_NAME"
