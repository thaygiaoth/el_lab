#include <linux/module.h>
#include <linux/init.h>
#include <linux/time.h>
//Xem thêm về
//include <linux/{ktime.h,timekeeping.h}>

MODULE_LICENSE("GPL v2");
MODULE_DESCRIPTION("Co EXPORT_SYMBOL(sum) de module2 su dung");
MODULE_AUTHOR("Nguyen Trung Hieu <thaygiaoth@gmail.com>");

/* Định dạng hiển thị của printk tham khảo:
 * https://www.kernel.org/doc/Documentation/printk-formats.txt
 */

void tong2so(int a, int b)
{
	printk(KERN_INFO "Tong cua %d + %d la %d", a, b, a + b);
}

EXPORT_SYMBOL(tong2so);

static int __init module1_init(void)
{
	unsigned int gio, phut, giay;
	
	struct timespec ts;
	getnstimeofday(&ts);
	
	/* Do giờ Việt Nam là GMT +7 nên biến gio +7
	 * Thiết lập múi giờ VN trong môi trường shell:
    	 * timedatectl set-timezone Asia/Ho_Chi_Minh
    	 * Phần này không phải cách tổng quát để lấy thời gian ở không gian kernel (kernel space),
    	 * chỉ thực hiện biến đổi số giây thành giờ, phút, giây tương ứng
    	 * Trong time.h có khá nhiều cấu trúc (struct) về thời gian!
    	 */

	gio=((ts.tv_sec / 3600) + 7) % 24;
	phut=(ts.tv_sec / 60) % 60;
	giay=ts.tv_sec % 60;

	//%02d để in giờ, phút, giây dưới 10 có số 0 ở trước
	printk(KERN_INFO "module1 them vao kernel luc: %02d gio %02d phut %02d giay", gio, phut, giay);

	return 0;
}

static void __exit module1_exit(void)
{
	printk(KERN_INFO "module1 hen gap lai");
}

module_init(module1_init);
module_exit(module1_exit);
