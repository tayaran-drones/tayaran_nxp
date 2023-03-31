# tayaran_nxp

## 1 Get laest version of PX$

`cd src/PX4-AutoPilot && git checkout main`

## 2 Run Vagrant Up

`vagrant up`

## 3 SSH Into Virtual Machine or Log in through GUI

`vagrant ssh` | log in to with `vagrant` as both username and password

## Gazebo Simulations
### Method 1 - Dynamic Simulation

[https://docs.px4.io/v1.12/en/simulation/gazebo_vehicles.html](https://docs.px4.io/v1.12/en/simulation/gazebo_vehicles.html)

Go inside docker container using `docker attach px4` and run
`make px4_sitl gazebo_solo` for Quadrotor

### Method 2 - Static Simulation

Go inside test_pkg, source your bash and run the following:
```
ros2 run test_pkg drone_launch.py
```

## Testing

```
vagrant ssh
docker exec -it px4 make px4_sitl_default gazebo
```

## QGroundControl

```
vagrant ssh
./QGroundControl.AppImage
```

## ROS2 Integration
Go inside docker container using `docker exec -it px4 bash`, navigate to parent directory using `cd ../..` and run
```
source /opt/ros/foxy/setup.bash
colcon build
```

## USB Support

### Install VirtualBox Extension Pack

https://www.virtualbox.org/wiki/Downloads

### List connected usb devices

```
VBoxManage list usbhost
```

### Redirect the wanted device to the Vagrant VM

```
vb.customize ["modifyvm", :id, "--usb", "on"]
vb.customize ["modifyvm", :id, "--usbehci", "on"]
vb.customize ["usbfilter", "add", "0", 
  "--target", :id, 
  "--name", "This is the identifier",
  "--manufacturer", "SuYin",
  "--product", "Laptop_Integrated_Webcam_HD"]
```

### Example

```
VBoxManage list usbhost

  UUID:               13270e22-b0e8-4efc-bd57-75541c649dee
  VendorId:           0x8644 (8644)
  ProductId:          0x800b (800B)
  Revision:           1.0 (0100)
  Port:               0
  USB version/speed:  0/High
  Manufacturer:       General 
  Product:            USB Flash Disk  
  SerialNumber:       880000000000017E
  Address:            p=0x800b;v=0x8644;s=0x00038015f557c434;l=0x14130000
  Current State:      Busy
```

Vagrant config should be:

```
vb.customize ["modifyvm", :id, "--usb", "on"]
vb.customize ["modifyvm", :id, "--usbehci", "on"]
vb.customize ["usbfilter", "add", "0",
  "--target", :id,
  "--vendorid", "8644",
  "--productid", "800B",
  "--product", "USB Flash Disk"]
```

**This will not automatically redirect usb either**, to redirect it on VM startup we have to use the following configuration option:

```
vb.customize "post-boot", ["controlvm", :id, "usbattach", "p=0x800b;v=0x8644;s=0x00038015f557c434;l=0x14130000"]
```

The last parameter is from `VBoxManage list usbhost` **Address** line.

### Linux

Untested, but should work as expected.


### Windows

VirtualBox and cmd where vagrant is called must be running with Administrator privilegies.

On windows machine the device address can contain **\** (slahes) and must be escaped with one more slash, for example if we have the device addres like this: `{36fc9e60-c465-11cf-8056-444553540000}\0012` we have to escape \0012 with \, the full correct vagrant config line will look like:
```
vb.customize "post-boot", ["controlvm", :id, "usbattach","{36fc9e60-c465-11cf-8056-444553540000}\\0012"]
```

### MacOS Difficulties

*NS_ERROR_FAILURE (0x80004005) Unable to create proxy device for USB*

Currently there are no known solution for it (https://forums.virtualbox.org/viewtopic.php?f=8&t=107333). Only run it with elevated privilegies (root)
So we have to run sudo `sudo /Applications/VirtualBox.app/Contents/MacOS/VirtualBox` and then `sudo vagrant up`


## Git submodules reset

### Method 1

```
git submodule foreach --recursive git reset --hard
```
However, it may fail under some cases, especially after a merging which remove/add submodules.

### Method 2

```
# unbinds all submodules
git submodule deinit -f .
# checkout again
git submodule update --init --recursive
```
