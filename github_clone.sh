#!/bin/bash
# Script to create and download GitHub scripts and customize kali

dir=/root/github

mkdir -p $dir
cd $dir

git clone https://github.com/trustedsec/ptf.git
git clone https://github.com/jbarcia/nethunter.git
git clone https://github.com/jbarcia/Misc.git
# git clone https://github.com/jbarcia/g0tmi1k.git
git clone https://github.com/offensive-security/kali-linux-recipes.git
git clone https://github.com/mubix/8021xbridge.git
git clone https://github.com/jbarcia/ducky.git

# Crowe
git clone https://jbarcia@github.com/jbarcia/Crowe-Scripts.git
ln -s /root/github/Crowe-Scripts/toolslinux /
ln -s /root/github/Crowe-Scripts/toolsv3 /

# Recon
mkdir -p $dir/recon
cd $dir/recon
git clone https://github.com/jbarcia/Recon.git
git clone https://github.com/mubix/resolvequick.git
git clone https://github.com/jbarcia/User-Enumeration.git
git clone https://github.com/smicallef/spiderfoot.git

# Passwords
mkdir -p $dir/passwords
cd $dir/passwords
git clone https://github.com/byt3bl33d3r/pth-toolkit.git
git clone https://github.com/DanMcInerney/net-creds.git
git clone https://github.com/Neohapsis/creddump7.git
git clone https://github.com/RandomStorm/RSMangler.git
git clone https://github.com/brav0hax/easy-creds.git
git clone https://github.com/HarmJ0y/ImpDump.git

# IPv6
mkdir -p $dir/ipv6
cd $dir/ipv6
git clone https://github.com/fgont/ipv6toolkit.git
git clone https://github.com/Neohapsis/suddensix.git

# MiTM
mkdir -p $dir/mitm
cd $dir/mitm
git clone https://github.com/jbarcia/MiTM-CaptivePortal.git
git clone https://github.com/byt3bl33d3r/MITMf.git

# Wifi
mkdir -p $dir/wifi
cd $dir/wifi
git clone https://github.com/DanMcInerney/wifijammer.git
git clone https://github.com/sophron/wifiphisher.git
git clone https://github.com/derv82/wifite.git
git clone https://github.com/lostincynicism/FuzzAP.git
git clone https://github.com/SilverFoxx/PwnSTAR.git

# Web
mkdir -p $dir/web
cd $dir/web
git clone https://github.com/jbarcia/Web-Shells.git
git clone https://github.com/WestpointLtd/tls_prober.git
git clone https://github.com/sensepost/jack.git

# Shellcode
mkdir -p $dir/shellcode
cd $dir/shellcode
git clone https://github.com/addenial/ps1encode.git
git clone https://github.com/Veil-Framework/Veil.git

# Exploits
mkdir -p $dir/exploits
cd $dir/exploits
git clone https://github.com/bidord/pykek.git
git clone https://github.com/jbarcia/priv-escalation.git
git clone https://github.com/CoreSecurity/impacket.git
git clone https://github.com/CISOfy/lynis.git
git clone https://github.com/sensepost/BiLE-suite.git
git clone https://github.com/pwnwiki/pwnwiki-tools.git

# PostExploit
mkdir -p $dir/post
cd $dir/post
git clone https://github.com/ShawnDEvans/smbmap.git
git clone https://github.com/mubix/post-exploitation.git

# Wordlists
mkdir -p $dir/wordlists
cd $dir/wordlists
git clone https://github.com/danielmiessler/SecLists.git

# Metasploit Modules
mkdir -p $dir/metasploit
cd $dir/metasploit
git clone https://github.com/pwnwiki/q.git

# Meterpreter Shells
mkdir -p $dir/meterpreter
cd $dir/meterpreter
git clone https://github.com/kost/nanomet.git
git clone https://github.com/SherifEldeeb/TinyMet.git
git clone https://github.com/dirtyfilthy/metassh.git


# Spiderlabs
mkdir -p $dir/spiderlabs
cd $dir/spiderlabs
git clone https://github.com/SpiderLabs/Responder.git
git clone https://github.com/SpiderLabs/oracle_pwd_tools.git


# Trusted Sec
mkdir -p $dir/trustedsec
cd $dir/trustedsec
git clone https://github.com/jbarcia/TrustedSec.git
git clone https://github.com/trustedsec/unicorn.git
git clone https://github.com/trustedsec/egressbuster.git
git clone https://github.com/trustedsec/ridenum.git
git clone https://github.com/trustedsec/meterssh.git
git clone https://github.com/trustedsec/hash_parser.git


# Wikis
mkdir -p $dir/wiki
cd $dir/wiki
git clone https://github.com/pwnwiki/pwnwiki.github.io.git
git clone https://github.com/pwnwiki/msfwiki.git
git clone https://github.com/pwnwiki/webappurls.git
git clone https://github.com/pwnwiki/webappdefaultsdb.git
git clone https://github.com/pwnwiki/kaliwiki.git
git clone https://github.com/pwnwiki/dfirwiki.git
git clone https://github.com/pwnwiki/exploitdevwiki.git
git clone https://github.com/mubix/post-exploitation-wiki.git