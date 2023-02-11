# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/bionic64"
    config.vm.network "forwarded_port", guest: 1456, host: 8081, protocol: "udp", auto_correct: true
    config.vm.provision "docker" do |dock|
         dock.run "/vagrant", args: "--privileged \
                                        --env=LOCAL_USER_ID=$(id -u) \
                                        -v /vagrant/src/PX4-Autopilot:/src \
                                        -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
                                        -e DISPLAY=:0 \
                                        -e LOCAL_USER_ID=$(id -u) \
                                        -p 14556:14556/udp \
                                        -w /src \
                                        --name=px4_container px4io/px4-dev-ros2-foxy:latest",
                                cmd: "make px4_sitl_default",
                                auto_assign_name: false
         dock.post_install_provision "shell",
        inline:"echo DOCKER_OPTS='${DOCKER_OPTS} -H unix:///var/run/docker.sock -H 0.0.0.0:2375' >> /etc/default/docker"


     end
     config.vm.synced_folder "./src", "/src", owner: "vagrant", docker_consistency: "delegated"

     config.vm.provider "virtualbox" do |vb|
      #   # Display the VirtualBox GUI when booting the machine
        vb.gui = true
      #   # Customize the amount of memory on the VM:
         vb.memory = "1024"
     end
 end

