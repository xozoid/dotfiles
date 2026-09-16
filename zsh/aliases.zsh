alias cls='clear' # Good 'ol Clear Screen command
alias -g B='; printf "\a"' # Ring terminal bell, e.g.: long-cmd B
alias -g J='| jq' # pretty json
grel() { git commit -a -m "$2" -n && git tag -a "$1" -m "$2"; }
