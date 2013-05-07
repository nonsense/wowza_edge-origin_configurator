#!/bin/bash
#
# Configuration for EDGE server on a multiple configuration streaming

echo -e "Setting up listener for origin $1 and edge $2 \n"

cd /usr/local/WowzaMediaServer/conf

sed -i "30a\
<ServerListener> \
	<BaseClass>com.wowza.wms.plugin.loadbalancer.ServerListenerLoadBalancerListener<\/BaseClass> \
</ServerListener>" Server.xml

sed -i "45a\
<Property> \
	<Name>loadBalancerListenerKey<\/Name> \
	<Value>023D4FB5IS83<\/Value> \
<\/Property> \
<Property> \
	<Name>loadBalancerListenerIpAddress<\/Name> \
	<Value>*<\/Value> \
</Property> \
<Property> \
	<Name>loadBalancerListenerPort<\/Name> \
	<Value>1934<\/Value> \
	<Type>Integer<\/Type> \
<\/Property> \
<Property> \
	<Name>loadBalancerListenerRedirectorClass<\/Name> \
	<Value>com.wowza.wms.plugin.loadbalancer.LoadBalancerRedirectorConcurrentConnects<\/Value> \
<\/Property> \
<Property> \
	<Name>loadBalancerListenerMessageTimeout<\/Name> \
	<Value>5000<\/Value> \
	<Type>Integer<\/Type> \
<\/Property>" Server.xml 


sed -i "45a\
<HTTPProvider> \
	<BaseClass>com.wowza.wms.plugin.loadbalancer.HTTPLoadBalancerRedirector<\/BaseClass> \
	<RequestFilters>*loadbalancer<\/RequestFilters> \
	<AuthenticationMethod>none<\/AuthenticationMethod> \
	<Properties> \
		<Property> \
			<Name>enableServerInfoXML<\/Name> \
			<Value>true<\/Value> \
			<Type>Boolean<\/Type> \
		<\/Property> \
	<\/Properties> \
<\/HTTPProvider>" VHost.xml

sudo service WowzaMediaServer restart

echo -e "Success load balancer listener!\n"
