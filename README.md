# 🛡️ Purple Team Lab - Automated Cyber Range

![Status](https://img.shields.io/badge/Status-Operational-success?style=for-the-badge&logo=github)
![Tech](https://img.shields.io/badge/Stack-Vagrant%20|%20Ansible%20|%20ELK%20|%20Docker-blue?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

##  Overview

**Purple Team Lab** is a fully automated cybersecurity range designed to simulate real-world attack and defense scenarios. Built with an **Infrastructure-as-Code (IaC)** approach, this project deploys a segmented network containing a Red Team infrastructure (Kali/GoPhish), a Blue Team monitoring stack (ELK SIEM), and a vulnerable target (DVWA).

The goal is to facilitate **Purple Teaming** exercises: executing attacks (Red) and developing detection rules (Blue) in a controlled, reproducible environment.

---

##  Architecture & Network Topology

The infrastructure is segmented into three distinct networks to mimic a corporate environment, enforced by **KVM/Libvirt** virtualization.

| Zone | Machine | IP | Role | Tech Stack |
| :--- | :--- | :--- | :--- | :--- |
| **Public** | `Kali-Attacker` | `10.10.10.5` | External Threat / C2 | Kali Linux, Metasploit |
| **DMZ** | `Srv-Phishing` | `10.10.10.10` | Phishing Campaign Server | Debian, GoPhish |
| **DMZ** | `Srv-SIEM` | `10.10.20.50` | Security Monitoring | Ubuntu, ELK Stack (7.x) |
| **Private** | `Wks-Victim` | `10.10.30.100` | Internal Target | Ubuntu, DVWA, Filebeat |

> **Note:** Strict routing rules prevent direct access from the Public zone to the Private zone, forcing attackers to pivot through the DMZ.

---

##  Deployment (Infrastructure as Code)

### Prerequisites
* Linux Host (Tested on Arch/CachyOS)
* Vagrant + Libvirt
* Ansible

### Quick Start
1. **Provisioning:** Initialize the virtual machines.
   ```bash
   vagrant up
   ```

   Configuration: Deploy the software stack automatically using Ansible.

```cd ansible
ansible-playbook install_docker.yml
ansible-playbook install_siem.yml
ansible-playbook install_victim.yml
ansible-playbook install_phishing.yml
```

📸 Proof of Concept

Phase 1: Infrastructure Automation

The entire lab is configured without manual SSH intervention. Below is the confirmation of successful connectivity and configuration management across the isolated fleet.

![ansible success](/documentation/screenshots/ansible-success.png)
Fig 1. Ansible ensuring connectivity and configuration compliance across all 4 VMs.

Phase 2: Red Team Operations (Phishing Infrastructure)
GoPhish is deployed in the DMZ to simulate spear-phishing campaigns.

1. Infrastructure Setup: Configuration of the Sending Profile (SMTP Simulation) and the deceptive Landing Page.

![SMTP Profile](/documentation/screenshots/gophish_Sending-page.png)
Fig 2. SMTP Sending Profile configuration.

![Login portal clone](/documentation/screenshots/gophish_landing-page.png)
Fig 3. Creation of a convincing corporate login portal clone.

2. Campaign Orchestration: The dashboard is ready to track emails sent, opened links, and submitted credentials.

![Admin panel](/documentation/screenshots/gophish-dashboard.png)
Fig 4. GoPhish Admin Panel initialized for the campaign.

Phase 3: Web Exploitation (Attack)
A Command Injection attack is executed against the vulnerable DVWA container on the victim machine. The attacker attempts to read /etc/passwd.

![Victim's raw docker logs](/documentation/screenshots/proof_of_attack_logs.png)
Fig 5. Evidence of the attack in the victim's raw Docker logs. Note the "cat /etc/passwd" payload.

Phase 4: Blue Team & Detection (Defense)
The ELK Stack (Elasticsearch, Logstash, Kibana) centralizes logs. Filebeat forwards Docker logs from the victim to the SIEM in real-time.

1. Log Ingestion: Visualization of raw telemetry flowing into the SIEM.

![Kibana Discover panel](/documentation/screenshots/kibana-discovery.png)
Fig 6. Kibana Discover panel receiving live telemetry from the Victim machine.

2. Threat Hunting & Detection: Using KQL (Kibana Query Language) to filter the noise and isolate the specific Command Injection attempt detected in Phase 3.

![HTTP request logs](/documentation/screenshots/ELK_injection_detection_attemps.png)
Fig 7. Successful detection of the "passwd" and "cat" signatures in the HTTP request logs.


 Project Structure
Plaintext

purple-team-lab/
├── ansible/               # Configuration Management (The Brain)
│   ├── roles/             # Modular roles (Docker, SIEM, Victim, Phishing)
│   └── playbooks/         # Orchestration scripts
├── vagrant/               # Infrastructure Provisioning (The Body)
│   └── Vagrantfile        # Network & VM definitions (Ruby)
├── documentation/         # Diagrams & Screenshots
└── README.md              # Documentation



👤 Author
Abdoulaye - Cybersecurity Engineer / DevSecOps

Built for educational purposes and portfolio demonstration.