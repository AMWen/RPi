
# Assignment 1

### Readings

  * [The curious case of the Raspberry Pi in the network closet](https://blog.haschek.at/2018/the-curious-case-of-the-RasPi-in-our-network.html)
  * [C Is Not a Low-level Language, Your computer is not a fast PDP-11.](https://queue.acm.org/detail.cfm?id=3212479)
  * [Getting started with Docker on your Raspberry Pi](https://blog.hypriot.com/getting-started-with-docker-on-your-arm-device/)

### Assignment

NB.  For this one assignment you may work together.  ALL other assignments in this class are to be done separately, but this one is different.  The goal here is to have you complete the assignment with a working R/Pi image that you can ssh to and whatever it takes to get there is ok as you will not be able to do Assignments 3, 4, or the Final Project with out that.  

__Grading__: Grading for this one is Zero or 100, you either have it or you don't.

If you have questions, ask them in the discussion channel.  All of the tasks in this assignment (as in all assignments actually) have been demonstrated for you in class.

At a terminal prompt do the following:

0) Pull the latest copy of the assignments repo. And at the command prompt change into the Assignment1 directory

1) Install [homebrew: ](https://brew.sh)

```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master install)"
```

2)  Install nmap

```
brew install nmap
```

3) Install flash

```
curl -LO https://github.com/hypriot/flash/releases/download/2.2.0/flash
chmod +x flash
sudo mv flash /usr/local/bin/flash
```

4) Create a new ssh key with:

```
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_e16
```

give it a password that you can remember (or none at all if you don’t care)

5) Add the contents of `~/.ssh/id_e16.pub` to the file: `e16_01_setup_system.yml` between lines 29 and 30, i.e. right ahead the instructor ssh keys.  Be sure to prepend exactly the same number of empty spaces to your line that my line has.  Also in that same file change lines 12 and 13 to have the network name and password of your WiFi network.  IF AND ONLY IF YOU WILL NOT WANT ASSISTANCE FROM THE INSTRUCTORS YOU MAY REMOVE THEIR PUBLIC KEYS.

6) On lines 7 and 8 of `e16_02_write_system_files.yml` put the details of your local wifi network (SSID/password).  Again make it look just like mine only with your own details.

7) You will receive an VPN configuration file, put the contents of that file in: `e16_03_write_vpn_files.yml` between lines 1 and 2.  You must indent every line by 6 spaces.

AFTER you have all of the above files configured you may proceed to the following steps

8) Stick your SD card in the slot.  Run the command:

```
mount | grep /dev/disk
```

and observe what device it mounted on.  If you don’t have anything else mounted it will be at 2.  Here’s an example of my output which is at 3 (the last two lines).  

```
woodbury:~ rvs$ mount | grep /dev/disk
/dev/disk1s1 on / (apfs, local, journaled)
/dev/disk1s4 on /private/var/vm (apfs, local, noexec, journaled, noatime, nobrowse)
/dev/disk3s1 on /Volumes/HypriotOS (msdos, local, nodev, nosuid, noowners)
/dev/disk3s2 on /Volumes/root (ufsd_ExtFS, local, nodev, nosuid, noowners)
```

If you have a fresh SD card it should be some FAT32 device when it mounts:

You are now ready to run the flash command.
    
9) from within the E16Image dir, type:

```
./flash.sh (the device number of the mount)
```

this should give output like:

```
creating cloud-init file...
cat ./e16_01_setup_system.yml ./e16_02_write_system_files.yml ./e16_03_write_vpn_files.yml ./e16_04_write_startup_files.yml ./e16_05_once_only_commands.yml > ./hypriot.yml
executing...
flash --device /dev/disk3 --metadata ./metadata.txt --userdata ./hypriot.yml --bootconf ./config.txt https://www.dropbox.com/s/kr7po419adjsfoc/hypriotos-rpi64-e16-20190305.img.zip?dl=1
/usr/bin/curl
Downloading https://www.dropbox.com/s/kr7po419adjsfoc/hypriotos-rpi64-e16-20190305.img.zip?dl=1 ...

Uncompressing /tmp/image.img.zip?dl=1 ...
Archive:  /tmp/image.img.zip?dl=1
  inflating: /tmp/hypriotos-rpi64-playspot-20190305.img  
Use /tmp/hypriotos-rpi64-playspot-20190305.img

Is /dev/disk3 correct? y
Unmounting /dev/disk3 ...
Unmount of all volumes on disk3 was successful
Unmount of all volumes on disk3 was successful
Flashing /tmp/hypriotos-rpi64-playspot-20190305.img to /dev/rdisk3 ...
Password:
1000MiB 0:02:19 [7.14MiB/s] [============================================================================================>] 100%            
0+16000 records in
0+16000 records out
1048576000 bytes transferred in 136.736944 secs (7668564 bytes/sec)
Mounting Disk
Mounting /dev/disk3 to customize...
Copying ./config.txt to /Volumes/HypriotOS/config.txt ...
Copying cloud-init ./hypriot.yml to /Volumes/HypriotOS/user-data ...
Copying cloud-init ./metadata.txt to /Volumes/HypriotOS/meta-data ...
Unmounting /dev/disk3 ...
"disk3" ejected.
Finished.
```

