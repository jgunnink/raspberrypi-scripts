PIHOLE_DIR=/etc/pihole
VPN_HOST=example.duckdns.org
PI_IP_ADDRESS=10.0.1.254/32
PI_IP_GATEWAY=10.0.1.1

mkdir -p $PIHOLE_DIR

# Create the setupVars pihole file needed for unattended install
cat <<EOF > $PIHOLE_DIR"/setupVars.conf"
WEBPASSWORD=b9c950640e1b3740e98acb93e669c65766f6670dd1609ba91ff41052ba48c6f3
BLOCKING_ENABLED=true
PIHOLE_INTERFACE=eth0
IPV4_ADDRESS=$PI_IP_ADDRESS
IPV6_ADDRESS=
QUERY_LOGGING=true
INSTALL_WEB_SERVER=true
INSTALL_WEB_INTERFACE=true
LIGHTTPD_ENABLED=true
CACHE_SIZE=10000
DNSMASQ_LISTENING=local
PIHOLE_DNS_1=9.9.9.11
DNS_FQDN_REQUIRED=true
DNS_BOGUS_PRIV=true
DNSSEC=false
REV_SERVER=false
EOF
echo $PIHOLE_DIR"/setupVars.conf"
echo "------------------------------"
cat $PIHOLE_DIR"/setupVars.conf"
echo "------------------------------"

echo "BEGINNING SETUP OF PIHOLE WITH ABOVE CONFIG"
echo "------------------------------"
curl -L https://install.pi-hole.net | bash /dev/stdin --unattended

echo "SETUP OF PIHOLE COMPLETE"
echo "------------------------------"

# Set the pivpn config
cat <<EOF > "pivpn_options.conf"
PLAT=Raspbian
OSCN=bullseye
USING_UFW=0
IPv4dev=eth0
IPv4addr=$PI_IP_ADDRESS
IPv4gw=$PI_IP_GATEWAY
install_user=pi
install_home=/home/pi
VPN=wireguard
pivpnPORT=51820
pivpnDNS1=10.6.0.1
pivpnDNS2=
pivpnHOST=$VPN_HOST
INPUT_CHAIN_EDITED=0
FORWARD_CHAIN_EDITED=0
pivpnPROTO=udp
pivpnMTU=1420
pivpnDEV=wg0
pivpnNET=10.6.0.0
subnetClass=24
ALLOWED_IPS="0.0.0.0/0, ::0/0"
UNATTUPG=1
INSTALLED_PACKAGES=(bsdmainutils iptables-persistent wireguard-tools qrencode unattended-upgrades)
EOF

echo "pivpn_options.conf"
echo "------------------------------"
cat "pivpn_options.conf"
echo "------------------------------"

echo "BEGINNING SETUP OF PIVPN WITH ABOVE CONFIG"
echo "------------------------------"
curl -L https://install.pivpn.io > install.sh
chmod +x install.sh
./install.sh --unattended pivpn_options.conf
echo "------------------------------"
echo "SETUP OF PIVPN COMPLETE"
echo "------------------------------"
