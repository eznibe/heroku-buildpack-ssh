#!/usr/bin/env bash

NGROK_API_TOKEN="987-bagdb-123"

REPLACE_STR="s/NGROK_API_TOKEN/${NGROK_API_TOKEN}/g"
sed -i ${REPLACE_STR} config/ngrok-config

echo "Finished."
