#!/usr/bin/env bash

t1=`systemctl is-enabled crond`

t2=`systemctl is-active crond`

if [[ $t1 = "enabled" && $t2 = "active" ]]
then
	echo "crond hien tai dang chay va tu dong chay khi khoi dong OS"
	echo "Neu khong thi dung lenh:"
       	echo "systemctl enable crond && systemctl enable crond"
	echo "nha cac ban"

	exit $XCCDF_RESULT_PASS
fi

exit $XCCDF_RESULT_FAIL
