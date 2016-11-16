#!/bin/bash
# Script to create and download GitHub scripts and customize kali

dir=/root/github
apt-get -f install

read -r -p "Do you want to install Empire? [y/N] " response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
then
    cd /root/
    git clone https://github.com/PowerShellEmpire/Empire.git
	cd Empire
	cd setup
	./install.sh
#####################################################
fi

mkdir -p $dir
cd $dir

git clone https://github.com/trustedsec/ptf.git
git clone https://github.com/jbarcia/nethunter.git
git clone https://github.com/jbarcia/Misc.git
# git clone https://github.com/jbarcia/g0tmi1k.git
git clone https://github.com/offensive-security/kali-linux-recipes.git
git clone https://github.com/mubix/8021xbridge.git
git clone https://github.com/Warpnet/BitM.git
git clone https://github.com/pentestmonkey/yaptest.git
git clone https://jbarcia@github.com/CroweCybersecurity/pen-random-scripts.git
git clone https://github.com/rofl0r/proxychains-ng.git
git clone https://github.com/HackerFantastic/Public.git
git clone https://github.com/subTee/ApplicationWhitelistBypassTechniques.git
git clone https://github.com/adaptivethreat/BloodHound.git

# Crowe
git clone https://jbarcia@github.com/jbarcia/Crowe-Scripts.git

# Ducky
mkdir -p $dir/ducky
cd $dir/ducky
git clone https://github.com/jbarcia/ducky.git
git clone https://github.com/Plazmaz/Duckuino.git
git clone https://github.com/byt3bl33d3r/duckhunter.git

# Recon
mkdir -p $dir/recon
cd $dir/recon
git clone https://jbarcia@github.com/jbarcia/recon.git
git clone https://github.com/kostrin/Pillage.git
git clone https://github.com/jrozner/sonar.git
git clone https://github.com/mubix/resolvequick.git
# git clone https://github.com/jbarcia/User-Enumeration.git
git clone https://github.com/smicallef/spiderfoot.git
git clone https://github.com/FreedomCoder/esearchy_mirai.git
git clone https://gist.github.com/041641b6896779ebb77e04a578001c28.git
git clone https://gist.github.com/8825b88f7c266b605c0973b1664898bf.git
git clone https://github.com/Pickfordmatt/Prowl.git
git clone https://github.com/elceef/dnstwist.git
git clone https://github.com/nccgroup/typofinder.git
git clone https://github.com/secworld/Breach-Miner.git
	cd Breach-Miner
	chmod +x requirements.sh
	./requirements.sh
cd ..
git clone https://github.com/michenriksen/hibp.git
git clone https://github.com/WestpointLtd/tls_prober.git
git clone https://github.com/leebaird/discover.git

read -r -p "Do you want to configure Discover? [y/N] " response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
then
	ln -s /root/github/recon/discover /opt/
    cd discover/
	./setup.sh
	cd ..
fi

git clone https://bitbucket.org/LaNMaSteR53/peepingtom.git
read -r -p "Do you want to configure Peepingtom? [y/N] " response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
then
	cd ./peepingtom/
	wget https://gist.github.com/nopslider/5984316/raw/423b02c53d225fe8dfb4e2df9a20bc800cc7
	wget https://phantomjs.googlecode.com/files/phantomjs1.9.2-linux-i686.tar.bz2
	tar xvjf phantomjs-1.9.2-linux-i686.tar.bz2
	cp ./phantomjs-1.9.2-linux-i686/bin/phantomjs
	cd ..
fi

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

read -r -p "Do you want to configure Gitrob? [y/N] " response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
then
	cd ./gitrob

	gem update --system
	apt-get install libpq-dev 
	/etc/init.d/postgresql start

	sudo su postgres
	createuser -s gitrob --pwprompt
	createdb -O gitrob gitrob

	gem uninstall github_api
	gem install github_api -v 0.13
	gem install gitrob

	gitrob configure

    cd ..
