#!/bin/bash

# Bash-скрипт, який автоматично:
# - встановлює Docker,
# - встановлює Docker Compose,
# - встановлює Python (версію 3.9 або новішу),
# - встановлює Django через pip.

PACKAGES="docker.io docker-compose python3 python3-pip python3-venv"
RED="\033[91m"
YELLOW="\033[33m"
GREEN="\033[32m"
RESET="\033[0m"

# Встановлюємо змінну середовища DEBIAN_FRONTEND у режим noninteractive,
# щоб під час автоматичної інсталяції пакетів apt-get не очікував взаємодії з користувачем
# і не показував діалогові вікна конфігурації.
export DEBIAN_FRONTEND=noninteractive

echo -e "${GREEN}Updating package list ----------------------------------------${RESET}"
apt-get update

echo -e "${GREEN}Installing packages -----------------------------------------${RESET}"
for pkg in $PACKAGES; do
    if ! dpkg -l | grep -q $pkg; then
        echo -e "${GREEN}Installing $pkg -------------------${RESET}"
        apt-get install -y $pkg
    else
        echo -e "${YELLOW}$pkg is already installed${RESET}"
    fi
done

# Створюємо та активуємо віртуальне середовище
echo -e "${GREEN}Setting up Python virtual environment ------------------------${RESET}"
if [ ! -d ".venv" ]; then
    python3 -m venv .venv
    echo -e "${GREEN}Virtual environment created successfully${RESET}"
else
    echo -e "${YELLOW}Virtual environment already exists${RESET}"
fi
source .venv/bin/activate

echo -e "${GREEN}Installing Django via pip -----------------------------------${RESET}"
# Встановлюємо Django через pip3, якщо не встановлено
if ! python3 -m pip show django > /dev/null 2>&1; then
    python3 -m pip install --upgrade pip
    python3 -m pip install django
    echo -e "${GREEN}Django installed successfully${RESET}"
else
    echo -e "${YELLOW}Django is already installed${RESET}"
fi