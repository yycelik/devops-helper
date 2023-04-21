clear
#https://docs.oracle.com/en/virtualization/virtualbox/6.0/user/vboxmanage-modifyvm.html

# Virtual box base folder
$VirtualBoxPath = $args[0]

# Server Name
$ServerName=$args[1]


# Iso path
$IsoPath=$args[2]


# Go to vm folder
$VBoxManage=$VirtualBoxPath + "\VBoxManage"
Write-Host "VBoxManage path :" + $VBoxManage

# Get machine folder
$ServerFolderTemp = &$VBoxManage list systemproperties | Select-String -Pattern "Default machine folder:"
$ServerFolder = ($ServerFolderTemp -split ':', 2)[1].Trim()
Write-Host "Machine path :" + $ServerFolder

# Create disk path
$DiskPath = "$ServerFolder\$ServerName\$ServerName"+ "_DISK.vdi"
Write-Host "Disk path :" + $DiskPath

# Create VM
&$VBoxManage createvm --name $ServerName --ostype "Ubuntu_64" --register --basefolder $ServerFolder

# Set cpu
&$VBoxManage modifyvm $ServerName --cpus 2 --paravirtprovider hyperv

# Set memory and network
&$VBoxManage modifyvm $ServerName --ioapic on
&$VBoxManage modifyvm $ServerName --memory 2048 --vram 128
# Network Types [none|null|nat|bridged|intnet|hostonly|generic|natnetwork]
&$VBoxManage modifyvm $ServerName --nic1 bridged --nicpromisc allow-all

# Create Disk and connect Debian Iso
&$VBoxManage createhd --filename $DiskPath --size 10000 --format VDI
&$VBoxManage storagectl $ServerName --name "SATA Controller" --add sata --controller IntelAhci
&$VBoxManage storageattach $ServerName --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium $DiskPath
&$VBoxManage storagectl $ServerName --name "IDE Controller" --add ide --controller PIIX4
&$VBoxManage storageattach $ServerName --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium $IsoPath
&$VBoxManage modifyvm $ServerName --boot1 dvd --boot2 disk --boot3 none --boot4 none

# Enable RDP
#&$VBoxManage modifyvm $ServerName --vrde on
#&$VBoxManage modifyvm $ServerName --vrdemulticon on --vrdeport 10001

# Start the VM
#VBoxHeadless --startvm $ServerName