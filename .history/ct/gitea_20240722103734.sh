#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/tteck/Proxmox/main/misc/build.func)
# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster)
# Co-author: Rogue-King
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

function header_info {
clear
cat <<"EOF"
          _   __
   ______(_)_/ /___  ____ _
  / __  / // __/ _ \/ __  /
 / /_/ / // /_/  __/ /_/ /
 \__, /_/ \__/\___/\__,_/
/____/

   ______ _   __
  / ____/(_)_/ /___  ____ _
 / / __// // __/ _ \/ __  /
/ /_/ // // /_/  __/ /_/ /
\____//_/ \__/\___/\__,_/

EOF
}
header_info
echo -e "Loading..."
APP="gitea"
var_disk="8"
var_cpu="1"
var_ram="512"
var_os="debian"
var_version="12"
variables
color
catch_errors

function default_settings() {
  CT_TYPE="1"
  PW=""
  CT_ID=$NEXTID
  HN=$NSAPP
  DISK_SIZE="$var_disk"
  CORE_COUNT="$var_cpu"
  RAM_SIZE="$var_ram"
  BRG="vmbr0"
  NET="dhcp"
  GATE=""
  APT_CACHER=""
  APT_CACHER_IP=""
  DISABLEIP6="no"
  MTU=""
  SD=""
  NS=""
  MAC=""
  VLAN=""
  SSH="no"
  VERB="no"
  echo_default
}

function update_script() {
header_info
if [[  ! -f /lib/systemd/system/gitea.service ]]; then msg_error "No ${APP} Installation Found!"; exit; fi
RELEASE=$(wget -q https://github.com/go-gitea/gitea/releases/latest -O - | grep "title>Release" | cut -d " " -f 4)
VERSION=${RELEASE#v}
msg_info "Updating ${APP}"
wget -q https://github.com/go-gitea/gitea/releases/download/$RELEASE/gitea-$VERSION-linux-amd64
systemctl stop gitea
mv gitea* /usr/local/bin/gitea
systemctl start gitea
apt-get update &>/dev/null
apt-get -y upgrade &>/dev/nullexit
msg_ok "Updated ${APP} LXC"
exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${APP} should be reachable by going to the following URL.
         ${BL}http://${IP}:3000${CL} \n"