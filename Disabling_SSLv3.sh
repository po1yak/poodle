#/bin/bash
#
# denis.shkadov@ecommerce.com
#
# Action Disable Support for SSLv3 on a cPanel on target VM.


case "${1}" in
        outputFormat)
                echo "HTTPS|cPanel SSL|IMAP4 SSL|FTP SSL|"
        ;;
        *)

        status=$(ssh -q -o ConnectTimeout=20 -o StrictHostKeyChecking=no ${1} "cat /var/cpanel/conf/apache/local")
	if [ ! -f "/var/cpanel/conf/apache/local" ]
	then 
		file=$(ssh -q -o ConnectTimeout=20 -o StrictHostKeyChecking=no ${1} "touch /var/cpanel/conf/apache/local && echo "SSLProtocol All -SSLv2 -SSLv3" > /var/cpanel/conf/apache/local ") 
		output=$(echo "Created")
	else
		entry=$(ssh -q -o ConnectTimeOut=20 -o StrictHostKeyChecking=no ${1} "grep -i "SSLProtocol all.*" /var/cpanel/conf/apache/local")
		if [ "x${entry}" = "x" ]
		then 
		change=$(ssh -q -o ConnectTimeOut=20 -o StrictHostKeyChecking=no ${1} "sed -i 's/SSLProtocol all.*/SSLProtocol All -SSLv2 -SSLv3/' /var/cpanel/conf/apache/local")
		output=$(echo "Changed")
		fi
 	fi
	service=$(ssh -q -o ConnectTimeOut=20 -o StrictHostKeyChecking=no ${1} "/scripts/rebuildhttpdconf && service httpd restart")


        status=$(ssh -q -o ConnectTimeout=20 -o StrictHostKeyChecking=no ${1} "cat /var/cpanel/conf/cpsrvd/ssl_socket_args")
                entry=$(ssh -q -o ConnectTimeOut=20 -o StrictHostKeyChecking=no ${1} "grep -i "SSL_version *" /var/cpanel/conf/cpsrvd/ssl_socket_args")
                if [ "x${entry}" != "SSL_version SSLv23:!SSLv2:!SSLv3" ]
                then
                change=$(ssh -q -o ConnectTimeOut=20 -o StrictHostKeyChecking=no ${1} "sed -i 's/SSL_version */SSL_version SSLv23:!SSLv2:!SSLv3/' /var/cpanel/conf/cpsrvd/ssl_socket_args")
                output=$(echo "Changed")
                fi
        service=$(ssh -q -o ConnectTimeOut=20 -o StrictHostKeyChecking=no ${1} "/usr/local/cpanel/whostmgr/bin/whostmgr2 docpsrvdconfiguration")


        status=$(ssh -q -o ConnectTimeout=20 -o StrictHostKeyChecking=no ${1} "cat /var/cpanel/conf/dovecot/main")
                entry=$(ssh -q -o ConnectTimeOut=20 -o StrictHostKeyChecking=no ${1} "grep -i "SSL_protocol *" /var/cpanel/conf/dovecot/main")
                if [ "x${entry}" != "SSL_protocol !SSLv2 !SSLv3" ]
                then
                change=$(ssh -q -o ConnectTimeOut=20 -o StrictHostKeyChecking=no ${1} "sed -i 's/SSL_protocol */SSL_protocol !SSLv2 !SSLv3/' /var/cpanel/conf/dovecot/main")
                output=$(echo "Changed")
                fi
        service=$(ssh -q -o ConnectTimeOut=20 -o StrictHostKeyChecking=no ${1} "/usr/local/cpanel/whostmgr/bin/whostmgr2 savedovecotsetup")


	status=$(ssh -q -o ConnectTimeout=20 -o StrictHostKeyChecking=no ${1} "cat /var/cpanel/pureftpd/main")
                entry=$(ssh -q -o ConnectTimeOut=20 -o StrictHostKeyChecking=no ${1} "grep -i "TLSCipherSuite" /var/cpanel/conf/pureftpd/main")
                if [ "x${entry}" != "HIGH:MEDIUM:+TLSv1:!SSLv2:!SSLv3" ]
                then
                change=$(ssh -q -o ConnectTimeOut=20 -o StrictHostKeyChecking=no ${1} "sed -i 's/TLSCipherSuite */TLSCipherSuite  HIGH:MEDIUM:+TLSv1:!SSLv2:!SSLv3/' /var/cpanel/conf/pureftpd/main")
                output=$(echo "Changed")
                fi
        service=$(ssh -q -o ConnectTimeOut=20 -o StrictHostKeyChecking=no ${1} "/usr/local/cpanel/bin/build_ftp_conf && service pure-ftpd restart")

        ;;
esac

echo "${outPut}"

exit 0

