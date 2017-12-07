#!/bin/bash
# This script will start the runfolder container using the configuration below.

runfolder_base="/opt/monitored-folder"
status_base="/opt/arteria/runfolder-status"
port=8888
tag="prod"
timestamp="$(date +"%Y%m%d%H%M")"

tmpfile=$(mktemp /tmp/app.config.XXXXX)

cat > $tmpfile <<- EOF
---
# the directories configured need to reflext the ACTUAL location of the runfolders,
# i.e. if the host path is mounted onto a different container path, then the service
# will not report the correct path and further actions (like rsync) will fail.
monitored_directories:
    - $runfolder_base

can_create_runfolder: False

completed_marker_file: SequenceComplete.txt

state_base_path: /opt/state-folder
EOF

# run the container with the custom configuration
docker run -d --name=runfolder-service-$tag-$timestamp --rm -p $port:80 \
        -v $runfolder_base:$runfolder_base:ro \
        -v $status_base:/opt/state-folder \
        -v $tmpfile:/opt/runfolder-service/config/app.config \
        umccr/arteria-runfolder-docker:latest

rm $tmpfile
# Test the service with:
# curl localhost:8889/api/1.0/runfolders?state=* | python -m json.tool
