# -*- mode: ruby -*-
# vi: set ft=ruby :

#When there is an error - use this command to clean the environment
#make clean && make submodulesclean
#system("
#    if [ #{ARGV[0]} = 'up' ]; then
#        echo 'Updating git submodules...'
#        git submodule sync --recursive
#        git submodule update --recursive
#        #cd src/PX4-Autopilot
#        #git submodule sync --recursive
#        #git submodule update --recursive
#    fi
#")


# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.
  # It's possible to make git modules update on local machine before "up" 
  #config.trigger.before [:up] do |trigger|
  #  trigger.info = "Updating git submodules..."
  #  trigger.run = {path: "git submodule sync --recursive"}
  #end

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "hashicorp/bionic64"
  config.vbguest.auto_update = false if Vagrant.has_plugin?("vagrant-vbguest")
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
  config.vm.synced_folder ".", "/vagrant", owner: "vagrant", group: "vagrant", automount: true, mount_options: ["uid=1000", "gid=1000","dmode=775","fmode=775"]

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
    vb.gui = true
  #   # Customize the amount of memory on the VM:
     vb.memory = "4096"
     vb.cpus = "4"
  # Enable symlink support (tested but not working at all) workaround is in the README.md
     vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/vagrant", "1"]
     vb.customize ["setextradata", :id, "GUI\/LastGuestSizeHint","1440,900"]
  # 3d acceleration
     vb.customize ["modifyvm", :id, "--accelerate3d","on"]
     #vb.customize ["modifyvm", :id, "--graphicscontroller","vmsvga"] # there is bug using this, as some display artifacts accurs
     vb.customize ["modifyvm", :id, "--hwvirtex","on"]
     vb.customize ["modifyvm", :id, "--ioapic","on"]
     vb.customize ["modifyvm", :id, "--vram","128"]
  # Enable USB support
     vb.customize ["modifyvm", :id, "--usb", "on"]
     vb.customize ["modifyvm", :id, "--usbehci", "on"] # for USB 2.0
