#!/bin/bash

#Oracle có viết script tính hugepage: https://docs.oracle.com/database/121/UNXAR/appi_vlm.htm#UNXAR391
#Red Hat có srcipt ở đây: https://access.redhat.com/sites/default/files/attachments/deploying_oracle_12c_rhel7_updated-aug-1-2016.pdf

#Mị có chỉnh sửa lại cho dễ nhìn và thêm 1 chút mắm muối để ngon hơn

#Lấy số phiên bản của kernel
KERN=`uname -r | awk -F. '{ printf("%d.%d\n",$1,$2); }'`

# Find out the HugePage size
HPG_SZ=`grep Hugepagesize /proc/meminfo | awk '{print $2}'`

# Start from 1 pages to be on the safe side and guarantee 1 free HugePage
NUM_PG=1

# Cumulative number of pages required to handle the running shared memory segments
for SEG_BYTES in `ipcs -m | awk '{print $5}' | grep "[0-9][0-9]*"`
do
MIN_PG=`echo "$SEG_BYTES/($HPG_SZ*1024)" | bc -q`
if [ $MIN_PG -gt 0 ]; then
NUM_PG=`echo "$NUM_PG+$MIN_PG+1" | bc -q`
fi
done

# Finish with results

case $KERN in

#Đồ cổ giờ chắc giờ không ai xài nữa roài
'2.4') HUGETLB_POOL=`echo "$NUM_PG*$HPG_SZ/1024" | bc -q`;
echo "Cấu hình: vm.hugetlb_pool = $HUGETLB_POOL" ;;

#RHEL 5/6 có kernel 2.6
#Oracle Linux 6 có kernel 2.6, 3.8, 4.1: https://yum.oracle.com/oracle-linux-6.html 
'2.6'|'3.8'|'4.1') MEM_LOCK=`echo "$NUM_PG*$HPG_SZ" | bc -q`;
echo -e "\nSố trang hugepage cần cấp phát:
hugepages = $NUM_PG"

echo -e "\nCấu hình trong /etc/security/limits.d/99-oraclelimits.conf:
oracle     soft     memlock     $MEM_LOCK"
echo "oracle     hard     memlock     $MEM_LOCK"

echo -e "\n---Giải thích: $NUM_PG * $HPG_SZ = $MEM_LOCK (KiB)---\n";;

#3.10 là kernel của RHEL 7, 4.14 là kernel UEK của OL 7
#4.18 là kernel của RHEL 8, chưa có kernel đóng gói riêng của Oracle trên OL 8
'3.10'|'4.14'|'4.18') MEM_LOCK=`echo "$NUM_PG*$HPG_SZ" | bc -q`;
echo -e "\nSố trang hugepage cần cấp phát: 
hugepages = $NUM_PG"

echo -e "\nCấu hình trong /etc/security/limits.d/99-oraclelimits.conf:
oracle     soft     memlock     $MEM_LOCK"
echo "oracle     hard     memlock     $MEM_LOCK"

echo -e "\n---Giải thích: $NUM_PG * $HPG_SZ = $MEM_LOCK (KiB)---\n";;

*) echo -e "\nKhông hỗ trợ tính số hugepae ở phiên bản kernel này.\n";;

esac
