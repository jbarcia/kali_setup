#!/bin/bash
# Script to create and download GitHub scripts and customize kali

dir=/root/github
apt-get -f install

mkdir -p $dir
cd $dir

git clone https://github.com/trustedsec/ptf.git
git clone https://github.com/jbarcia/nethunter.git
git clone https://github.com/jbarcia/Misc.git
# git clone https://github.com/jbarcia/g0tmi1k.git
git clone https://github.com/offensive-security/kali-linux-recipes.git
git clone https://github.com/mubix/8021xbridge.git
git clone https://github.com/jbarcia/ducky.git
git clone https://github.com/pentestmonkey/yaptest.git


# Crowe
#git clone https://jbarcia@github.com/jbarcia/Crowe-Scripts.git
#ln -s /root/github/Crowe-Scripts/toolslinux /
#ln -s /root/github/Crowe-Scripts/toolsv3 /

# Recon
mkdir -p $dir/recon
cd $dir/recon
git clone https://github.com/jbarcia/recon.git
git clone https://github.com/mubix/resolvequick.git
# git clone https://github.com/jbarcia/User-Enumeration.git
git clone https://github.com/smicallef/spiderfoot.git
git clone https://github.com/pentestmonkey/timing-attack-checker.git
git clone https://github.com/pentestmonkey/dns-grind.git
git clone https://github.com/pentestmonkey/rsh-grind.git
git clone https://github.com/pentestmonkey/smtp-user-enum.git
git clone https://github.com/pentestmonkey/finger-user-enum.git
git clone https://github.com/pentestmonkey/ftp-user-enum.git
git clone https://github.com/pentestmonkey/ident-user-enum.git
git clone https://github.com/pentestmonkey/gateway-finder.git
git clone https://github.com/jwalker/SIRT.git
git clone https://github.com/leebaird/discover.git
	cd discover/
	./setup.sh
	ln -s /root/github/recon/discover /opt/
	cd ..
git clone https://bitbucket.org/LaNMaSteR53/peepingtom.git
	cd ./peepingtom/
	wget https://gist.github.com/nopslider/5984316/raw/423b02c53d225fe8dfb4e2df9a20bc800cc7
	wget https://phantomjs.googlecode.com/files/phantomjs1.9.2-linux-i686.tar.bz2
	tar xvjf phantomjs-1.9.2-linux-i686.tar.bz2
	cp ./phantomjs-1.9.2-linux-i686/bin/phantomjs
	cd ..
pip install selenium
git clone https://github.com/breenmachine/httpscreenshot.git
	cd ./httpscreenshot
	chmod +x install-dependencies.sh && ./install-dependencies.sh
	cd ..
git clone https://github.com/robertdavidgraham/masscan.git
	cd ./masscan
	make
	make install
	cd ..
git clone https://github.com/michenriksen/gitrob.git
	cd ./gitrob/bin
	gem install gitrob
	cd .. && cd ..
git clone https://github.com/ChrisTruncer/EyeWitness.git
git clone https://bitbucket.org/LaNMaSteR53/recon-ng.git
git clone https://github.com/secforce/sparta.git
mkdir ./spiderfoot/ && cd ./spiderfoot
	wget http://sourceforge.net/projects/spiderfoot/files/spiderfoot-2.3.0-src.tar.gz/download
	tar xzvf download
	pip install lxml
	pip install netaddr
	pip install M2Crypto
	pip install cherrypy
	pip install mako
	cd ..
apt-get -f install


# Passwords
mkdir -p $dir/passwords
cd $dir/passwords
git clone https://github.com/byt3bl33d3r/pth-toolkit.git
git clone https://github.com/DanMcInerney/net-creds.git
git clone https://github.com/Neohapsis/creddump7.git
git clone https://github.com/RandomStorm/RSMangler.git
git clone https://github.com/HarmJ0y/ImpDump.git
git clone https://github.com/SpiderLabs/oracle_pwd_tools.git
git clone https://github.com/DanMcInerney/net-creds.git
git clone https://github.com/SpiderLabs/Responder.git

# IPv6
mkdir -p $dir/ipv6
cd $dir/ipv6
git clone https://github.com/fgont/ipv6toolkit.git
git clone https://github.com/Neohapsis/suddensix.git
git clone https://github.com/vanhauser-thc/thc-ipv6.git

# MiTM
mkdir -p $dir/mitm
cd $dir/mitm
git clone https://github.com/jbarcia/MiTM-CaptivePortal.git
git clone https://github.com/byt3bl33d3r/MITMf.git
git clone https://github.com/brav0hax/easy-creds.git
git clone https://github.com/CylanceSPEAR/SMBTrap.git
git clone https://github.com/hatRiot/zarp.git
git clone https://github.com/evilsocket/bettercap
	cd bettercap
	gem build bettercap.gemspec
	sudo gem install bettercap*.gem
	cd ..
apt-get -f install

