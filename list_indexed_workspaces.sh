#!/bin/bash

function join_by { local d=$1; shift; echo -n "$1"; shift; printf "%s" "${@/#/$d}"; }
#split tag

focused_workspace=$(swaymsg -t get_workspaces | jq '.[] | select(.focused == true) | .name')
focused_workspace="${focused_workspace%\"}";
focused_workspace="${focused_workspace#\"}";
index_check=($(echo -e "${focused_workspace//'.'/'\n'}"))

all_workspaces=($(swaymsg -t get_workspaces | jq '.[] | .name'))

#You could break if no more indexes are found
workspace_list=();
for ((i=0; i<${#all_workspaces[@]}; i++)); do
	unsplit_chain=${all_workspaces[$i]}
	unsplit_chain="${unsplit_chain%\"}"
	unsplit_chain="${unsplit_chain#\"}"
	workspace_split_by_period=($(echo -e "${unsplit_chain//'.'/'\n'}"))
	is_indexed=${#workspace_split_by_period[@]}
	if [[ is_indexed -gt 1 ]]; then
		workspace_list+=("${all_workspaces[$i]}")
	fi
done
final_list=();
for question_element in ${workspace_list[@]};do
	is_root_most=true
	q1="${question_element%\"}"
	q1="${q1#\"}"
	for  element in ${workspace_list[@]};do
		e1="${element%\"}"
		e1="${e1#\"}"
		if [[ $q1 =~ $e1 ]]; then
			q1_chains=($(echo -e "${q1//'->'/'\n'}"))
			e1_chains=($(echo -e "${e1//'->'/'\n'}"))
			q1_count=${#q1_chains[@]}
			e1_count=${#e1_chains[@]}

			if [[ $q1_count -gt $e1_count ]]; then
				is_root_most=false
			fi


		fi
	done

	if [[ "$is_root_most" = true ]]; then
		final_list+=($q1)
	fi
done


query_text=$(join_by '\n' "${final_list[@]}")

echo -e "$query_text";

