#!/bin/bash

killall rofi
function join_by { local d=$1; shift; echo -n "$1"; shift; printf "%s" "${@/#/$d}"; }
#split tag

focused_workspace=$(swaymsg -t get_workspaces | jq '.[] | select(.focused == true) | .name')
focused_workspace="${focused_workspace%\"}";
focused_workspace="${focused_workspace#\"}";

all_workspaces=($(swaymsg -t get_workspaces | jq '.[] | .name'))

# split up focused_workspace
linked_workspaces=($(echo -e ${focused_workspace//->/'\n'}))

# split up focused workspace tags
tags_combined=${linked_workspaces[0]}
tags_combined="${tags_combined%\"}";
tags_combined="${tags_combined#\"}";
IFS=":"
tags=($tags_combined)
unset IFS

tagged=();
for ((i=0; i<${#all_workspaces[@]}; i++)); do
	unsplit_chain=${all_workspaces[$i]}
	unsplit_chain="${unsplit_chain%\"}"
	unsplit_chain="${unsplit_chain#\"}"
	chain_elements=($(echo -e ${unsplit_chain//->/$'\n'}))
	workspace_tags=($(echo -e ${chain_elements[0]//:/$'\n'}))
	has_all_tags=1;
	for focus_tag in "${tags[@]}"; do
		count=${#chain_elements[@]}
		if ! [[ " ${workspace_tags[*]} " =~ $focus_tag ]]; then
			has_all_tags=0;
		fi
	done
	if (( has_all_tags )); then 
		tagged+=("$(join_by '->' "${chain_elements[@]:1:$count}")")
	fi
	has_all_tags=1;
done

query_text=""

node_count=${#linked_workspaces[@]}
current_workspace="$(join_by '->' "${linked_workspaces[@]:1:$node_count}")"
tagged_workspaces=()
for workspace in "${tagged[@]}"; do
	if [[ $current_workspace != "$workspace" ]]; then
		tagged_workspaces+=("$workspace");
	fi
done

query_text="$(join_by "\n" "${tagged_workspaces[@]}")"

echo -e "$query_text"
message=$current_workspace" (Current chain)"
selection="$(echo -e "$query_text" | rofi -p "Go to workspace chain" -mesg "$message" -dmenu)"

if [[ $selection ]]; then
	swaymsg workspace "$tags_combined->$selection"
fi
