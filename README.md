# Openledger 
![image](https://github.com/user-attachments/assets/3f3dfdeb-de39-448b-a255-d1006447a2da)

# Open VPS Ubuntu Termianel & Past Command (For VPS Download [MobaXterm](https://mobaxterm.mobatek.net/))

```
source <(wget -qO- https://raw.githubusercontent.com/abzalliance/OpenLedger/main/install.sh)
```

## Additional Manual Steps

Although most processes are automated, some steps require your intervention. Below is a detailed instruction for performing these actions.

### a. Setting VNC Password

After starting the VNC server, follow these steps:

1. **Enter VNC Password:** Create a strong password using special characters.
2. **Answer the View-Only Password Prompt:** Enter `n`.

### b. Connecting to VNC

1. **Use a VNC Client** on your computer.
2. **Enter Your Server's IP Address with Port `5901`:** For example, `192.168.1.100:5901`.
3. **Enter the VNC Password** you set earlier.

### c. Configuring VNC When Facing Issues with Port `5901`

If you encounter problems connecting to port `5901`, perform the following steps:

1. **Stop the VNC Server:**
    ```bash
    vncserver -kill :1
    ```
2. **Start the VNC Server Without Localization:**
    ```bash
    vncserver :1 -localhost no -geometry 1920x1080 -depth 24
    ```
3. **Attempt to Connect to VNC Again.**

### d. Running the OpenLedger Node

1. **Connect to VNC and Open the Terminal:**
    - Navigate to **Applications → Terminal**.
2. **Start `tmux`:**
    ```bash
    tmux
    ```
3. **Within `tmux`, Launch the Node:**
    ```bash
    openledger-node --no-sandbox
    ```
4. **Authorization:**
    - **Log in** using your email.
    - Click the **Install** button, then **Connect**.
    - If the **Connect** button does not work (remains yellow), you may need to change the ports.

### e. Ending the Session

1. **Exit the `tmux` Session:** Press `Ctrl + B`, then `D`.
2. **Close the VNC Window.**

## Usage

After successful installation and configuration, your OpenLedger Node will be ready for operation. You can connect to it via VNC and manage the node using the terminal.
