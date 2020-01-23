#!/bin/bash
title="Break over"
message="Get back to work"

notify-send 'Break time' 'You have five minutes.'
at now + 5 minute <<<"notify-send '$title' '$message'"
