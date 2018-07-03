unalias fork 2>/dev/null

function fork() {
  if (( ! $+commands[hub] )); then
	echo "hub is not installed."
	return 1
  fi
  _script_name="${(%):-%N}"

  function _usage() {
	echo "USAGE: $_script_name user/repo"
	echo ""
	echo " Fork and clone a project on Github"
  }

  project_ref="$1"
  [[ -z ${project_ref:-} ]] && _usage && return 0
  PROJECTS=${PROJECTS:-$HOME/code}
  FORKS=${FORKS:-$PROJECTS/forks}
  hub clone "${project_ref}" "${FORKS}/${project_ref}"
  pushd "${FORKS}/${project_ref}"
  if [[ ${PWD} != "${FORKS}/${project_ref}" ]]; then
	echo  "Something wrong during clone"
	echo "Aborting"
	return 1
  fi
  hub fork
}

