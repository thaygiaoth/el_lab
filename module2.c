#include <linux/module.h>
#include <linux/init.h>
#include <linux/time.h>

MODULE_LICENSE("GPL v2");
MODULE_DESCRIPTION("Su dung sum cua module1 nen phu thuoc vao module1");
MODULE_AUTHOR("Nguyen Trung Hieu <thaygiaoth@gmail.com>");

//Khai báo sử dụng symbol tong2so của module1
extern void tong2so(int, int);

static int __init start(void)
{
	
	struct timeval tv;
	struct tm human;
	
	do_gettimeofday(&tv);
	time_to_tm(tv.tv_sec, 0, &human);
	
	//Lấy giờ, phút, giây hiện tại của kernel
	//printk(KERN_INFO "module2 thoi gian: %d:%d:%d", human.tm_hour, human.tm_min, human.tm_sec);

	//%02d để in ngày, tháng dưới 10 có số 0 ở trước
	printk(KERN_INFO "module2 them vao kernel ngay %02d thang %02d nam %ld", human.tm_mday, human.tm_mon+1, human.tm_year+1900);
        
	tong2so(1, 2);

	return 0;
}

static void __exit finish(void)
{
        printk(KERN_INFO "module2 hen gap lai");
}

module_init(start);
module_exit(finish);
