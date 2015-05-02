#!/bin/bash

clear

if which gcc >/dev/null; then
echo "GCC Sudah Terinstall"
echo -n "Press Enter"
read press;

else
    echo "Gcc Belum Terinstall"
echo -n "Press Enter Untuk Install : "
read press;

i="gcc.sh"

cat >/gcc.sh<<EOF

#!/bin/bash
sudo apt-get install gcc

EOF

chmod +x /$i
/$i

rm -f /$i

fi

lagi='y'
while  [ $lagi = 'y' ] || [ $lagi = 'Y' ];
do
clear
echo "-=-=-=-=-=-=-=-=-=-=-=-=-=--=-=-=-=-=-=--=-=-=-=-=-=--=-=-=-=-=-=--=-=-=-=-=-=-\n"
echo " Masukan Nomor untuk INSTALLASI = "
echo "		- Pilih 1 Untuk instalasi PSYBNC		"
echo "		- Pilih 2 Untuk instalasi UnrealIRC + Anope "
echo "		- Pilih 0 Untuk Exit "
echo "								@ndesocode~"
echo ""
echo "-=-=-=-=-=-=-=-=-=-=-=-=-=--=-=-=-=-=-=--=-=-=-=-=-=--=-=-=-=-=-=--=-=-=-=-=-=-"
echo -n "Masukan angka > "
read pilih;

######################

if test $pilih = "1"
then

echo -n "Press ENTER untuk melanjutkan Instalasi : "
read masuk;

echo -n "Port PSYBNC nya:"
read port;

wget psybnc.at/download/beta/psyBNC-2.3.2-9.tar.gz
tar -xzf psyBNC-2.3.2-9.tar.gz
cd /home/$USER/psybnc/
make
./makesalt
mv salt.h ~

cd /home/$USER/psybnc/
mv psybnc.conf psybnc.confbek

cat >/home/$USER/psybnc/psybnc.conf<<EOF

PSYBNC.SYSTEM.PORT1=$port
PSYBNC.SYSTEM.HOST1=*
PSYBNC.HOSTALLOWS.ENTRY0=*;*

EOF

cd /home/$USER/psybnc/
./psybnc

echo "Selesai"

elif test $pilih = "2"
then

#############################

host=`ifconfig | grep 'inet addr:' | grep -v '127.0.0.1' | grep -v '127.0.0.2' | cut -d: -f2 | awk {'print $1'} | head -n 1`

echo -n "Press Enter untuk Melanjutkan Instalasi :"
read masuk;

echo "-= KONFIGURASI UNREAL =-"

echo -n "Nama IRC nya :"
read nameirc;

echo -n "User Admin nya :"
read admin;

echo -n "Password :"
read pass;

echo -n "Chanel Parkiran :"
read chan;

echo -n "Port untuk linking Anope :"
read ports;

echo -n "Port untuk konek Client"
read port;

echo "-= KONFIGURASI OPERATOR =-"

echo -n "Username untuk OPERATOR 1 :"
read oper1;

echo -n "Password :"
read pass1;

echo -n "Username untuk OPERATOR 2 :"
read oper2;

echo -n "Password :"
read pass2;

echo -n "Username untuk OPERATOR 3 :"
read oper3;

echo -n "Password :"
read pass3;



###

cd /home/$USER/
wget http://www.unrealircd.com/downloads/Unreal3.2.10.tar.gz
tar -xzf Unreal3.2.10.tar.gz
cd Unreal3.2.10
./Config
make && make install

###

cd /home/$USER/Unreal3.2.10/
mv unrealircd.conf unrealircd.confbekup
cat >/home/$USER/Unreal3.2.10/unrealircd.conf<<EOF

loadmodule "src/modules/commands.so";	
loadmodule "src/modules/cloak.so";
include "help.conf";
include "badwords.channel.conf";
include "badwords.message.conf";
include "badwords.quit.conf";
include "spamfilter.conf";
include "oper.conf";
include "connect.conf";

me
{
    name "irc.$nameirc.net";   
    info "- IRCD $nameircNETWORK ";   
    numeric 5;
};

admin {
    "Name  : $admin";
    "Nick  : $admin";
    "Email : $admin@bro.org";
};

