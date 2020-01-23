#!/bin/bash
killall rofi
function join_by { 
	local d=$1; 
	shift; 
	echo -n "$1"; 
	shift; 
	printf "%s" "${@/#/$d}"; 
}
#split tag


all_workspaces=($(~/.local/bin/list_all_workspaces.sh))

indexed_workspaces=($(~/.local/bin/list_all_indexed_workspaces.sh))

if [[ ${#indexed_workspaces} -gt 0 ]]; then
	message="Workspaces will be shifted upward."
	prompt="Select workspace to deindex placement"
	selection=$(~/.local/bin/list_indexed_workspaces.sh | \
		rofi -dmenu -p "$prompt" -mesg "$message");

	selection="${selection%\"}";
	selection="${selection#\"}";
	selection_split_by_period=($(echo -e "${selection//'.'/'\n'}"))

	selection_index=${selection_split_by_period[0]}

	if [[ $selection ]]; then
		#rename selected workspace such that it doesn't have an index
		for  workspace in ${indexed_workspaces[@]}; do
			if [[ $workspace =~ $selection ]];then
				workspace_unsplit=$workspace
				workspace_unsplit="${workspace_unsplit%\"}"
				workspace_unsplit="${workspace_unsplit#\"}"
				workspace_split_by_period=($(echo -e \
				"${workspace_unsplit//'.'/'\n'}"))

				new_name="${workspace_split_by_period[1]}"
				swaymsg "rename workspace $workspace_unsplit to $new_name"
			fi
		done


		indexed_workspaces=($(~/.local/bin/list_all_indexed_workspaces.sh))
		for workspace in ${indexed_workspaces[@]}; do
			workspace_unsplit=$workspace
			workspace_unsplit="${workspace_unsplit%\"}"
			workspace_unsplit="${workspace_unsplit#\"}"
			workspace_split_by_period=($(echo -e \
			"${workspace_unsplit//'.'/'\n'}"))
			workspace_index=${workspace_split_by_period[0]}
			if [[ $workspace_index -gt $selection_index ]]; then
				deincremented_index=$(( $workspace_index-1 ))
				old_name="$workspace_unsplit"
				echo $workspace_unsplit
				new_name="$deincremented_index.${workspace_split_by_period[1]}"
				swaymsg "rename workspace $old_name to $new_name";
			fi
		done
	fi
fi

