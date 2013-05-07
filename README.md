Wowza Edge-Origin architecture configurator
===========================================

The following scripts configure Amazon EC2 instances, with pre-configured Wowza Media Server 3.5.2 for an edge-origin nDVR streaming setup.

The scripts perform the following configurations on the instances:

* Setup liverepeater-origin and liverepeater-edge. More info at http://www.wowza.com/forums/content.php?306
* Configure secure publishing from an RTMP encoder. More info at http://www.wowza.com/forums/content.php?233
* Add Dynamic Load Balancing to the "origin" server. More info at http://www.wowza.com/forums/content.php?108

Requirements
------------

* Amazon EC2 account
* At least two running instances (a "origin" and an "edge")
* Wowza Media Server "lickey" license

The scripts have been tested with ami-7c868f08 (EU region)

Usage
-----

    ./configure.sh

The general use case of the script is to initially configure an origin server, as well as a number of edge servers. During a live video streaming of an event, an operator could add more edge servers if necessary, to reduce the load on the rest of the edge servers.
