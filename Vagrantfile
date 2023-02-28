# -*- mode: ruby -*-
# vi: set ft=ruby :

#When there is an error - use this command to clean the environment
#make clean && make submodulesclean
system("
    if [ #{ARGV[0]} = 'up' ]; then
        echo 'You are doing vagrant up and can execute your script'
        cd src/PX4-Autopilot
        git submodule sync --recursive
        git submodule update --recursive
    fi
")
# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "ubuntu/focal64"
  config.vm.provision "shell", inline: "echo 'Acquire::Check-Date false;' | tee -a /etc/apt/apt.conf.d/10-nocheckvalid"
  config.vm.provision "docker" do |d|
    #d.build_image "/vagrant"
    d.post_install_provision "shell",
    inline:"echo DOCKER_OPTS='${DOCKER_OPTS} -H unix:///var/run/docker.sock -H 0.0.0.0:2375' >> /etc/default/docker"

  end
  ssh_pub_key = File.readlines("#{Dir.home}/.ssh/id_rsa.pub").first.strip
  config.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/id_rsa.pub"
  config.vm.provision "file", source: "~/.ssh/id_rsa", destination: "~/.ssh/id_rsa"
  config.vm.provision "shell", inline: <<-SHELL
    cat /home/vagrant/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
  SHELL
  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder "./src", "/src", owner: "vagrant", group: "vagrant", automount: true, mount_options: ["uid=1000", "gid=1000"]

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
    vb.gui = true
  #   # Customize the amount of memory on the VM:
     vb.memory = "2048"
     vb.cpus = "4"
  # Enable symlink support (tested but not working at all) workaround is in the README.md
  #   vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/src", "1"]
   end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Ansible, Chef, Docker, Puppet and Salt are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "shell", inline: <<-SHELL
    cd /vagrant && docker build -t px4_app .
    sudo apt restart
    chmod +x /vagrant/src/app/app.py
    docker container rm px4 -f
    docker run -d --privileged \
        --env=LOCAL_USER_ID=`$(id -u)` \
        -v /vagrant:/vagrant:rw \
        -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
        -e DISPLAY=:0 \
        -e LOCAL_USER_ID=`$(id -u)` \
        -p 14556:14556/udp \
        -w /vagrant/src/PX4-Autopilot \
        --name=px4 px4_app \
        sleep infinity
    docker exec px4 make px4_sitl_default

  SHELL
end