class           clients
{
        pingfreq 180;
        maxclients 700;
        sendq 1000000;
        recvq 32000;
};

class           servers
{
        pingfreq 60;
        maxclients 100;
        sendq 99999999;
        connfreq 60;
};

allow {
        ip             *@*;
        hostname       *@*;
        class          clients;
	password "$pass";
        maxperip 50;
};

allow           channel {
    channel "#root";
};

listen  *:$ports
{
    options {
        serversonly;
    };
};
listen         *:$port
{
	options
	{
		clientsonly;
	};
};



ulines {
    services.$nameirc.net;
    stats.$nameirc.net;
};

drpass {
    restart "ulang";
    die "mampus";
};

log "ircd.log" {
    maxsize 2097152;
    flags {
        oper;
        kline;
        server-connects;
        kills;
        errors;
        sadmin-commands;
        chg-commands;
        oper-override;
        spamfilter;
    };
};

alias NickServ { type services; };
alias OperServ { type services; };
alias ChanServ { type services; };
alias HelpServ { type services; };
alias MemoServ { type services; };
alias HostServ { type services; };
alias BotServ { type services; };
alias StatServ { type stats; };

alias "identify" {
        format "^#" {
                nick "chanserv";
                type services;
                parameters "IDENTIFY %1-";
        };
        format "^[^#]" {
                nick "nickserv";
                type services;
                parameters "IDENTIFY %1-";
        };
        type command;

};

alias "services" {
        format "^#" {
                nick "chanserv";
                type services;
                parameters "%1-";
        };
        format "^[^#]" {
                nick "nickserv";
                type services;
                parameters "%1-";
        };
        type command;
};

alias "os" {
        format "^" {
                nick "operserv";
                type services;
                parameters "%1-";
        };
        type command;
};
alias "bs" {
        format "^" {
                nick "botserv";
                type services;
                parameters "%1-";
        };
        type command;
};
alias "cs" {
        format "^" {
                nick "chanserv";
                type services;
                parameters "%1-";
        };
        type command;
};
alias "hs" {
        format "^" {
                nick "hostserv";
                type services;
                parameters "%1-";
        };
        type command;
};
alias "ns" {
        format "^" {
                nick "nickserv";
                type services;
                parameters "%1-";
        };
        type command;
};
alias "ms" {
        format "^" {
                nick "memoserv";
                type services;
                parameters "%1-";
        };
        type command;
};

#tld {
#    mask *@*;
#    motd "ircd.motd";
#    rules "ircd.rules";
#};

ban nick {
    mask "*C*h*a*n*S*e*r*v*";
    reason "Reserved for Services";
};
ban ip {
    mask 195.86.232.81;
    reason "Delinked server";
};
ban server {
    mask eris.berkeley.edu;
    reason "Get out of here.";
};
ban user {
    mask *tirc@*.saturn.bbn.com;
        reason "Idiot";
};
ban realname {
    mask "Swat Team";
    reason "mIRKFORCE";
};
ban realname {
    mask "sub7server";
    reason "sub7";
};
except ban {
    /* don't ban stskeeps */
    mask           *stskeeps@212.*;
};
deny dcc {
    filename "*sub7*";
    reason "Possible Sub7 Virus";
};
deny channel {
    channel "*entot*";
    reason "BadChan!";
};

vhost {
    vhost           toe.roen.kan.sby.net;
    from {
        userhost       *;
    };
    login           cekidot;
    password        dotcomfull;
};
set { timesynch { enabled "yes"; server "irc.blackhat.us.to"; timeout "5";}; };
set {
    network-name         "$nameirc";
    default-server       "irc.$nameirc.net";
    services-server      "services.$nameirc.net";
    stats-server         "stats.$nameirc.net";
    help-channel         "#help";
    hiddenhost-prefix    "$nameirc";
    cloak-keys {
        "AHos2HOHS6Zs2ZsQQHGASish";
        "qF5D3ormaH6ZnXvbaH22wlfEhjf";
        "hfA6HwFh53XedOBQg9UfD";
    };
    hosts {
        local        	"Staff.$nameirc.net";
        global      	"Staff.$nameirc.net";
        coadmin         "Staff.$nameirc.net";
        admin           "Staff.$nameirc.net";
        servicesadmin   "Staff.$nameirc.net";
        netadmin        "Staff.$nameirc.net";
        host-on-oper-up "yes";
    };
};