# Wifi
mkdir -p $dir/wifi
cd $dir/wifi
git clone https://github.com/DanMcInerney/wifijammer.git
git clone https://github.com/sophron/wifiphisher.git
git clone https://github.com/derv82/wifite.git
git clone https://github.com/lostincynicism/FuzzAP.git
git clone https://github.com/SilverFoxx/PwnSTAR.git
git clone https://github.com/TigerSecurity/gerix-wifi-cracker.git


# Web
mkdir -p $dir/web
cd $dir/web
git clone https://github.com/jbarcia/Web-Shells.git
git clone https://github.com/WestpointLtd/tls_prober.git
git clone https://github.com/sensepost/jack.git
git clone https://github.com/sqlmapproject/sqlmap.git
git clone https://github.com/tcstool/NoSQLMap.git
git clone https://github.com/Dionach/CMSmap
git clone https://github.com/wpscanteam/wpscan.git

# Shellcode
mkdir -p $dir/shellcode
cd $dir/shellcode
git clone https://github.com/addenial/ps1encode.git
git clone https://github.com/Veil-Framework/Veil.git
	cd Veil
	./Install.sh -c
	python update.py
	cd ..
git clone https://github.com/pentestmonkey/perl-reverse-shell.git
git clone https://github.com/pentestmonkey/php-reverse-shell.git
git clone https://github.com/pentestmonkey/php-findsock-shell.git
git clone https://github.com/secretsquirrel/the-backdoor-factory
	cd the-backdoor-factory
	./install.sh
	cd ..
apt-get -f install

# Exploits
mkdir -p $dir/exploits
cd $dir/exploits
git clone https://github.com/bidord/pykek.git
git clone https://github.com/jbarcia/priv-escalation.git
git clone https://github.com/CoreSecurity/impacket.git
git clone https://github.com/CISOfy/lynis.git
git clone https://github.com/sensepost/BiLE-suite.git
git clone https://github.com/pwnwiki/pwnwiki-tools.git
git clone https://github.com/pentestmonkey/windows-privesc-check.git
git clone https://github.com/pentestmonkey/unix-privesc-check.git
git clone https://github.com/pentestmonkey/exploit-suggester.git
git clone https://github.com/brav0hax/smbexec.git
	echo "Select 1 - Debian/Ubuntu, Select all defaults"
	cd ./smbexec && ./install.sh
#	echo "Select 4 to compile smbexec binaries, select 5 to exit"
#	./install.sh
	cd ..	
wget http://www.ampliasecurity.com/research/wce_v1_41beta_universal.zip
	unzip -d ./wce wce_v1_41beta_universal.zip
wget http://blog.gentilkiwi.com/downloads/mimikatz_trunk.zip
	unzip -d./mimikatz mimikatz_trunk.zip
git clone https://github.com/MooseDojo/praedasploit
apt-get -f install

# PostExploit
mkdir -p $dir/post
cd $dir/post
git clone https://github.com/ShawnDEvans/smbmap.git
git clone https://github.com/byt3bl33d3r/CrackMapExec.git
git clone https://github.com/T-S-A/smbspider.git
git clone https://github.com/mubix/post-exploitation.git
git clone https://github.com/pentestmonkey/pysecdump.git
git clone https://github.com/PoshSec/PoshSec.git
git clone https://github.com/PowerShellEmpire/Empire.git
	cd Empire
	cd setup
	./install.sh
	cd ..
git clone https://github.com/mattifestation/PowerSploit.git
git clone https://github.com/samratashok/nishang
	cd PowerSploit
	wget https://raw.github.com/obscuresec/random/master/StartListener.py
	wget https://raw.github.com/darkoperator/powershell_scripts/master/ps_encoder.py
	cd ..
cd ..
apt-get -f install

# Wordlists
mkdir -p $dir/wordlists
cd $dir/wordlists
git clone https://github.com/danielmiessler/SecLists.git

# Metasploit Modules
mkdir -p $dir/metasploit
cd $dir/metasploit
git clone https://github.com/pwnwiki/q.git
ln -s /root/github/Crowe-Scripts/metasploit_modules $dir/metasploit

# Meterpreter Shells
mkdir -p $dir/meterpreter
cd $dir/meterpreter
git clone https://github.com/kost/nanomet.git
git clone https://github.com/SherifEldeeb/TinyMet.git
git clone https://github.com/dirtyfilthy/metassh.git

# THP
# The Hacker Playbook 2 - Custom Scripts
mkdir -p $dir/THP
cd $dir/THP
git clone https://github.com/cheetz/Easy-P.git
git clone https://github.com/cheetz/Password_Plus_One
git clone https://github.com/cheetz/PowerShell_Popup
git clone https://github.com/cheetz/icmpshock
git clone https://github.com/cheetz/brutescrape
git clone https://www.github.com/cheetz/reddit_xss
git clone https://github.com/cheetz/PowerSploit
git clone https://github.com/cheetz/PowerTools
git clone https://github.com/cheetz/nishang



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