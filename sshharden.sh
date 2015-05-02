#!/bin/bash


if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use root to install this script"
    exit 0
fi
clear

echo "================================================================================"
echo "      	               SSH AUTO HARDENING FOR UBUNTU"            
echo "================================================================================"
echo "                        ndesocode@gmail.com & www.ndeso.us"
echo "                          For more information contact me"
echo "================================================================================"


#myip
ip=`ifconfig | grep 'inet addr:' | grep -v '127.0.0.1' | grep -v '127.0.0.2' | cut -d: -f2 | awk {'print $1'} | head -n 1`

#Useradd & Groupadd
echo -n "Group Name :"
read group;
groupadd $group

echo -n "User Name :"
read username;
useradd -s /bin/bash -d /home/$username -g $group -G root -m $username

echo " Type Your Password below !"
passwd $username

#SettingSudoers
cp /etc/sudoers /etc/sudoers.bekup
cat >/etc/sudoers<<EOF

Defaults	env_reset
Defaults	secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# User privilege specification
root	ALL=(ALL:ALL) ALL
$username	ALL=(ALL:ALL) ALL

# Members of the admin group may gain root privileges
%admin ALL=(ALL) ALL

# Allow members of group sudo to execute any command
%sudo	ALL=(ALL:ALL) ALL

#includedir /etc/sudoers.d

EOF

#sshd_config configuration
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bekup
echo -n "Portnya Berapa :"
read port;

cat >/etc/ssh/sshd_config<<EOF
# Package generated configuration file
# See the sshd_config(5) manpage for details

# What ports, IPs and protocols we listen for
Port $port
# Use these options to restrict which interfaces/protocols sshd will bind to
#ListenAddress ::
#ListenAddress 0.0.0.0
Protocol 2
# HostKeys for protocol version 2
HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_dsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key
#Privilege Separation is turned on for security
UsePrivilegeSeparation yes

# Lifetime and size of ephemeral version 1 server key
KeyRegenerationInterval 3600
ServerKeyBits 768

# Logging
SyslogFacility AUTH
LogLevel INFO

# Authentication:
LoginGraceTime 120
PermitRootLogin no
AllowUsers $username
StrictModes yes

RSAAuthentication yes
PubkeyAuthentication yes
#AuthorizedKeysFile	%h/.ssh/authorized_keys

# Don't read the user's ~/.rhosts and ~/.shosts files
IgnoreRhosts yes
# For this to work you will also need host keys in /etc/ssh_known_hosts
RhostsRSAAuthentication no
# similar for protocol version 2
HostbasedAuthentication no
# Uncomment if you don't trust ~/.ssh/known_hosts for RhostsRSAAuthentication
#IgnoreUserKnownHosts yes

# To enable empty passwords, change to yes (NOT RECOMMENDED)
PermitEmptyPasswords no

# Change to yes to enable challenge-response passwords (beware issues with
# some PAM modules and threads)
ChallengeResponseAuthentication no

# Change to no to disable tunnelled clear text passwords
#PasswordAuthentication yes

# Kerberos options
#KerberosAuthentication no
#KerberosGetAFSToken no
#KerberosOrLocalPasswd yes
#KerberosTicketCleanup yes

# GSSAPI options
#GSSAPIAuthentication no
#GSSAPICleanupCredentials yes

X11Forwarding yes
X11DisplayOffset 10
PrintMotd no
PrintLastLog yes
TCPKeepAlive yes
#UseLogin no

#MaxStartups 10:30:60
#Banner /etc/issue.net

# Allow client to pass locale environment variables
AcceptEnv LANG LC_*

Subsystem sftp /usr/lib/openssh/sftp-server

# Set this to 'yes' to enable PAM authentication, account processing,
# and session processing. If this is enabled, PAM authentication will
# be allowed through the ChallengeResponseAuthentication and
# PasswordAuthentication.  Depending on your PAM configuration,
# PAM authentication via ChallengeResponseAuthentication may bypass
# the setting of "PermitRootLogin without-password".
# If you just want the PAM account and session checks to run without
# PAM authentication, then enable this but set PasswordAuthentication
# and ChallengeResponseAuthentication to 'no'.
UsePAM yes
EOF

#iptables configuration
iptables -A INPUT -p tcp --dport $port -j ACCEPT
iptables-save > /dev/null

#restart SSH
/etc/init.d/ssh restart > /dev/null

echo "Groupname $group"
echo "Username $username"
echo "Password ********"
echo "$username was on sudoers"
echo "root login Disabled"
echo "Port changed to : $port"

echo "All Successfully and try connect : ssh $username@$ip -p $port"
