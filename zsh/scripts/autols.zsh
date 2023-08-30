autols-run () {
  lsd --color=auto -a
  echo ""
}

autols-git () {
  if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == true ]]; then
    git status
  fi
}

autols () {
  autols-run
}

chpwd_functions+=(autols)
