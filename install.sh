#!/bin/bash

# Відображення логотипу
echo "Відображення логотипу..."
curl -s https://raw.githubusercontent.com/abzalliance/logo/main/logo.sh -o logo.sh

if [ -f logo.sh ]; then
    bash logo.sh
    rm logo.sh
else
    echo "Не вдалося завантажити логотип."
fi

# Оновлення списку пакетів
echo "Оновлення списку пакетів..."
sudo apt update

# Встановлення XFCE4 та додаткових пакетів
echo "Встановлення XFCE4 та додаткових пакетів..."
sudo apt install -y xfce4 xfce4-goodies

# Встановлення TigerVNC серверу та загальних файлів
echo "Встановлення TigerVNC серверу..."
sudo apt install -y tigervnc-standalone-server tigervnc-common

# Запуск VNC серверу для первинного налаштування
echo "Запуск VNC серверу для первинного налаштування..."
vncserver

echo "Будь ласка, введіть пароль для VNC (створіть складний пароль з спецсимволами)."
echo "При питанні про пароль тільки для перегляду, відповідайте 'n'."

# Зупинка VNC серверу для налаштування автозапуску XFCE
echo "Зупинка VNC серверу для налаштування автозапуску XFCE..."
vncserver -kill :1

# Налаштування файлу xstartup
echo "Налаштування файлу xstartup..."
cat <<EOF >> ~/.vnc/xstartup
#!/bin/sh

xrdb "\$HOME/.Xresources"
xsetroot -solid grey
#x-terminal-emulator -geometry 80x24+10+10 -ls -title "\$VNCDESKTOP Desktop" &
#x-window-manager &
# Fix to make GNOME work
export XKL_XMODMAP_DISABLE=1
/etc/X11/Xsession
#!/bin/bash
xrdb \$HOME/.Xresources
startxfce4 &
EOF

# Надаємо права на виконання файлу xstartup
echo "Надаємо права на виконання файлу xstartup..."
chmod +x ~/.vnc/xstartup

# Перевірка встановлення Docker
echo "Перевірка встановлення Docker..."
if ! command -v docker &> /dev/null; then
    echo "Встановлення Docker..."
    sudo apt remove -y docker docker-engine docker.io containerd runc
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io
    sudo docker --version
else
    echo "Docker вже встановлено, пропускаємо цей крок."
fi

# Встановлення необхідних залежностей
echo "Встановлення необхідних залежностей..."
sudo apt install -y libgtk-3-0 libnotify4 libnss3 libxss1 libxtst6 xdg-utils libatspi2.0-0 libsecret-1-0

# Завантаження та встановлення OpenLedger node
echo "Завантаження та встановлення OpenLedger node..."
wget https://cdn.openledger.xyz/openledger-node-1.0.0-linux.zip
sudo apt install -y unzip tmux
unzip openledger-node-1.0.0-linux.zip
sudo dpkg -i openledger-node-1.0.0.deb
sudo apt-get install -f -y
sudo apt-get install -y desktop-file-utils
sudo dpkg --configure -a

sudo apt-get install -y libgbm1 libasound2
sudo apt install -y libgtk2.0-0t64 libgtk-3-0t64 libgbm-dev libnotify-dev libnss3 libxss1 libasound2t64 libxtst6 xauth xvfb

# Запуск VNC серверу з налаштуваннями
echo "Запуск VNC серверу з роздільною здатністю 1920x1080 та глибиною кольору 24..."
vncserver :1 -geometry 1920x1080 -depth 24

echo "Встановлення завершено. Деякі кроки потребують ручного виконання. Дивіться інструкцію нижче."
