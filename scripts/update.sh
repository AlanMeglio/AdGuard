#!/bin/bash
sudo systemctl stop AdGuardHome
sudo /opt/AdGuardHome/AdGuardHome --update
sudo systemctl start AdGuardHome
