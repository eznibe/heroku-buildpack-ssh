#!/usr/bin/env bash

if [ "$DYNO" != *run.* ] && [ "$SSH_ENABLED" = "true" ]; then
  ssh_port=${SSH_PORT:-"2222"}

  if [ -n "$NGROK_API_TOKEN" ]; then
    NGROK_OPTS="${NGROK_OPTS} --authtoken ${NGROK_API_TOKEN}"
  fi

  REPLACE_STR="s/NGROK_API_TOKEN/${NGROK_API_TOKEN}/g"
  sed -i ${REPLACE_STR} .heroku/bin/ngrok-config

  cat .heroku/bin/ngrok-config

  banner_file="/app/.ssh/banner.txt"
  cat << EOF > ${banner_file}
Connected to $DYNO
EOF

  echo "-----> Starting sshd for $(whoami)"
  /usr/sbin/sshd -f /app/.ssh/sshd_config -o "Port ${ssh_port}" -o "Banner ${banner_file}"

  # Start the tunnel
  #ngrok_cmd="ngrok tcp -log stdout ${NGROK_OPTS} ${ssh_port}"
  #ngrok_cmd="ngrok http -log stdout ${NGROK_OPTS} 4040"
  ngrok_cmd="ngrok start --config .heroku/bin/ngrok-config --all -log stdout"
  echo "Starting ngrok tunnel"
  echo "sshd: $ngrok_cmd"
  eval "$ngrok_cmd &"
fi
