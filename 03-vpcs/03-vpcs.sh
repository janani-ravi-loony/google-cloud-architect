#################################
VPC, Subnet and Firewall
#################################
# https://app.pluralsight.com/library/courses/gcp-vcp-networks-architecting-global-private-clouds
# https://app.pluralsight.com/library/courses/gcp-leveraging-network-interconnection-options

###########################################################
############# NOTES

# Routes in Google Cloud Platform (GCP) are a fundamental component of the networking within Google Cloud's Virtual Private Cloud (VPC). They define the paths that network traffic should take from one entity to another within or outside of your VPC. Here are key details about routes in GCP:

# Purpose: Routes are used to direct network traffic between VM instances, the internet, and other networks. They determine how data packets travel from their source to their destination.

# Types of Routes:

# System-generated routes: Automatically created when you create a VPC. These routes manage traffic within the network and to the internet.
# Custom routes: Created by users to handle specific traffic patterns, such as routing certain traffic through a VPN or to specific external addresses.


# Gateway

# In Google Cloud Platform's Virtual Private Cloud (VPC), each subnet has an automatically allocated gateway IP address, typically the first usable IP address in the subnet range. Here’s what you need to know about the gateway in a VPC subnet:

# Function: The gateway serves as the default route for devices within the subnet that need to communicate with other subnets or the internet. It acts as an intermediary to forward outbound traffic from instances in the subnet to other destinations.

###########################################################


# Click on the hamburger menu -> View All Products -> Select and Pin VPC.

# Observe there is a default VPC created for you. Click on the default VPC.

# Click on all the tabs and observe the details.

# Observe there are 39 subnets created for you.

# Observe there are 4 default firewall rules created for you.


# Click on Firewall from the left pane.

# Click and observe each of the firewall rules.


---------------


# Click on VPC networks from the left pane.

# Click Create VPC network.

# Click on ? icon next to all the fields and observe the details.

name: loony-auto-vpc

# In subnet click "Automatic" and observe the details.

# Scroll down to Firewall rules
# # Observe loony-auto-vpc-deny-all-ingress and loony-auto-vpc-allow-all-egress are selected and cannot be deselected.

# Click on each of the ? icons and observe the details.

# Observe the 

# Select all the firewall rules


# Click Create.

# Click on "loony-auto-vpc" > subnet 

# Take a note of the primary IP range of us-central1 subnet.
# 10.128.0.0/20

# Click on the "Firewalls" tab

# Show the default firewall rules that we have created

# KEEP this tab OPEN!

# (we will shortly create a VM with http enabled and see the firewall rules change)

##############################
### Communication between VMs in same network

# On a new tab -> Compute Engine

# Create a VM instance with the following details:

name: loony-vm-us-central1
region: us-central1
zone: any
machine type: e2-micro

# Enable HTTP

Allow HTTP - check the checkbox


# Click Advanced options -> Networking

network: loony-auto-vpc
network service tier: Standard

# Click on Advanced Options -> Management 

# Paste this code on the Startup script textbox

----------------------------

#!/bin/bash

apt-get update
apt-get install nginx -y
cat <<EOF >/var/www/html/index.nginx-debian.html
<html><body><h1>WELCOME</h1>
<p>Here is my site set up as a startup script!</p>
</body></html>
EOF

----------------------------


# Click Create.

# Go to the VM instances page

http://<external-ip-of-loony-vm-us-central1>:80

# You should be able to see the web site!

# Go to tab where we have the firewall rules open - refresh the page

# NOTE the new rule that was automatically added

# Click through to the firewall rule and disable it

# Note that we can no longer access the web page


#########################################
# Notes

# Network Address: 10.128.0.0/20
# Subnet Mask: /20, which corresponds to 255.255.240.0 in dotted decimal notation.
# This subnet mask indicates that the first 20 bits of the IP address are fixed for network identification, and the remaining 12 bits are used for host addresses.

# In typical network setups, including those in cloud environments like Google Cloud Platform (GCP), specific IP addresses within any subnet are reserved for special purposes:

# Network Address (10.128.0.0): The first address of any subnet, in your case 10.128.0.0, is the network address. It is used to identify the subnet itself and is not assignable to individual devices. This address is crucial for network routing purposes as it represents the entire network segment.

# Gateway Address (10.128.0.1): Often, the first usable address in the subnet, following the network address, is assigned as the default gateway. In GCP, and many other networks, this address is used for the router or gateway that manages traffic between this subnet and other networks. This gateway is essential for enabling communication between the VMs in the subnet and the internet or other virtual networks within GCP.

# The IP address 10.128.0.1 would typically be the default gateway through which your VM at 10.128.0.2 would communicate with other networks outside its local subnet.

#########################################



Create a VM instance with the following details:

name: loony-vm-asia-south2
region: asia-south2
zone: any
machine type: e2-micro

Click Advanced options

network: default
network service tier: Standard

Click Create.

# Observe the internal IP its 10.190.0.2, 0 is reserved for subnet and 1 is reserved for gateway.

SSH into the loony-vm-us-central1 instance.

ping -c 4 loony-vm-asia-south2

ping -c 4 <internal-ip-of-loony-vm-asia-south2>

ping -c 4 <external-ip-of-loony-vm-asia-south2>


##################################################################
##################################################################
### Custom VPC

# Click on the hamburger menu on the top left corner of the console and select VPC.

# Create a custom VPC with the following details:

