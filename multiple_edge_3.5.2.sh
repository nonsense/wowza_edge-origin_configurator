#!/bin/bash
#
# Configuration for EDGE server on a multiple configuration streaming

cd /usr/local/WowzaMediaServer/applications
mkdir dvredge

cd /usr/local/WowzaMediaServer/conf
cp -R live dvredge

cd /usr/local/WowzaMediaServer/conf/dvredge

sed -i "16s/live/liverepeater-edge/" Application.xml
sed -i "20s/smoothstreamingpacketizer,cupertinostreamingpacketizer,sanjosestreamingpacketizer/smoothstreamingpacketizer,cupertinostreamingpacketizer,sanjosestreamingpacketizer,dvrstreamingrepeater/" Application.xml
sed -i "67s/cupertinostreaming,smoothstreaming,sanjosestreaming/cupertinostreaming,smoothstreaming,sanjosestreaming,dvrchunkstreaming/" Application.xml
sed -i "130s/<OriginURL><\/OriginURL>/<OriginURL>wowz:\/\/$1\/dvrorigin<\/OriginURL>/" Application.xml

# License key
cat > /usr/local/WowzaMediaServer/conf/Server.license << EOF
$2
EOF

sudo service WowzaMediaServer restart

echo "Success edge!"
