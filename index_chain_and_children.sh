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


focused_workspace=$(swaymsg -t get_workspaces | jq '.[] | select(.focused == true) | .name')
focused_workspace="${focused_workspace%\"}";
focused_workspace="${focused_workspace#\"}";

focused_workspace_split_by_period=($(echo -e "${focused_workspace//'.'/'\n'}"))

split_count=${#focused_workspace_split_by_period[@]}

inverted_index_workspaces=($(~/.local/bin/list_all_indexed_workspaces.sh | sort -r))
all_workspaces=($(~/.local/bin/list_all_workspaces.sh))

if [[ $split_count -eq 1 ]]; then
	if [[ ${#inverted_index_workspaces} -gt 0 ]]; then
		message="Workspaces will be shifted downward."
		prompt="Choose workspace placement"
		selection=$(~/.local/bin/list_indexed_workspaces.sh | \
			rofi -dmenu -p "$prompt" -mesg "$message");

		selection="${selection%\"}";
		selection="${selection#\"}";
		selection_split_by_period=($(echo -e "${selection//'.'/'\n'}"))
		selection_index=${selection_split_by_period[0]}

		if [[ $selection ]]; then
			for workspace in ${inverted_index_workspaces[@]}
			do
				workspace_unsplit=$workspace
				workspace_unsplit="${workspace_unsplit%\"}"
				workspace_unsplit="${workspace_unsplit#\"}"
				workspace_split_by_period=($(echo -e \
				"${workspace_unsplit//'.'/'\n'}"))
				workspace_index=${workspace_split_by_period[0]}
				if [[ $workspace_index -ge $selection_index ]]; then
					incremented_index=$(( $workspace_index+1 ))
					old_name="$workspace_unsplit"
					new_name="$incremented_index.${workspace_split_by_period[1]}"
					swaymsg "rename workspace $old_name to $new_name";
				fi
			done
			for  workspace in ${all_workspaces[@]}; do

				if [[ $workspace =~ $focused_workspace ]];then
					new_name="$selection_index.$workspace"
					swaymsg "rename workspace $workspace to $new_name"
				fi
			done
			new_name="$selection_index.$focused_workspace"
			swaymsg "rename workspace $focused_workspace to $new_name"
		fi
	else
		for workspace in ${all_workspaces[@]}; do
			if [[ $workspace =~ $focused_workspace ]];then
				new_name="0.$workspace"
				swaymsg "rename workspace $workspace to $new_name"
			fi
		done
		swaymsg "rename workspace $focused_workspace to 0.$focused_workspace"
	fi
fi

