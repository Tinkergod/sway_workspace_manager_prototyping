#!/bin/bash
#Todos
#check for uniqueness
focused_workspace=$(
	swaymsg -t get_workspaces | jq '.[] | select(.focused == true) | .name')

jq_input=$focused_workspace
focused_workspace="${focused_workspace%\"}";
focused_workspace="${focused_workspace#\"}";
linked_workspaces=($(echo -e "${focused_workspace//->/'\n'}"))

workspace_count=${#linked_workspaces[@]}

child_workspace_names=$(swaymsg -t get_workspaces | 
	jq  ".[] | select(.name | startswith($jq_input))| .name")

workspaces=($child_workspace_names)


child_name_extensions=();
for element in "${workspaces[@]}";do

	chain_of_nodes=()
	chain_of_nodes=($(echo -e "${element//->/'\n'}"))

	if (( ${#chain_of_nodes[@]} == ((workspace_count+1)))); then
		extension="${chain_of_nodes[-1]}";
		extension="${extension%\"}"
		extension="${extension#\"}"
		child_name_extensions+=("$extension")
	fi
done

output=""
for ((i=0; i < ${#child_name_extensions[@]}; i++)); do
	if [[ ${child_name_extensions[$i]} ]]; then
		if (( i == ((${#child_name_extensions[@]}-1)) )); then
			output+=${child_name_extensions[$i]};
		else
			output+=${child_name_extensions[$i]}"\n"
		fi
	fi
done

if [[ $output ]]; then
	echo -e "$output"
fi
