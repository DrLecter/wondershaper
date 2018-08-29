The Wonder Shaper 1.4
==============

Copyright
-------------

Copyright (c) 2002-2017 Bert Hubert <ahu@ds9a.nl>, Jacco Geul <jacco@geul.net>, Simon Séhier <simon@sehier.fr>

See the ChangeLog for information on the individual contributions of the authors.

About
--------------

Wonder Shaper is a script that allow the user to limit the bandwidth of one or more network adapters. It does so by using iproute's tc command, but greatly simplifies its operation. Wonder Shaper was first released by Bert Hubert in 2002, but the original version lacked a command-line interface, from on version 1.2 this feature was added. From version 1.3, the HTB queing is used instead of CBQ, allowing better bandwith managment on high speed (above ten megabits) links. In version 1.4 an improved ingress shaping method was implemented and the ability to limit either down or up (both is still possible too). The original README is a rather lengthy document and is saved under README.old, for those who'd like some more background information. Except any notes on operation this document is considered up-to-date.

Installation
--------------

### Obtaining wondershaper

It is recommended to clone the GitHub repository of wondershaper such that you can pull in new updates at any time (if available). Open a new terminal and clone the repository using

    git clone  https://github.com/magnific0/wondershaper.git

This will clone wondershaper in your current folder in a new folder named wondershaper. Now enter the folder using

    cd wondershaper
    
### Using wondershaper
    
You can run wondershaper (as any user with sufficient permissions) without installation and stop following the instructions at this point. Show the wondershaper usage instructions by typing

    ./wondershaper -h
    
The program details all available options on how to use wondershaper. Next is to pick an interface that you want to shape. You can see all availble interfaces by typing

    ip addr show
    
Note that on older systems this command might not be available. In this case you should run ```ifconfig``` instead.

Identify the network interface that you want to shape. The names [differ per system](https://www.freedesktop.org/wiki/Software/systemd/PredictableNetworkInterfaceNames/).

In the following example a wireless interface is limited to an [upload of 4Mbps and download of 8Mbps](http://whatsabyte.com/).

    ./wondershaper -a wlp4s0 -u 4096 -d 8192

If you get messages telling you that ```RTNETLINK answers: Operation not permitted``` your user account does not have sufficient priviliges. In that case try:

    sudo ./wondershaper -a wlp4s0 -u 4096 -d 8192
    
### System installation (optional)

A makefile file provided for easy installation. This version of wondershaper installs the actual wondershaping script in /sbin (the Debian way). An additional wrapping script -also called wondershaper- is put in ```/usr/bin```. This wrapper parses .conf files when "start" or "stop" parameters are provided, behaving as the original script otherwise. If you want to install to your system you can run:

    sudo make install
        
You can verify that wondershaper was installed correctly by entering (as root):

    for i in ${PATH//:/ };do find "$i/wondershaper" 2> /dev/null; done
    
This should return 

```/sbin/wondershaper```
```/usr/bin/wondershaper```

You can follow the same instructions as explained in the "Using wondershaper" section, but instead of running the local version of the program you now run the system version by removing the ```./``` from the beginning of each command. For example to show the help instructions again run:

    wondershaper -h

### Persistent usage of wondershaper (optional)

To make sure wondershaper is reactivated on reboot a systemd service file is provided. First enable wondershaper as a systemd service using:

    sudo systemctl enable wondershaper.service 
 
Instead of using the commandline options to set the rates and interface/s as previously shown, it is necessary to set these parameters in a ```.conf``` configuration file within ```/etc/conf.d/wondershaper```. You can edit these files using your favourite text editor (nano in the example below) as such:

    sudo nano /etc/conf.d/wondershaper/eth0.conf

One file must be created for every network adapter you need to shape, so set IFACE, DSPEED and USPEED values accordingly. File names aren't considered in any particular manner by the service startup script (```/usb/bin/wondershaper```) which just parses every .conf file found. It's up to you to choose a descriptive name.
    
This way wondershaper is activated with your setting upon reboot.

Usage
--------------

        wondershaper [-hcs] [-a <adapter>] [-d <rate>] [-u <rate>]

The following command line options are allowed:

- `-h` Display help

- `-a <adapter>` Set the adpter

- `-d <rate>` Set maximum download rate (in Kbps) and/or

- `-u <rate>` Set maximum upload rate (in Kbps)

- `-p` Use the presets in /etc/conf.d/wondershaper.conf

- `-c` Clear the limits from adapter

- `-s` Show the current status of adapter

The different modes are:

        wondershaper -a <adapter> -d <rate> -u <rate>

        wondershaper -c -a <adapter>

        wondershaper -s -a <adapter>
        
        wondershaper <start|stop>

Some examples:

        wondershaper -a eth0 -d 1024 -u 512

        wondershaper -a eth1 -d 94000 -u 94000  # could be used on a 100Mbps link

        wondershaper -a eth1 -u 94000  # only limit upload

        wondershaper -c -a eth0
        
        wondershaper start
        
