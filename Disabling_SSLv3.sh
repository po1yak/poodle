#/bin/bash
#
# denis.shkadov@ecommerce.com
#
# Action Disable Support for SSLv3 on a cPanel on target VM.


case "${1}" in
        outputFormat)
                echo "Status"
        ;;
        *)
        status=$(ssh -q -o ConnectTimeout=20 -o StrictHostKeyChecking=no ${1} "cat /var/cpanel/conf/apache/local")
	if [ ! -f "/var/cpanel/conf/apache/local" ]
	then 
		file=$(ssh -q -o ConnectTimeout=20 -o StrictHostKeyChecking=no ${1} "touch /var/cpanel/conf/apache/local && echo "SSLProtocol All -SSLv2 -SSLv3" > /var/cpanel/conf/apache/local ") 
		output=$(echo "")
	else
		entry=$(ssh -q -o ConnectTimeOut=20 -o StrictHostKeyChecking=no ${1} "grep -i "SSLProtocol all.*" /var/cpanel/conf/apache/local")
		if [ "x${entry}" = "x" ]
		then 
		change=$(ssh -q -o ConnectTimeOut=20 -o StrictHostKeyChecking=no ${1} "sed -i 's/SSLProtocol all.*/SSLProtocol All -SSLv2 -SSLv3/' /var/cpanel/conf/apache/local")
		output=$(echo "")
		fi
 	fi
	service=$(ssh -q -o ConnectTimeOut=20 -o StrictHostKeyChecking=no ${1} "/scripts/rebuildhttpdconf && service httpd restart")
	;;
esac

case "${2}" in
        outputFormat)
                echo "Status1"
        ;;
        *)
        status=$(ssh -q -o ConnectTimeout=20 -o StrictHostKeyChecking=no ${2} "cat /var/cpanel/conf/cpsrvd/ssl_socket_args")
                entry=$(ssh -q -o ConnectTimeOut=20 -o StrictHostKeyChecking=no ${2} "grep -i "SSL_version *" /var/cpanel/conf/cpsrvd/ssl_socket_args")
                if [ "x${entry}" != "SSL_version SSLv23:!SSLv2:!SSLv3" ]
                then
                change=$(ssh -q -o ConnectTimeOut=20 -o StrictHostKeyChecking=no ${2} "sed -i 's/SSL_version */SSL_version SSLv23:!SSLv2:!SSLv3/' /var/cpanel/conf/cpsrvd/ssl_socket_args")
                output=$(echo "")
                fi
        service=$(ssh -q -o ConnectTimeOut=20 -o StrictHostKeyChecking=no ${2} "/usr/local/cpanel/whostmgr/bin/whostmgr2 docpsrvdconfiguration")
        ;;
esac


echo "${outPut}"

exit 0

