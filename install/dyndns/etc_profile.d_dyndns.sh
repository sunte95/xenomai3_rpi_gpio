network_prefix="131.174"

get_mac_for_interface() 
{
     ifconfig $1 | grep HWaddr | sed 's/.*HWaddr //'; 
}

get_ip_for_interface() 
{ 
     ifconfig $1 | grep 'inet addr:' | sed 's/.*inet addr://'| sed 's/ Bcast:.*//'; 
}


getipfrommac ()
{
    curl "http://www.cs.ru.nl/lab/dyndns/?mac=$1&cmdline=1" 2>/dev/null
}

# only allow setting ip within network which starts with network_prefix set
setmac2ip ()
{
    if [[ "$2" =~ ^$network_prefix ]]  
    then
         curl "http://www.cs.ru.nl/lab/dyndns/?mac=$1&ip=$2&cmdline=1" 2>/dev/null
    fi 
}



update_dyndns_for_interface() {
    interface=$1
    ip=$(get_ip_for_interface $interface)
    mac=$(get_mac_for_interface $interface)
    
    # notes: 
    # ip=$(hostname -I)  => displays all interfaces ip's
    # mac=$(cat /sys/class/net/eth0/address)  => nothing similar for mac
    
    #echo "dyndns: update interface $interface : $(setmac2ip $mac $ip )"
    setmac2ip $mac $ip >/dev/null 
    echo "interface:$interface mac:$mac ip:$ip"
}


# example 
# $ setmac2ip b8:27:eb:fc:c9:ca 131.174.142.31
# $ getipfrommac b8:27:eb:fc:c9:ca 
# 131.174.142.31
# $ update_dyndns
# $ getipfrommac b8:27:eb:fc:c9:ca 
# 131.174.142.175

echo ""
update_dyndns_for_interface "eth0 "  
update_dyndns_for_interface "wlan0" 

