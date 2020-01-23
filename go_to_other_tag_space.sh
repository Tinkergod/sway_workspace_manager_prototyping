#!/bin/bash
killall rofi
focused_workspace=$(swaymsg -t get_workspaces | jq '.[] | select(.focused == true) | .name')

focused_workspace="${focused_workspace%\"}";
focused_workspace="${focused_workspace#\"}";
linked_nodes=($(echo -e "${focused_workspace//->/'\n'}"))


possibly_indexed_tagspace=${linked_nodes[0]}

#remove index
index_and_tagspace_array=($(echo -e "${possibly_indexed_tagspace//'.'/'\n'}"))

if [[ ${#index_and_tagspace_array[@]} -gt 1 ]];then
	current_tagspace=${index_and_tagspace_array[1]};
else
	current_tagspace=${linked_nodes[0]}
fi

message=$current_tagspace" (Current tagspace)"
choice=$(~/.local/bin/list_tag_combos.sh | rofi -p "Go to tag space" -mesg "$message" -dmenu)

if [[ $choice ]]; then
	all_workspaces=($(swaymsg -t get_workspaces | jq '.[] | .name'))
	for ((i=0; i<${#all_workspaces[@]}; i++)); do
		unsplit_chain=${all_workspaces[$i]}
		unsplit_chain="${unsplit_chain%\"}"
		unsplit_chain="${unsplit_chain#\"}"
		chain=($(echo -e "${unsplit_chain//->/'\n'}"))
		index_tagspace= ${chain[0]}
		index_check=($(echo -e "${index_tagspace//'.'/'\n'}"))
		tagspace=""

		if [[ ${#index_check[@]} -gt 1 ]];then
			tagspace="${index_check[1]}";
		else
			tagspace="${linked_nodes[0]}"
		fi

		if [[ $tagspace =~ $choice ]]; then
			swaymsg workspace "${all_workspaces[$i]}";
			break
		fi
	done

fi
