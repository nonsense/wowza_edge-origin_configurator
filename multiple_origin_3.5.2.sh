#!/bin/bash
#
# Configuration for ORIGIN server on a multiple configuration streaming

cd /usr/local/WowzaMediaServer/applications
mkdir dvrorigin

cd /usr/local/WowzaMediaServer/conf
cp -R live dvrorigin

cd /usr/local/WowzaMediaServer/conf/dvrorigin

sed -i "16s/live/liverepeater-origin/" Application.xml
sed -i "20s/smoothstreamingpacketizer,cupertinostreamingpacketizer,sanjosestreamingpacketizer/smoothstreamingpacketizer,cupertinostreamingpacketizer,sanjosestreamingpacketizer,dvrstreamingpacketizer/" Application.xml
sed -i "43s/<Recorders><\/Recorders>/<Recorders>dvrrecorder<\/Recorders>/" Application.xml
sed -i "47s/<Store><\/Store>/<Store>dvrfilestorage<\/Store>/" Application.xml
sed -i "69s/cupertinostreaming,smoothstreaming,sanjosestreaming/cupertinostreaming,smoothstreaming,sanjosestreaming,dvrchunkstreaming/" Application.xml

# License key
cat > /usr/local/WowzaMediaServer/conf/Server.license << EOF
$1
EOF

sed -i "153a\
<Module>  \
    <Name>ModuleSecureURLParams<\/Name>  \
    <Description>ModuleSecureURLParams<\/Description>  \
    <Class>com.wowza.wms.security.ModuleSecureURLParams<\/Class> \
<\/Module>" Application.xml

sed -i "156a\
<Property> \
    <Name>secureurlparams.publish<\/Name> \
    <Value>hadassim.password<\/Value> \
<\/Property>" Application.xml

#cd /opt/script
#./prepare_s3fs.sh

sudo service WowzaMediaServer restart

echo "Success!"
