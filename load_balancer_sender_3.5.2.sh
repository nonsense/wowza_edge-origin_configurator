#!/bin/bash
#
# Configuration for EDGE server on a multiple configuration streaming

echo -e "Setting up sender for origin $1 and edge $2 \n"

cd /usr/local/WowzaMediaServer/conf

sed -i "30a\
<ServerListener> \
	<BaseClass>com.wowza.wms.plugin.loadbalancer.ServerListenerLoadBalancerSender<\/BaseClass> \
</ServerListener>" Server.xml

sed -i "45a\
<Property> \
	<Name>loadBalancerSenderTargetPath<\/Name> \
	<Value>\${com.wowza.wms.AppHome}\/conf\/loadbalancertargets.txt<\/Value> \
<\/Property> \
<Property> \
	<Name>loadBalancerSenderRedirectAddress<\/Name> \
	<Value>$2<\/Value> \
<\/Property> \
<Property> \
	<Name>loadBalancerSenderMonitorClass<\/Name> \
	<Value>com.wowza.wms.plugin.loadbalancer.LoadBalancerMonitorDefault<\/Value> \
<\/Property> \
<Property> \
	<Name>loadBalancerSenderMessageInterval<\/Name> \
	<Value>2500<\/Value> \
	<Type>Integer<\/Type> \
<\/Property>" Server.xml 

cat > /usr/local/WowzaMediaServer/conf/loadbalancertargets.txt << EOF
$1,1934,023D4FB5IS83
EOF

sudo service WowzaMediaServer restart

echo -e "Success load balancer sender! \n"