# https://www.ipaddressguide.com/cidr
name: loony-custom-vpc-asia
subnet creation mode: custom

New subnet:

name: loony-custom-asia-east1-subnet
region: asia-east1
IP stack type: IPv4 (single-stack)
ipv4 range: 10.130.0.0/20


# Network Address: 10.130.0.0
# Subnet Mask: /20, which corresponds to 255.255.240.0 in dotted decimal notation.
# This subnet mask indicates that the first 20 bits of the IP address are fixed for network identification, and the remaining 12 bits are used for host addresses.

# IP Range: The range of IP addresses in this subnet goes from 10.130.0.0 to 10.130.15.255.


# Click Secondary IP ranges and delete

# Click Done

# Click Create.
# Observe we havent given any firewall rules that is ok if we want we can add later.

# Click on the newly created network

# Show that we have only one subnet

##############################
### Provisioning a VM instance on custom mode VPC in Asia

# Go back to compute engine

# Create a VM instance with the following details:

name: loony-vm-asia-east1
region: us-central1 (no subnet in this region)
zone: any
machine type: e2-micro

# Click Advanced options -> Networking

network: loony-custom-vpc-asia
subnet: 
# No subnets at this region
network service tier: Standard

# Scroll up and set region as asia-east1
# Scroll down and now check the subnet

# Click Create.

--------------------

# Click on SSH and observe the error - just spins without logging in

# Open a new tab with VPC > loony-custom-vpc-asia > Firewall

# Click Add Firewall rule

name: loony-custom-allow-ssh
network: loony-custom-vpc-asia
direction of traffic: Ingress
action on match: Allow
target: All instances in the network
source filter: IPv4 ranges
source IP ranges: 0.0.0.0/0
[TICK] specified protocols and ports > tcp: 22

# Click Create.

# Go back to the VM instance(loony-vm-asia-east1) and click on SSH.
# Observe you are able to SSH into the VM.

--------------------
# From your local machine

ping -c 4 <external-ip-of-loony-vm-us-central1>
# It works

ping -c 4 <external-ip-of-loony-vm-asia-east1>
# It fails


# Go back to the VPC > loony-custom-vpc-asia > Firewall

# Delete the loony-custom-allow-ssh rule.

# Create a new rule with the following details:

name: loony-custom-allow-ssh-icmp
network: loony-custom-vpc-asia
direction of traffic: Ingress
action on match: Allow
target: All instances in the network
source filter: IPv4 ranges
source IP ranges: 0.0.0.0/0
[TICK] specified protocols and ports > tcp: 22
[TICK] specified protocols and ports > other > icmp

Click Create.


# Go to your local machine

ping -c 4 <external-ip-of-loony-vm-us-central1>
# It works

ping -c 4 <external-ip-of-loony-vm-asia-east1>
# It works

-------------------------------------------------

Go back to the VM instance(loony-vm-asia-east1) and click on SSH.

ping -c 4 <internal-ip-of-loony-vm-us-central1>
# It wont works as they are in different VPCs

SSH into the loony-vm-us-central1 instance.

ping -c 4 <internal-ip-of-loony-vm-asia-east1>
# It won't work as they are in different VPCs


##################################################################
##################################################################
### Network peering


# We already have a loony-custom-vpc-asia network with one subnet in asia-east1 and one VM provisioned on it

# Let's create a second custom mode VPC loony-custom-vpc-europe with one subnet in eorope-west1 and one VM provisioned on it


# Click on the hamburger menu on the top left corner of the console and select VPC.

# Create a custom VPC with the following details:

name: loony-custom-vpc-europe
subnet creation mode: custom

New subnet:

name: loony-custom-europe-west1-subnet
region: europe-west1
IP stack type: IPv4 (single-stack)
ipv4 range: 10.132.0.0/20

# Under firewall select

allow-ssh
allow-icmp


##############################
### Provisioning a VM instance on custom mode VPC in Europe

# Go back to compute engine

# Create a VM instance with the following details:

name: loony-vm-europe-west1
region: europe-west1 
zone: any
machine type: e2-micro

# Click Advanced options -> Networking

network: loony-custom-vpc-europe
subnet: loony-custom-europe-west1-subnet
network service tier: Standard

# Click Create.


##############################
### Pinging using internal IP addresses


# SSH into both instances

# From loony-vm-asia-east1

ping <internal-ip-of-loony-vm-europe-west1>
# Should not work


# From loony-vm-asia-east1

ping <internal-ip-of-loony-vm-asia-east1>
# Should not work




############################################################
############################################################
### Set up network peering


# In VCP > VPC networks > VPC network peering

# Click Create connection > Continue

name: loony-peering-asia-europe
your vpc network: loony-custom-vpc-asia
peered vpc network: in project
vpc network name: loony-custom-vpc-europe


# Click on Create

# The peering connection is inactive as we have to set up a connection in the reverse direction as well


# Click Create connection > Continue

name: loony-peering-europe-asia
your vpc network: loony-custom-vpc-europe
peered vpc network: in project
vpc network name: oony-custom-vpc-asia


# Click on Create

# The peering connection is now active!

--------------------

# Back to the two terminals where we ping using the internal IP


# From loony-vm-asia-east1

ping <internal-ip-of-loony-vm-europe-west1>


# From loony-vm-asia-east1
ping <internal-ip-of-loony-vm-asia-east1>


# Both work!




























