#!/bin/bash
killall rofi
function join_by { 
	local d=$1; 
	shift; 
	echo -n "$1"; 
	shift; 
	printf "%s" "${@/#/$d}"; 
}

focused_workspace=$(
	swaymsg -t get_workspaces | jq '.[] | select(.focused == true) | .name')
focused_workspace="${focused_workspace%\"}";
focused_workspace="${focused_workspace#\"}";

linked_workspaces=($(echo -e "${focused_workspace//->/'\n'}"))

tags_combined=${linked_workspaces[0]}
tags_combined="${tags_combined%\"}";
tags_combined="${tags_combined#\"}";


new_tag="$(rofi -p "Add tag" -mesg "$tags_combined (Current tagspace)" -dmenu)"

IFS=":"
tags=($tags_combined)
unset IFS

tags+=("$new_tag");

sorted_tags=($(printf '%s\n' "${tags[@]}" | sort))

sorted_tags_name=$(join_by : "${sorted_tags[@]}")

new_name=""
new_name+=$sorted_tags_name;

count=${#linked_workspaces[@]};

linked_node_names+=$(join_by "->" "${linked_workspaces[@]:1:$count}")

linked_node_names="${linked_node_names%\"}";
linked_node_names="${linked_node_names#\"}";

if [[ $linked_node_names ]]; then
	new_name+="->"$linked_node_names
	swaymsg "rename workspace $focused_workspace to $new_name"
else
	swaymsg "rename workspace $focused_workspace to $new_name"
fi


