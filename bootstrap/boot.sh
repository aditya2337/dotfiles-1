#!/usr/bin/env bash

bold=$(tput bold)
normal=$(tput sgr0)

boot_log_dir="$HOME/.boot_log"
boot_scripts_dir="$(dirname $0)/boot.d"

if [ ! -d "$boot_log_dir" ]; then
	mkdir "$boot_log_dir"
fi

readarray -t boots_already_done <<< "$(find $boot_log_dir -type f -exec basename {} \;|perl -pe 's/(.*)\.\d{8}-\d{4}/\1/')"

function containsElement() {
  local e match="$1"
  shift

  for e; do [[ "$e" == "$match" ]] && return 0; done
  return 1
}

for boot_script in $(find ${boot_scripts_dir} -name "*.sh"|sort -n); do
	if containsElement "$(basename ${boot_script})" "${boots_already_done[@]}"; then
		echo " ⏩  skip ${bold}${boot_script}${normal}, already executed"
	else
		echo " ✨  running ${bold}${boot_script}${normal}"
		bash $boot_script
		touch $boot_log_dir/$(basename $boot_script).$(date +%Y%m%d-%H%M)
	fi
done