10) Now the moment of truth.  Take the SD card out and stick it in the R/Pi.  This part is most reliable if you have a wired ethernet to hook it to.  It will use the WiFi successfully if you don't, provided that you have not messed up any of the network details when making the file.  

If you have an HDMI monitor handy, hook it up to the Pi.  you should see a continuous set of messages scrolling by.

If all is good, on the mac, you can do:

```
sudo nmap -sP 192.168.1.0/24
```

Here’s what the relevant part of mine looks like:

<pre>
woodbury:~ rvs$ sudo nmap -sP 192.168.1.0/24 
Starting Nmap 7.70 ( https://nmap.org ) at 2019-01-28 16:08 EST
Nmap scan report for FIOS_Quantum_Gateway.fios-router.home (192.168.1.1)
Host is up (0.00032s latency).
MAC Address: 48:5D:36:87:07:80 (Verizon)
Nmap scan report for compute-cycles-backup.fios-router.home (192.168.1.2)
Host is up (0.0021s latency).
MAC Address: 80:EA:96:E7:55:BF (Apple)
Nmap scan report for ComputeCyclesHQ.fios-router.home (192.168.1.5)
Host is up (0.00028s latency).
MAC Address: 00:90:A9:E6:C5:76 (Western Digital)
Nmap scan report for Apple-TV-10.fios-router.home (192.168.1.9)
Host is up (0.0021s latency).
MAC Address: 80:EA:96:E7:55:BF (Apple)
Nmap scan report for Emmas-MacBook.fios-router.home (192.168.1.11)
Host is up (0.088s latency).
MAC Address: A8:66:7F:18:FF:F6 (Apple)
Nmap scan report for Lights.fios-router.home (192.168.1.151)
Host is up (0.00054s latency).
MAC Address: 00:17:88:68:9D:F4 (Philips Lighting BV)
Nmap scan report for Ronalds-iPad.fios-router.home (192.168.1.157)
Host is up (0.090s latency).
MAC Address: E8:B2:AC:44:A2:C4 (Apple)
<b>Nmap scan report for black-pearl.fios-router.home (192.168.1.186)
Host is up (0.00016s latency).
MAC Address: B8:27:EB:E0:8F:85 (Raspberry Pi Foundation)</b>
Nmap scan report for woodbury.fios-router.home (192.168.1.152)
Host is up.
Nmap scan report for woodbury.fios-router.home (192.168.1.153)
Host is up.
Nmap done: 256 IP addresses (10 hosts up) scanned in 2.45 seconds
</pre>

11) when you see the above you can:

```
ssh -i ~/.ssh/id_e16 e16@192.168.1.186
```

and you are now on your new Pi with the 64 bit OS.

12) after about 10 minutes you should be able to, on the Pi, run:

```
docker ps --all
```

And observe:

```
CONTAINER ID        IMAGE                           COMMAND                  CREATED             STATUS              PORTS               NAMES
594bf990981d        v2tec/watchtower:armhf-latest   "/watchtower --clean…"   13 minutes ago      Up 13 minutes                           watchtower
```

That’s nearly the last step in the install, so if you see that, it all went well.  

If you don’t see that type:

```
tail -1000f /var/log/cloud-init-output.log
```

and post the output in and we can debug.

**For your grade:** Issue the following commands on your Pi:

```
ifconfig
ping 10.8.0.1
```

Then cut and paste the output of each into an email and send it to me.


