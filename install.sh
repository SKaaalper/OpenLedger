#!/bin/bash

PURPLE='\033[0;35m'
NC='\033[0m' # скидання кольору

purple_echo() {
  echo -e "${PURPLE}$*${NC}"
}

# ==========================================
# Відображення логотипу
# ==========================================
purple_echo "Відображення логотипу..."

curl -s https://raw.githubusercontent.com/abzalliance/logo/main/logo.sh -o logo.sh

if [ -f logo.sh ]; then
    chmod +x logo.sh
    # Запускаємо logo.sh
    bash logo.sh
    # Пауза в 5 секунд
    sleep 5
    rm logo.sh
else
    purple_echo "Не вдалося завантажити логотип."
fi

# ==========================================
# Оновлення списку пакетів
# ==========================================
purple_echo "Оновлення списку пакетів..."
sudo apt update

# ==========================================
# Встановлення XFCE4 та додаткових пакетів
# ==========================================
purple_echo "Встановлення XFCE4 та додаткових пакетів..."
sudo apt install -y xfce4 xfce4-goodies

# ==========================================
# Встановлення TigerVNC сервера
# ==========================================
purple_echo "Встановлення TigerVNC сервера..."
sudo apt install -y tigervnc-standalone-server tigervnc-common

# ==========================================
# Запуск VNC серверу для первинного налаштування
# ==========================================
purple_echo "Запуск VNC серверу для первинного налаштування..."
vncserver

purple_echo "Будь ласка, введіть пароль для VNC (створіть складний пароль зі спецсимволами)."
purple_echo "При питанні про пароль тільки для перегляду, відповідайте 'n'."

# ==========================================
# Зупинка VNC серверу для налаштування автозапуску XFCE
# ==========================================
purple_echo "Зупинка VNC серверу для налаштування автозапуску XFCE..."
vncserver -kill :1

# ==========================================
# Налаштування файлу xstartup
# ==========================================
purple_echo "Налаштування файлу xstartup..."
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

purple_echo "Надаємо права на виконання файлу xstartup..."
chmod +x ~/.vnc/xstartup

# ==========================================
# Перевірка встановлення Docker
# ==========================================
purple_echo "Перевірка встановлення Docker..."
if ! command -v docker &> /dev/null; then
    purple_echo "Встановлення Docker..."
    sudo apt remove -y docker docker-engine docker.io containerd runc
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=\$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io
    sudo docker --version
else
    purple_echo "Docker вже встановлено, пропускаємо цей крок."
fi

# ==========================================
# Встановлення необхідних залежностей
# ==========================================
purple_echo "Встановлення необхідних залежностей..."
sudo apt install -y libgtk-3-0 libnotify4 libnss3 libxss1 libxtst6 xdg-utils libatspi2.0-0 libsecret-1-0

# ==========================================
# Завантаження та встановлення OpenLedger node
# ==========================================
purple_echo "Завантаження та встановлення OpenLedger node..."
wget https://cdn.openledger.xyz/openledger-node-1.0.0-linux.zip
sudo apt install -y unzip tmux
unzip openledger-node-1.0.0-linux.zip
sudo dpkg -i openledger-node-1.0.0.deb
sudo apt-get install -f -y
sudo apt-get install -y desktop-file-utils
sudo dpkg --configure -a

sudo apt-get install -y libgbm1 libasound2
sudo apt install -y libgtk2.0-0t64 libgtk-3-0t64 libgbm-dev libnotify-dev libnss3 libxss1 libasound2t64 libxtst6 xauth xvfb

# ==========================================
# Запуск VNC серверу (1920x1080, 24-bit)
# ==========================================
purple_echo "Запуск VNC серверу з роздільною здатністю 1920x1080 та глибиною кольору 24..."
vncserver :1 -geometry 1920x1080 -depth 24

purple_echo "Встановлення завершено. Деякі кроки потребують ручного виконання. Дивіться інструкцію нижче."
