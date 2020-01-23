#!/bin/bash

function join_by { local d=$1; shift; echo -n "$1"; shift; printf "%s" "${@/#/$d}"; }
#split tag

focused_workspace=$(swaymsg -t get_workspaces | jq '.[] | select(.focused == true) | .name')
focused_workspace="${focused_workspace%\"}";
focused_workspace="${focused_workspace#\"}";
index_check=($(echo -e "${focused_workspace//'.'/'\n'}"))

all_workspaces=($(swaymsg -t get_workspaces | jq '.[] | .name'))

#You could break if no more indexes are found
root_most_indexed_workspaces=();
for ((i=0; i<${#all_workspaces[@]}; i++)); do
	unsplit_chain=${all_workspaces[$i]}
	unsplit_chain="${unsplit_chain%\"}"
	unsplit_chain="${unsplit_chain#\"}"
	workspace_split_by_period=($(echo -e "${unsplit_chain//'.'/'\n'}"))
	is_indexed=${#workspace_split_by_period[@]}
	if [[ is_indexed -gt 1 ]]; then
		indexed_workspaces+=(${all_workspaces[$i]})
	else
		break
	fi
done

query_text=$(join_by '\n' "${indexed_workspaces[@]}")

echo -e "$query_text";