set {
    kline-address "kline@$nameirc.net";
    modes-on-connect "+ixw";
        modes-on-oper    "+pTWvxwgs";
        oper-auto-join "#staff,#services,#help";
	auto-join "#$chan";
    dns {
        nameserver 127.0.0.1;
        timeout 2s;
        retries 2;
    };
    options {
        identd-check;
        hide-ulines;
        show-connect-info;
                flat-map;

    };

    maxchannelsperuser 3;
    anti-spam-quit-message-time 10s;
    static-quit "$nameircNETWORK Client quit";
    oper-only-stats "*";
    throttle {
        connections 3;
        period 60s;
    };

    anti-flood {
        nick-flood 3:60;
    };

    spamfilter {
        ban-time 1d;
        ban-reason "Spam/Advertising is not tolerated on $nameirc.net";
        virus-help-channel "#help";
        except "#services";
    };
};



EOF

###

cat >/home/$USER/Unreal3.2.10/oper.conf<<EOF

###admin###



oper $oper1 {

        class clients;

        from {

                userhost *@*;

        };

        password "$pass1";

        flags "oOCArRDhgwnGXcLkKbvCcQBzZtqHWdX";

        swhois "is -= Servers Administrator irc.$nameirc.net =-";

        maxlogins 2;

};



oper $oper2 {

        class clients;

        from {

                userhost *@*;

        };

        password "$pass2";

        flags "oOCrRDhgwnGXcLkKbvCcQBzZtqHWdX";

        swhois "is -= Co Administrator irc.$nameirc.net =-";

        maxlogins 2;

};



oper $oper3 {

        class           clients;

        from {

                userhost *@*;

        };

        password "$pass3";

        flags {

                      netadmin;

                      global;

                      coadmin;

                      admin;

                      services-admin;

                      can_rehash;

                      can_die;

                      can_restart;

                      can_wallops;

                      can_globops;

                      can_localroute;

                      can_globalroute;

                      can_localkill;

                      can_globalkill;

                      can_kline;

                      can_unkline;

                      can_localnotice;

                      can_globalnotice;

                      can_zline;

                      can_gkline;

                      can_gzline;

                      get_umodew;

                      get_host;

                      can_override;

                      can_setq;

                      can_addline;

                      can_dccdeny;          };

        swhois "is Root Administrator irc.$nameirc.net";

        snomask "cFfkejvGnNqs";

        maxlogins 1;

        modes +Kqpt;

};

EOF

###

cat >/home/$USER/Unreal3.2.10/connect.conf<<EOF

link services.$nameirc.net

        {

            username        *;

            hostname        $host;

            bind-ip         *;

            port            $ports;

            hub             *;

            password-connect "xpass123456x";

            password-receive "xpass123456x";

            class           servers;

        };

EOF

###
cd /home/$USER/Unreal3.2.10/
./unreal start

echo "Selesai"

clear

##################################

echo -n "Press Enter untuk melanjutkan Instalasi Anope : "
read enter;

wget http://shell.reverse.net/irc/ircd/Services/anope/anope-1.8.8.tar.gz
tar -xzf anope-1.8.8.tar.gz
cd anope-1.8.8
./Config
make && make install

###

cd ~/services/
cat >/home/$USER/services/services.conf<<EOF


# IRCDModule
# This is set to "unreal32" by default, if you're running unrealircd
# you don't need to change it. If you're running insp, change it to
# "inspircd20" - this assumes you're running inspircd 2.0.x which
# really you should be :P
IRCDModule "unreal32"

# RemoteServer
# Change 127.0.0.1 to the IP that your IRCd is running on.
# If you're using inspircd, change '6667' to your server bind port
# (starts with '<bind' - and has 'type="servers"' in it)
# Change mypass to the password in your services link block. (keep it inside "")

RemoteServer $host $ports "xpass123456x"

# LocalAddress
# Change 127.0.0.1 to the IP that your IRCd is running on.

LocalAddress $host

