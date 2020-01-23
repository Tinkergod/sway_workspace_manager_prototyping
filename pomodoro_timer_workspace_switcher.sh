#!/bin/bash

focused_workspace=$(swaymsg -t get_workspaces | jq '.[] | select(.focused == true) | .name')
focused_workspace="${focused_workspace%\"}";
focused_workspace="${focused_workspace#\"}";

echo $focused_workspace > ~/Documents/workspace_manager_files/previous_workspace.txt

notify-send 'Pomodoro set' 'Work for twenty five minutes.'
at now + 25 minute <<<"swaymsg workspace planner && ~/.local/bin/notify_pomodoro_finished.sh"