#     vb.customize ["modifyvm", :id, "--usbxhci", "on"] # for USB 3.0
# Add the desired usb device, look at usb.md
#     vb.customize ["usbfilter", "add", "0",
#       "--target", :id,
#       "--name", "usbstick",
#       "--vendorid", "8644",
#       "--productid", "800B",
#       "--product", "USB Flash Disk",
#       "--manufacturer","General"]
# Attach the desired usb device on the VM startup, look at usb.md
     #vb.customize "post-boot", ["controlvm", :id, "usbattach", "p=0x800b;v=0x8644;s=0x00038015f557c434;l=0x14130000"] # macOS syntax
     vb.customize "post-boot", ["controlvm", :id, "usbattach","{36fc9e60-c465-11cf-8056-444553540000}\\0012"] # Windows syntax
   end


  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Ansible, Chef, Docker, Puppet and Salt are also available. Please see the
  # documentation for more information about their specific syntax and use.

  config.vm.provision "shell", privileged: true, inline: <<-SHELL
    apt-get install -y dkms
    apt-get upgrade -y
    apt-get install -y git ubuntu-desktop gstreamer1.0-plugins-bad gstreamer1.0-libav gstreamer1.0-gl libqt5gui5 libfuse2 libsdl2-2.0-0 ntpdate
    usermod -aG docker vagrant
    usermod -aG dialout vagrant
    sed -i 's/#  Automatic/Automatic/g' /etc/gdm3/custom.conf
    sed -i 's/user1/vagrant/g' /etc/gdm3/custom.conf
    echo "X-GNOME-Autostart-enabled=false" > /etc/xdg/autostart/gnome-initial-setup-first-login.desktop
    systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
    echo "export DISPLAY=:0" > /etc/profile.d/globals.sh
    if ! grep -q xhost /home/vagrant/.bashrc; then
       echo "xhost + > /dev/null" >> /home/vagrant/.bashrc
    fi
    systemctl disable apport
    # remove unecessary packages
    apt-get remove --purge -y apport whoopsie modemmanager
    rm /var/crash/*
    if ! [ -e "/home/vagrant/QGroundControl.AppImage" ]; then
      echo "QGroundControl was not found, downloading..."
      wget https://d176tv9ibo4jno.cloudfront.net/latest/QGroundControl.AppImage -O /home/vagrant/QGroundControl.AppImage
      chown vagrant:vagrant /home/vagrant/QGroundControl.AppImage
      chmod +x /home/vagrant/QGroundControl.AppImage
    fi
    sudo ntpdate pool.ntp.org
    echo "*/5 * * * * root ntpdate pool.ntp.org >> /dev/null 2>&1" > /etc/cron.d/timefix
  SHELL

  # time zone autodetection
  Vagrant.configure("2") do |config|
    require "time"
    offset = ((Time.zone_offset(Time.now.zone) / 60) / 60) + (Time.now.dst? ? 1 : 0)
    timezone_suffix = offset >= 0 ? "-#{offset.to_s}" : "+#{offset.to_s}"
    timezone = 'Etc/GMT' + timezone_suffix
    config.vm.provision :shell, privileged: true, inline: <<-'SHELL'
      ln -fs /usr/share/zoneinfo/#{timezone} /etc/localtime
      dpkg-reconfigure -f noninteractive tzdata
    SHELL
  end

  config.vm.provision :shell do |shell|
    shell.privileged = true
    shell.inline = "echo Rebooting"
    shell.reboot = true
  end

  # launch docker and redirect display to VM
  #$unprivileged = <<-SCRIPT
  config.vm.provision "shell", privileged: false, inline: <<-'SHELL'
    DISPLAY=:0 gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout 0
    DISPLAY=:0 gsettings set org.gnome.desktop.session idle-delay 0
    DISPLAY=:0 gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 0
    DISPLAY=:0 gsettings set org.gnome.desktop.screensaver ubuntu-lock-on-suspend false
    DISPLAY=:0 gsettings set org.gnome.desktop.lockdown disable-lock-screen true
    DISPLAY=:0 gsettings set org.gnome.desktop.screensaver lock-enabled false
    # update git
    echo "Updating git modules..."
    cd /vagrant
    #git submodule sync --recursive
    git submodule update --init --recursive
    git submodule update --recursive
    echo "git is up to date"
    # Avoid the "has modification time x.x s in the future. Clock skew detected.  Your build may be incomplete." errors
    #echo "Files timestamp fix..."
    #find /vagrant/src -type f -exec touch {} +
    #echo "Files timestamp fix done."
    run=`docker container inspect -f '{{.State.Running}}' px4`
    if [ "$run" == "true" ]; then
      echo "Docker already running!!!"
      docker stop px4
      echo "Docker stopped.."
    fi
    if docker ps -aq -f status=exited -f name=px4; then
      echo "Removing docker container.."
      docker container rm px4 -f
    fi
    echo "Building docker container.."
    cd /vagrant && docker build -t px4_app .
    chmod +x /vagrant/src/app/app.py
    echo "Starting docker container.."
    docker run -d\
        --restart=always \
        --env=LOCAL_USER_ID="$(id -u)" \
        -v /vagrant:/vagrant:rw \
        -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
        -e DISPLAY=:0 \
        -e LOCAL_USER_ID="$(id -u)" \
        -w /vagrant/src/PX4-Autopilot \
        --name=px4 px4_app sleep infinity
    DISPLAY=:0 xhost +local:
    docker exec -w /vagrant/src/PX4-Autopilot px4 make px4_sitl_default
    docker exec -w /vagrant/src px4 /enter colcon build
    # docker exec -w /vagrant/src px4 .~/opt/ros/foxy/setup.bash && colcon build
    # users logged via ssh can use command: docker exec px4 gazebo ...
    # write exact ip address of the docker to the QGC config
    if ! [ -d /home/vagrant/.config/QGroundControl.org ]; then
       echo "QGC Config dir was not found, creating..."
       mkdir /home/vagrant/.config/QGroundControl.org
    fi 
    # retrieve docker ip
    echo "Retrieving docker ip..."
    DOCKER_IP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' px4)
    echo "Docker ip: $DOCKER_IP"
    if [ -e /home/vagrant/.config/QGroundControl.org/QGroundControl.ini ]; then
    # delete current LinkConfiguration definitions
       echo "QGC configuration was found, altering configuration..."
       sed -i '/^\[LinkConfigurations\]/,/^$/d' /home/vagrant/.config/QGroundControl.org/QGroundControl.ini
    fi
    # add new LinkConfiguration definitions
    echo "Configuring QGC Links..."
    cat >> /home/vagrant/.config/QGroundControl.org/QGroundControl.ini <<EOF
[LinkConfigurations]
Link0\auto=true
Link0\high_latency=false
Link0\host0=$DOCKER_IP
Link0\hostCount=1
Link0\name=gazebo
Link0\port=18570
Link0\port0=18570
Link0\type=1
count=1
EOF
  SHELL
end
