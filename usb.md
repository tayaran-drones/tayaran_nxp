# Install VirtualBox Extension Pack

https://www.virtualbox.org/wiki/Downloads

# List connected usb devices

```
VBoxManage list usbhost
```

# Redirect the wanted device to the Vagrant VM

```
vb.customize ["modifyvm", :id, "--usb", "on"]
vb.customize ["modifyvm", :id, "--usbehci", "on"]
vb.customize ["usbfilter", "add", "0", 
  "--target", :id, 
  "--name", "This is the identifier",
  "--manufacturer", "SuYin",
  "--product", "Laptop_Integrated_Webcam_HD"]
```

# Example

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

This will not automatically redirect usb either, to redirect it on VM startup we have to use the following configuration option:

```
vb.customize "post-boot", ["controlvm", :id, "usbattach", "p=0x800b;v=0x8644;s=0x00038015f557c434;l=0x14130000"]
```

The last parameter is from `VBoxManage list usbhost` **Address** line.

# MacOS Difficulties

NS_ERROR_FAILURE (0x80004005) Unable to create proxy device for USB

Currently there are no known solution for it. Only run it with elevated privilegies (root)
So we have to run sudo `sudo /Applications/VirtualBox.app/Contents/MacOS/VirtualBox` and then `sudo vagrant up`