# ServerName and ServiceUser
# Change emtxio.net to your domain name (without the www. )
# An example would be : ServerName "services.dostiplus.com" and #ServiceUser "services@$nameirc.net"
ServerName "services.$nameirc.net"

ServiceUser "services@$nameirc.net"

# NetworkName
# Change LocalNet to your network name.
# An example would be : NetworkName "Dostiplus"
NetworkName "$nameirc"

# Numeric
# If you're using UnrealIRCd leave it alone.
# If you're using InspIRCd, change it to a digit, then either a digit or a capital letter, then another digit or capital letter.
# Examples for InspIRCd: Numeric "3AX" - Numeric "91A" - Numeric "5F8" - Numeric "729"
# You can make up your own, or use one of the examples if you don't understand.
Numeric "64"

# UserKey1 - UserKey2 - UserKey3
# Add random seven digit numbers on the end of 'UserKey1 ', 'UserKey2 ', and 'UserKey3 '.
# DO *NOT* TELL ANYONE THESE NUMBERS, KEEP THEM SECRET.
Use1rKey 
User2Key
UserK3ey 

# UlineServers
# If you install neostats, defender, janus, denora, omega, or anything else that needs to be ulined,
# add their server name in "" at the end here, and remove the # from the line below (THIS IS IMPORTANT)
#UlineServers 

# UseTS6
# If you're using UnrealIRCd, LEAVE THIS ALONE.
# If you're using InspIRCd, remove the # from the line below.
#UseTS6

# ServicesRoot
# Put the nicks of your services roots in here (the people who have the highest form of access on your net).
# This should contain your nick at least. Seperate nicks by spaces, and keep it all in "".
ServicesRoot "khalid"

# ModuleDelayedAutoLoad
# When installing new anope modules, put them here, seperate them by spaces, and keep it all in "".
ModuleDelayedAutoLoad ""