fi

git clone https://github.com/ChrisTruncer/EyeWitness.git
read -r -p "Do you want to configure Eyewitness? [y/N] " response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
then
	cd ./EyeWitness/setup
	./setup.sh
fi

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

# Assessment
mkdir -p $dir/assessment
cd $dir/assessment
git clone https://github.com/quentinhardy/odat.git
git clone https://github.com/pentestmonkey/timing-attack-checker.git
git clone https://github.com/pentestmonkey/dns-grind.git
git clone https://github.com/pentestmonkey/rsh-grind.git
git clone https://github.com/pentestmonkey/smtp-user-enum.git
git clone https://github.com/pentestmonkey/finger-user-enum.git
git clone https://github.com/pentestmonkey/ftp-user-enum.git
git clone https://github.com/pentestmonkey/ident-user-enum.git
git clone https://github.com/pentestmonkey/gateway-finder.git
git clone https://github.com/jwalker/SIRT.git
git clone https://jbarcia@github.com/CroweCybersecurity/go-sshscan.git
git clone https://github.com/1N3/Sn1per.git
git clone https://github.com/rapid7/ssh-badkeys.git
git clone https://github.com/BenBE/kompromat.git

# Passwords
mkdir -p $dir/passwords
cd $dir/passwords
git clone https://github.com/byt3bl33d3r/pth-toolkit.git
git clone https://github.com/DanMcInerney/net-creds.git
git clone https://github.com/Neohapsis/creddump7.git
git clone https://github.com/RandomStorm/RSMangler.git
git clone https://github.com/zeroskill/transmute.git
git clone https://github.com/HarmJ0y/ImpDump.git
git clone https://github.com/SpiderLabs/oracle_pwd_tools.git
git clone https://github.com/SpiderLabs/Responder.git
git clone https://github.com/urbanesec/ZackAttack.git
git clone https://github.com/lanjelot/patator.git
git clone https://github.com/1N3/BruteX.git
cp /root/github/passwords/Sn1per/BruteX/wordlists/* $dir/wordlists

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
git clone https://github.com/purpleteam/snarf.git
git clone https://github.com/byt3bl33d3r/MITMf.git
git clone https://github.com/brav0hax/easy-creds.git
git clone https://github.com/CylanceSPEAR/SMBTrap.git
git clone https://github.com/GDSSecurity/BadSamba.git
git clone https://github.com/hatRiot/zarp.git
git clone https://github.com/citronneur/rdpy.git
git clone https://github.com/ElevenPaths/EvilFOCA.git
git clone https://github.com/infobyte/evilgrade.git
git clone https://github.com/evilsocket/bettercap-proxy-modules.git
git clone https://github.com/evilsocket/bettercap.git
	cd bettercap
	gem build bettercap.gemspec
	sudo gem install bettercap*.gem
	cd ..
apt-get -f install


# mobile
mkdir -p $dir/mobile
mkdir -p $dir/mobile/Android
cd $dir/mobile/Android
git clone https://github.com/iSECPartners/Android-SSL-TrustKiller.git
git clone https://github.com/mwrlabs/drozer.git
read -r -p "Do you want to install Drozer? [y/N] " response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
then
	cd drozer
	python setup.py build
	python setup.py install
	cd ..
fi
git clone https://github.com/mwrlabs/drozer-modules.git


# Wifi
mkdir -p $dir/wifi
cd $dir/wifi
git clone https://github.com/DanMcInerney/wifijammer.git
git clone https://github.com/sophron/wifiphisher.git
git clone https://github.com/derv82/wifite.git
git clone https://github.com/lostincynicism/FuzzAP.git
git clone https://github.com/SilverFoxx/PwnSTAR.git
git clone https://github.com/TigerSecurity/gerix-wifi-cracker.git
git clone https://github.com/lostincynicism/FuzzAP.git
git clone https://github.com/P0cL4bs/WiFi-Pumpkin.git


# Web
mkdir -p $dir/web
cd $dir/web
git clone https://github.com/sensepost/jack.git
git clone https://github.com/sqlmapproject/sqlmap.git
git clone https://github.com/decal/pafogenz.git
git clone https://github.com/tcstool/NoSQLMap.git
git clone https://github.com/torque59/Nosql-Exploitation-Framework.git
git clone https://github.com/Netflix/sleepy-puppy.git
git clone https://github.com/Dionach/CMSmap.git
git clone https://github.com/wpscanteam/wpscan.git
git clone https://github.com/1N3/XSSTracer.git
git clone https://github.com/shawarkhanethicalhacker/BruteXSS.git
git clone https://github.com/portcullislabs/xssshell-xsstunnell.git
git clone https://github.com/beefproject/beef.git
git clone https://github.com/CookieCadger/CookieCadger.git
git clone https://github.com/ptigas/simple-captcha-solver.git
git clone https://github.com/1N3/Wordpress-XMLRPC-Brute-Force-Exploit.git
git clone https://github.com/droope/droopescan.git
git clone https://github.com/R3dy/parse-burp.git
git clone https://github.com/AlisamTechnology/ATSCAN.git
git clone https://github.com/joaomatosf/jexboss.git
git clone https://github.com/foospidy/payloads.git
git clone https://github.com/thezawad/rev-door.git
git clone https://github.com/0xsauby/yasuo.git

# Shellcode
mkdir -p $dir/shellcode
cd $dir/shellcode
git clone https://github.com/addenial/ps1encode.git
git clone https://github.com/adaptivethreat/EmPyre.git
git clone https://github.com/Veil-Framework/Veil.git
read -r -p "Do you want to configure Veil? [y/N] " response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
then
	cd Veil
	./Install.sh -c
	python update.py
	cd ..
fi

git clone https://github.com/jbarcia/Web-Shells.git
git clone https://github.com/tennc/webshell.git
git clone https://github.com/g0tmi1k/exe2hex.git
git clone https://github.com/subTee/SCTPersistence.git
git clone https://github.com/pentestmonkey/perl-reverse-shell.git
git clone https://github.com/g0tmi1k/mpc.git
git clone https://github.com/pentestmonkey/php-reverse-shell.git
git clone https://github.com/pentestmonkey/php-findsock-shell.git
git clone https://github.com/inquisb/icmpsh.git 
git clone https://github.com/Maksadbek/tcpovericmp.git
git clone https://github.com/iagox86/dnscat2.git
git clone https://github.com/epinna/weevely3.git
git clone https://github.com/DhavalKapil/icmptunnel.git
git clone https://github.com/n1nj4sec/pupy.git
ln -s /root/github/Crowe-Scripts/DNSEncode $dir/shellcode/
git clone https://github.com/secretsquirrel/the-backdoor-factory.git
read -r -p "Do you want to install TBF? [y/N] " response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
then
	cd the-backdoor-factory
	./install.sh
	cd ..
fi

apt-get -f install

# Exfiltration
mkdir -p $dir/Exfiltration
cd $dir/Exfiltration
git clone https://github.com/3nc0d3r/NaishoDeNusumu.git
git clone https://github.com/m57/dnsteal.git
git clone https://github.com/ytisf/PyExfil.git
git clone https://github.com/radman404/DNSSUB.git
git clone https://github.com/infodox/tsh-sctp.git
git clone https://github.com/nccgroup/holepuncher.git

# Exploits
mkdir -p $dir/exploits
cd $dir/exploits
git clone https://github.com/breenmachine/Potato.git
git clone https://github.com/3gstudent/Javascript-Backdoor
git clone https://github.com/bidord/pykek.git
git clone https://github.com/CoreSecurity/impacket.git
git clone https://github.com/sensepost/BiLE-suite.git
git clone https://github.com/pwnwiki/pwnwiki-tools.git
git clone https://github.com/stasinopoulos/commix.git
git clone https://github.com/brav0hax/smbexec.git
read -r -p "Do you want to configure SMBexec? [y/N] " response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
then
	echo "Select 1 - Debian/Ubuntu, Select all defaults"
	cd ./smbexec && ./install.sh
#	echo "Select 4 to compile smbexec binaries, select 5 to exit"
#	./install.sh
	cd ..	
fi

wget http://www.ampliasecurity.com/research/wce_v1_41beta_universal.zip
	unzip -d ./wce wce_v1_41beta_universal.zip
wget http://blog.gentilkiwi.com/downloads/mimikatz_trunk.zip
	unzip -d./mimikatz mimikatz_trunk.zip
git clone https://github.com/MooseDojo/praedasploit
apt-get -f install

# Powershell
mkdir -p $dir/powershell
cd $dir/powershell
mkdir crowe
ln -s /root/github/Crowe-Scripts/WindowsPowerShell/Modules/* $dir/powershell/crowe
git clone https://github.com/kfosaaen/Get-LAPSPasswords.git
git clone https://github.com/Kevin-Robertson/Tater.git
git clone https://github.com/putterpanda/mimikittenz.git
git clone https://github.com/lgandx/Responder-Windows.git
git clone https://github.com/nettitude/PoshC2.git
git clone https://github.com/breakersall/PowershellScripts.git
git clone https://github.com/FuzzySecurity/PowerShell-Suite.git
git clone https://github.com/Ben0xA/nps.git
git clone https://github.com/NetSPI/PowerUpSQL.git
git clone https://github.com/Cn33liz/p0wnedShell.git
git clone https://github.com/PowerShellMafia/PowerSploit.git
git clone https://github.com/fdiskyou/PowerOPS.git
git clone https://github.com/chango77747/AdEnumerator.git
git clone https://github.com/rvrsh3ll/Misc-Powershell-Scripts.git
git clone https://github.com/PyroTek3/PowerShell-AD-Recon.git
git clone https://github.com/Kevin-Robertson/Inveigh.git
git clone https://github.com/samratashok/nishang.git
git clone https://github.com/PowerShellEmpire/PowerTools.git
git clone https://github.com/darkoperator/Posh-NVS.git
git clone https://github.com/darkoperator/Posh-SecMod.git
git clone https://github.com/darkoperator/Posh-Shodan.git
git clone https://github.com/PoshSec/PoshSec.git
git clone https://github.com/besimorhino/powercat.git
git clone https://github.com/mattifestation/PowerSploit.git
git clone https://github.com/NetSPI/PS_MultiCrack.git
git clone https://github.com/NetSPI/Powershell-Modules.git
git clone https://github.com/NetSPI/PowerShell.git
git clone https://github.com/psget/psget.git
git clone https://github.com/NytroRST/NetRipper.git
git clone https://github.com/HarmJ0y/Misc-PowerShell.git
git clone https://github.com/nullbind/Powershellery.git
git clone https://github.com/enigma0x3/Invoke-AltDSBackdoor.git
git clone https://github.com/enigma0x3/Generate-Macro.git
git clone https://github.com/secabstraction/WmiSploit.git
git clone https://github.com/jseidl/Babadook.git
	wget https://raw.github.com/obscuresec/random/master/StartListener.py
	wget https://raw.github.com/darkoperator/powershell_scripts/master/ps_encoder.py
#ln -s /root/github/powershell /var/www/1
ln -s /root/github/Crowe-Scripts/pen-powerpen $dir/powershell/
ln -s /root/github/powershell /var/www/html/1
ln -s /root/github/powershell /usr/share/mana-toolkit/www/portal/1

# PostExploit
mkdir -p $dir/post
cd $dir/post
mkdir -p $dir/post/linux/enum
mkdir -p $dir/post/win/enum
mkdir -p $dir/post/osx/enum
mkdir -p $dir/post/solaris/enum
mkdir -p $dir/post/databases
mkdir -p $dir/post/smb
#git clone https://github.com/jbarcia/priv-escalation.git
cd  $dir/post/linux/enum
git clone https://github.com/CISOfy/lynis.git
git clone https://github.com/pentestmonkey/unix-privesc-check.git
git clone https://github.com/rebootuser/LinEnum.git
git clone https://github.com/raffaele-forte/climber.git
cd $dir/post/osx/enum
git clone https://github.com/Yelp/osxcollector.git
cd $dir/post/win/enum
git clone https://github.com/Raikia/SMBCrunch.git
git clone https://github.com/pentestmonkey/windows-privesc-check.git
git clone https://github.com/GDSSecurity/Windows-Exploit-Suggester.git
git clone https://github.com/enjoiz/Privesc.git
git clone https://jbarcia@github.com/CroweCybersecurity/ad-ldap-enum.git
cd $dir/post/solaris/enum
git clone https://github.com/pentestmonkey/exploit-suggester.git
cd $dir/post/win
git clone https://github.com/putterpanda/mimikittenz.git
git clone https://github.com/Kevin-Robertson/Tater.git
git clone https://github.com/hfiref0x/UACME.git
git clone https://github.com/pentestmonkey/pysecdump.git
git clone https://github.com/trustedsec/spraywmi.git
git clone https://github.com/lgandx/Responder-Windows.git
git clone https://github.com/realalexandergeorgiev/tempracer.git
wget https://github.com/realalexandergeorgiev/tempracer/releases/download/1/TempRacer.exe
cd $dir/post/databases
git clone https://github.com/foospidy/DbDat.git
cd $dir/post/smb
git clone https://github.com/ShawnDEvans/smbmap.git
git clone https://jbarcia@github.com/CroweCybersecurity/shareenum.git
git clone https://github.com/byt3bl33d3r/CrackMapExec.git
git clone https://github.com/T-S-A/smbspider.git
cd $dir/post
git clone https://github.com/mubix/post-exploitation.git
cd ..
apt-get -f install

# Wordlists
mkdir -p $dir/wordlists
cd $dir/wordlists
git clone https://github.com/danielmiessler/SecLists.git
git clone https://github.com/danielmiessler/RobotsDisallowed.git
git clone https://github.com/pwnwiki/webappurls.git
git clone https://github.com/fuzzdb-project/fuzzdb.git
cp /root/github/passwords/Sn1per/BruteX/wordlists/* $dir/wordlists


# Metasploit Modules
mkdir -p $dir/metasploit
cd $dir/metasploit
git clone https://github.com/pwnwiki/q.git
git clone https://github.com/khr0x40sh/metasploit-modules.git

ln -s /root/github/Crowe-Scripts/metasploit_modules $dir/metasploit/
ln -s /root/github/Crowe-Scripts/pen-metasploit $dir/metasploit/
ln -s $dir/powershell/NetRipper/Metasploit/ $dir/metasploit/NetRipper/

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
git clone https://github.com/cheetz/Password_Plus_One.git
git clone https://github.com/cheetz/PowerShell_Popup.git
git clone https://github.com/cheetz/icmpshock.git
git clone https://github.com/cheetz/brutescrape.git
git clone https://www.github.com/cheetz/reddit_xss.git
git clone https://github.com/cheetz/PowerSploit.git
git clone https://github.com/cheetz/PowerTools.git
git clone https://github.com/cheetz/nishang.git

# Forensics
mkdir -p $dir/Forensics
cd $dir/Forensics
git clone https://github.com/hiddenillusion/AnalyzePDF.git

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
git clone https://github.com/drduh/OS-X-Security-and-Privacy-Guide.git
git clone https://github.com/herrbischoff/awesome-osx-command-line.git


# Physical Security
mkdir -p $dir/physical
cd $dir/physical
#git clone https://jbarcia@github.com/CroweCybersecurity/ravenhid.git
git clone https://github.com/CroweCybersecurity/ravenhid.git
