#!/bin/bash
#Todos
#check for uniqueness

focused_workspace=$(
	swaymsg -t get_workspaces | jq '.[] | select(.focused == true) | .name')

focused_workspace="${focused_workspace%\"}";

focused_workspace="${focused_workspace#\"}";

workspace_names=$(swaymsg -t get_workspaces | jq ".[] | .name");


workspaces=($workspace_names)

workspace_names=();
for element in "${workspaces[@]}";do
	name=$element
	name="${name%\"}";
	name="${name#\"}";
	workspace_names+=("$(echo -e "$name")");
done


output=""
for ((i=0; i < ${#workspace_names[@]}; i++)); do
	if [[ ${workspace_names[$i]} ]]; then
		if [[ ${workspace_names[$i]} != "$focused_workspace" ]]; then
			output+=${workspace_names[$i]}"\n"
		fi
	fi
done

if [[ $output ]]; then
	echo -e -n "$output"
fi
