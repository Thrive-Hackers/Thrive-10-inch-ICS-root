cd roottool/
UNAME=`uname`
if $UNAME!=( Darwin || Linux )
	then
	echo "Platform not supported"
	exit
	fi

	