# Don't change anything below here, not unless you know what you're doing ;)
EncModule "enc_sha1"
HostCoreModules "hs_help hs_on hs_off hs_group hs_list hs_set hs_setall hs_del hs_delall hs_request"
MemoCoreModules "ms_send ms_cancel ms_list ms_read ms_del ms_set ms_info ms_rsend ms_check ms_staff ms_sendall ms_help"
HelpCoreModules "he_help"
BotCoreModules "bs_help bs_botlist bs_assign bs_set bs_kick bs_badwords bs_act bs_info bs_say bs_unassign bs_bot bs_fantasy bs_fantasy_kick bs_fantasy_kickban bs_fantasy_owner bs_fantasy_seen"
OperCoreModules "os_help os_global os_stats os_oper os_admin os_staff os_mode os_kick os_clearmodes os_akill os_sgline os_sqline os_szline os_chanlist os_userlist os_logonnews os_randomnews os_opernews os_session os_noop os_jupe os_ignore os_set os_reload os_update os_restart os_quit os_shutdown os_defcon os_chankill os_svsnick os_oline os_umode os_modload os_modunload os_modlist os_modinfo os_info"
NickCoreModules "ns_help ns_register ns_group ns_identify ns_access ns_set ns_saset ns_drop ns_recover ns_release ns_sendpass ns_ghost ns_alist ns_info ns_list ns_logout ns_status ns_update ns_getpass ns_getemail ns_forbid ns_suspend ns_maxemail"
ChanCoreModules "cs_help cs_register cs_identify cs_set cs_xop cs_access cs_akick cs_drop cs_sendpass cs_ban cs_clear cs_modes cs_getkey cs_invite cs_kick cs_list cs_logout cs_topic cs_info cs_getpass cs_forbid cs_suspend cs_status cs_appendtopic cs_enforce"
ServerDesc "Services Bots"
NickServName    "NickServ"  "Nickname Server"
ChanServName    "ChanServ"  "Channel Server"
MemoServName    "MemoServ"  "Memo Server"
BotServName     "BotServ"   "Bot Server"
HelpServName    "HelpServ"  "Help Server"
OperServName    "OperServ"  "Operator Server"
GlobalName      "Global"    "Global Noticer"
DevNullName     "DevNull"   "/dev/null -- message sink"
HostServName	"HostServ"  "vHost Server"
PIDFile     services.pid
MOTDFile    services.motd
NickServDB  nick.db
ChanServDB  chan.db
BotServDB   bot.db
OperServDB  oper.db
NewsDB      news.db
ExceptionDB exception.db
HostServDB  hosts.db
HelpChannel "#help"
LogChannel "#services"
LogBot
NickLen 31
StrictPasswords
BadPassLimit 5
BadPassTimeout 1h
UpdateTimeout   5m
ExpireTimeout   30m
ReadTimeout 5s
WarningTimeout  4h
TimeoutCheck    3s
KeepLogs 7
KeepBackups 3
ForceForbidReason
LogUsers
HideStatsO
GlobalOnCycle
GlobalOnCycleMessage "Services are restarting, they will be back shortly - please be good while we're gone"
GlobalOnCycleUP "Services are now back online - have a nice day"
UseSVSHOLD
RestrictOperNicks
UnRestrictSAdmin
NSForceEmail
NSDefSecure
NSDefPrivate
NSDefHideEmail
NSDefHideUsermask
NSDefMemoSignon
NSDefMemoReceive
NSDefAutoop
NSDefLanguage 1
NSRegDelay  30s
NSResendDelay  90s
NSExpire    21d
NSMaxAliases    16
NSAccessMax 32
NSEnforcerUser enforcer
NSReleaseTimeout 1m
NSListOpersOnly
NSListMax   50
NSGuestNickPrefix   "Guest"
NSSecureAdmins
NSStrictPrivileges
NSModeOnID
NSRestrictGetPass
CSDefKeepTopic
CSDefPeace
CSDefSecure
CSDefSecureFounder
CSDefSignKick
CSMaxReg    20
CSExpire    14d
CSDefBantype 3
CSAccessMax 1024
CSAutokickMax   32
CSAutokickReason "User has been banned from the channel"
CSInhabit   15s
CSListOpersOnly
CSListMax   50
CSRestrictGetPass
MSMaxMemos  20
MSSendDelay 3s
MSNotifyAll
BSDefGreet
BSDefFantasy
BSDefSymbiosis
BSMinUsers 1
BSBadWordsMax 32
BSKeepData 10m
BSGentleBWReason
SuperAdmin
LogMaxUsers
AutoKillExpiry  30d
ChanKillExpiry  30d
SGLineExpiry    30d
SQLineExpiry    30d
SZLineExpiry    30d
AkillOnAdd
KillOnSGline
KillOnSQline
DisableRaw
WallOper
WallBadOS
WallOSGlobal
WallOSMode
WallOSClearmodes
WallOSKick
WallOSAkill
WallOSSGLine
WallOSSQLine
WallOSSZLine
WallOSNoOp
WallOSJupe
WallOSRaw
WallAkillExpire
WallSGLineExpire
WallSQLineExpire
WallSZLineExpire
WallExceptionExpire
WallGetpass
WallSetpass
WallForbid
WallDrop
LimitSessions
DefSessionLimit 60
MaxSessionLimit 100
ExceptionExpiry 1d
SessionLimitExceeded "Your host %s has connected to this network more than 3 times."
MaxSessionKill 15
SessionAutoKillExpiry 30m
AddAkiller
OSOpersOnly
DefConLevel 5
DefCon4 23
DefCon3 31
DefCon2 159
DefCon1 415
DefConSessionLimit 2
DefConAkillExpire 5m
DefConChanModes "+RM"
DefConAkillReason "This network is currently not accepting connections, please try again later"
NSEmailMax 3
HSRequestMemoUser
HSRequestMemoOper
HSRequestMemoSetters

EOF

cd /home/$USER/services/
./anoperc

echo "Selese..."
#############################


elif test $pilih = "0"
then

echo -n "Press Enter untuk keluar"
read keluar;

echo " Bye.. Bye.. Bye.. "
exit

fi

echo
echo -n "Back to Menu? (y/n) :";
read lagi;
 
while  [ $lagi != 'y' ] && [ $lagi != 'Y' ] && [ $lagi != 'n' ] && [ $lagi != 'N' ];
do
echo -n "Back to menu (y/n) :";
read lagi;
done
 
done
