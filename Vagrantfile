# Vagrantfile for the quickstart tutorial

VEOS_BOX = "vEOS-4.24"

Vagrant.configure(2) do |config|
  config.vm.define "eos" do |eos|
    eos.vm.box = VEOS_BOX
    eos.vm.network :forwarded_port, guest: 22, host: 12201, id: 'ssh'
    eos.vm.network :forwarded_port, guest: 443, host: 12443, id: 'https'
    eos.vm.network "private_network", virtualbox__intnet: "exit3", ip: "192.168.3.1", auto_config: false
  end
end
