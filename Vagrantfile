# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/xenial64"
    config.vm.network "forwarded_port", guest: 1456, host: 8081, protocol: "udp", auto_correct: true
     config.vm.provision "docker" do |dock|
         dock.post_install_provision "shell", inline:"touch /vagrant/index.html && echo '<h1>Hello World!</h1>' > /vagrant/index.html"
         dock.build_image = "/vagrant", args: "--pull --name=px4_image"
         dock.run "px4_image", args: "--rm --privileged \
                                        --env=LOCAL_USER_ID='$(id -u)' \
                                        -v /vagrant/src/PX4-Autopilot:/src \
                                        -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
                                        -e DISPLAY=:0 \
                                        -e LOCAL_USER_ID="'$(id -u)'" \
                                        -p 14556:14556/udp \
                                        -w /src \
                                        --name=px4_container make px4_sitl_default", auto_assign_name: false

     end
     config.vm.provider "virtualbox" do |vb|
      #   # Display the VirtualBox GUI when booting the machine
        vb.gui = true
      #   # Customize the amount of memory on the VM:
         vb.memory = "1024"
     end
 end

