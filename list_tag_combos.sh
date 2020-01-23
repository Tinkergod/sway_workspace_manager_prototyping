#!/bin/bash

function join_by { local d=$1; shift; echo -n "$1"; shift; printf "%s" "${@/#/$d}"; }
#split tag

focused_workspace=$(swaymsg -t get_workspaces | jq '.[] | select(.focused == true) | .name')
focused_workspace="${focused_workspace%\"}";
focused_workspace="${focused_workspace#\"}";
linked_workspaces=($(echo -e "${focused_workspace//->/'\n'}"))

focused_indexed_tags=${linked_workspaces[0]}
all_workspaces=($(swaymsg -t get_workspaces | jq '.[] | .name'))

tag_combos=();
for ((i=0; i<${#all_workspaces[@]}; i++)); do
	unsplit_chain=${all_workspaces[$i]}
	unsplit_chain="${unsplit_chain%\"}"
	unsplit_chain="${unsplit_chain#\"}"
	chain=($(echo -e "${unsplit_chain//->/'\n'}"))
	tag_combo_is_queriable=1;
	tag_in_question=${chain[0]}
	for tag in "${tag_combos[@]}"; do
		if [[ $tag == "$tag_in_question" ]]; then
			tag_combo_is_queriable=0;
		fi
		if [[ $focused_tags == "$tag_in_question" ]]; then
			tag_combo_is_queriable=0;
		fi

	done
	if (( tag_combo_is_queriable )); then 
		tag_combos+=("$tag_in_question")
	fi
	tag_combo_is_queriable=1;
done

query_text=$(join_by '\n' "${tag_combos[@]}")

echo -e "$query_text";

