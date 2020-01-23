#!/bin/bash

focused_workspace="$(swaymsg -t get_workspaces | jq '.[] | select(.focused == true) | .name')"
focused_workspace="${focused_workspace%\"}";
focused_workspace="${focused_workspace#\"}";

split_focused=($(echo -e "${focused_workspace//'.'/'\n'}"))


root_most_indexed_chains=($(~/.local/bin/list_indexed_workspaces.sh))
if [[ ${#split_focused[@]} > 1 ]]; then
	if [[ $root_most_indexed_chains ]]; then
		for workspace in ${root_most_indexed_chains[@]}; do
			split_workspace=($(echo -e "${workspace//'.'/'\n'}"))
			index_below=$(( ${split_focused[0]} - 1 ))
			if [[ ${split_workspace[0]} -eq $index_below ]];then
				swaymsg workspace $workspace
				break
			fi
		done
		swaymsg workspace "$choice";
	fi
else
	if [[ $root_most_indexed_chains ]]; then
		swaymsg workspace ${root_most_indexed_chains[0]}
	fi
fi
