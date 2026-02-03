# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.synced_folder ".", "/vagrant", type: "rsync"
  
  # Configuration globale du Provider (KVM/Libvirt)
  config.vm.provider :libvirt do |libvirt|
    libvirt.driver = "kvm"
    libvirt.uri = "qemu:///system"
    # mode "virtio" pour les performances réseau max sous CachyOS
    libvirt.nic_model_type = "virtio" 
  end
  
  # ==========================================
  # ZONE 1 : PUBLIC (Attaquant)
  # ==========================================
  config.vm.define "attacker" do |attacker|
    attacker.vm.box = "kalilinux/rolling"
    attacker.vm.hostname = "kali-attacker"
    
    attacker.vm.provider :libvirt do |v|
      v.memory = 4096  # 4 Go RAM
      v.cpus = 2
    end

    # Réseau "Public" simulé (10.10.10.x)
    attacker.vm.network "private_network", 
      ip: "10.10.10.5", 
      libvirt__network_name: "ptl-public",
      libvirt__dhcp_enabled: false
  end

  # ==========================================
  # ZONE 2 : DMZ (Services exposés & Monitoring)
  # ==========================================
  
  # VM Phishing (GoPhish)
  config.vm.define "phishing" do |phishing|
    phishing.vm.box = "generic/debian12" 
    phishing.vm.hostname = "srv-phishing"

    phishing.vm.provider :libvirt do |v|
      v.memory = 2048 
      v.cpus = 2
    end

    # Interface vers le Public (pour envoyer les mails/être accessible)
    phishing.vm.network "private_network", 
      ip: "10.10.10.10", 
      libvirt__network_name: "ptl-public",
      libvirt__dhcp_enabled: false

    # Interface vers la DMZ (Gestion interne)
    phishing.vm.network "private_network", 
      ip: "10.10.20.10", 
      libvirt__network_name: "ptl-dmz",
      libvirt__dhcp_enabled: false
  end

  # VM Surveillance (ELK + Suricata)
  config.vm.define "siem" do |siem|
    siem.vm.box = "generic/ubuntu2204"
    siem.vm.hostname = "srv-siem"

    siem.vm.provider :libvirt do |v|
      v.memory = 6144
      v.cpus = 4
    end

    # Interface d'écoute sur la DMZ (Pour recevoir les logs)
    siem.vm.network "private_network", 
      ip: "10.10.20.50", 
      libvirt__network_name: "ptl-dmz",
      libvirt__dhcp_enabled: false

    # Port forwarding pour accéder à Kibana depuis le navigateur CachyOS
    siem.vm.network "forwarded_port", guest: 5601, host: 5601
  end

  # ==========================================
  # ZONE 3 : PRIVATE (Victime Interne)
  # ==========================================
  config.vm.define "victim" do |victim|
    victim.vm.box = "generic/ubuntu2204"
    victim.vm.hostname = "wks-victim"

    victim.vm.provider :libvirt do |v|
      v.memory = 2048
      v.cpus = 2
    end

    # Réseau Privé (Pas d'accès direct depuis le public)
    victim.vm.network "private_network", 
      ip: "10.10.30.100", 
      libvirt__network_name: "ptl-private",
      libvirt__dhcp_enabled: false

    # Route vers la DMZ pour envoyer les logs au SIEM (Simulé via 2eme interface ici pour simplicité labo)
    victim.vm.network "private_network", 
      ip: "10.10.20.100", 
      libvirt__network_name: "ptl-dmz",
      libvirt__dhcp_enabled: false
  end

end