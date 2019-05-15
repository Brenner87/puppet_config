#!/bin/bash
. /etc/sysconfig/puppetserver
/opt/puppetlabs/puppet/bin/r10k deploy environment -p
/opt/puppetlabs/server/apps/puppetserver/bin/puppetserver $1
