_abbs() {
  local cur prev opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  opts="newBlog newDir newEntry list delete edit compile help"

  if [[ ${cur} == * ]] ; then
    COMPREPLY=( $(compgen -W "${opts}" ${cur}) )
    return 0
  fi
}

complete -F _abbs abbs
