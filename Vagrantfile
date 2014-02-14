# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_plugin "vagrant-berkshelf"
Vagrant.require_plugin "vagrant-omnibus"

Vagrant.configure("2") do |config|
  config.vm.hostname = "testing-machine"

  # Set the version of chef to install using the vagrant-omnibus plugin
  config.omnibus.chef_version = :latest

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "opscode_ubuntu-12.04_provisionerless"
  config.vm.define "testing-server" do |t| end

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "https://opscode-vm-bento.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04_provisionerless.box"

  config.vm.network :private_network, ip: "33.33.33.20"

  config.vm.provider :virtualbox do |box|
    box.customize ["modifyvm", :id, "--cpus", "2"]
    box.customize ["modifyvm", :id, "--memory", "2048"]
  end

  config.vm.synced_folder "src/", "/home/vagrant/src"
  config.ssh.forward_agent = true
  config.ssh.forward_x11 = true

  config.vm.provision "shell", inline: "apt-get -y install ia32-libs libglib2.0-dev libnss3 libgvc5 libgtkmm-3.0 libnotify4"

  config.vm.provision :chef_solo do |chef|
    chef.add_recipe "apt"
    chef.add_recipe "sudo"
    chef.add_recipe "console-development"
    chef.add_recipe "chromedriver"
    chef.add_recipe "nodejs"
    chef.add_recipe "rvm::vagrant"
    chef.add_recipe "rvm::user"
    chef.add_recipe "mongodb::10gen_repo"
    chef.add_recipe "mongodb"
    chef.add_recipe "mysql"
    chef.add_recipe "mysql::server"
    chef.add_recipe "mysql::ruby"
    chef.add_recipe "imagemagick::devel"
    chef.add_recipe "imagemagick::rmagick"
    chef.json = {
      authorization: {
        :sudo => {
          :users => ['vagrant'],
          :passwordless => true
        }
      },
      rvm: {
        vagrant: {
          system_chef_solo: '/usr/bin/chef-solo'
        },
        user_installs: [
          {
            'install_rubies' => true,
            'user' => 'vagrant',
            'rubies' => ['ruby-2.0.0-p353'],
            'default_ruby' => 'ruby-2.0.0-p353'
          }
        ]
      },
      mysql: {
        'server_root_password' => 'howareyou',
        'server_repl_password' => 'howareyou',
        'server_debian_password' => 'howareyou'
      }
    }
  end

  if File.exists?(File.join(Dir.home, ".ssh", "id_rsa"))
      github_ssh_key = File.read(File.join(Dir.home, ".ssh", "id_rsa"))
      known_hosts_file = File.read(File.join(Dir.home, ".ssh", "known_hosts"))
      config.vm.provision :shell, :inline => "
        echo 'Copying local GitHub SSH Key to VM for provisioning...'
        mkdir -p /home/vagrant/.ssh
        echo '#{github_ssh_key}' > /home/vagrant/.ssh/id_rsa && chmod 600 /home/vagrant/.ssh/id_rsa
        echo '#{known_hosts_file}' > /home/vagrant/.ssh/known_hosts && chmod 600 /home/vagrant/.ssh/known_hosts
      ", privileged: false
  else
      raise Vagrant::Errors::VagrantError, "\n\nERROR: GitHub SSH Key not found at /home/vagrant/.ssh/id_rsa\n\n"
  end

  config.vm.provision :shell, path: "backend.sh", privileged: false
  config.vm.provision :shell, path: "frontend.sh", privileged: false
    
end

