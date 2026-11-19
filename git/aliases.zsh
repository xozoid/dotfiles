alias gG='git grep'
alias glG='git log --grep'
alias gdh='git diff HEAD'
alias gdhs='git diff HEAD --stat'
alias gdm='git diff $(git_main_branch)'
alias gdms='git diff $(git_main_branch) --stat'
alias gsha='git rev-parse HEAD'
alias gundo='git reset --soft HEAD^'

gppr() {
    local branch
    branch=$(git branch --show-current) || return

    [[ -n "$branch" && "$branch" != "main" ]] || return 1

    # Verify the current branch has a merged PR
    [[ "$(gh pr view "$branch" --json state --jq '.state')" == "MERGED" ]] || {
        echo "Branch '$branch' has no merged PR"
        return 1
    }

    git fetch --all --prune &&
    git switch main &&
    git pull --ff-only &&
    git branch -D "$branch"
}
