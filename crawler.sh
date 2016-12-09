#/bin/sh
#
# Simple script to get list of all links from website descending down from given URL
#
# Usage crawler.sh URL
#

URL=$1
OUTPUT=${2:-/dev/stdout}

# Check whether we have wget, curl and dig
if [ ! -x /usr/bin/wget ]
then
	>&2 echo "ERROR: wget not present"
	exit 1
fi

if [ ! -x /usr/bin/curl ]
then
	>&2 echo "ERROR: curl not present"
	exit 1
fi

if [ ! -x /usr/bin/dig ]
then
	>&2 echo "ERROR: dig not present"
	exit 1
fi

# Check we have at least one parameter
if [ "$#" -lt 1 ]
then
	echo "Usage $0 URL"
	exit 1
fi

# Check whether given URL is accessible by getting HTTP code with curl
# 200 - OK
# 301,302,307 & 308 - redirects
http_code=$(curl --connect-timeout 1 -m 2 -s -o /dev/null -w '%{http_code}' $URL)
case $http_code in
	200|30[1278])
	echo "$URL is accessible, getting list of links"
	echo
	;;
	*)
	>&2 echo "ERROR: $URL is not accessible"
	exit 1
	;;
esac

#Getting FQDN from URL
HOST=${URL##h*//}
HOST=${HOST%%/*}

# Getting domain from FQDN by looking for SOA record
DOMAIN=`/usr/bin/dig $HOST SOA | grep -v "^;" | grep SOA | cut -f1 | sed -e"s/\.$//"`

# Creating temp dir, to ensure we can write to disk
TMPDIR=$(mktemp -d)
CURDIR=$(pwd)
cd $TMPDIR

# Crawling website, down from URL with wget
# -r - recursive retrieving
# -np - no-parent - do not ascend above initial location
# -nd - no-directories - don't create hierarchy of directories
# --no-check-certificate - don't check X.509 cert issuer and matching hostname with CN
# (potentially "unsecure")
# -nv - less verobose output
# --spider - not downloading, unless expecting links in content
# -H --span-hosts - enable spanning hosts
# -D - domain list, when using one domain limits spanning to this domain only
# --delete-after - remove file after retrieving

/usr/bin/wget -r -np -nd --no-check-certificate -nv --spider -H -D$DOMAIN --delete-after $URL |& \
awk -v fqnd="$HOST" '$3 ~ fqnd {sub(/^URL:/, "", $3); print $3}'

cd $CURDIR
rm -rf $TMPDIR
