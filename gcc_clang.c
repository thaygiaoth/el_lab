/*Minh họa biên dịch bằng gcc và clang
 * 
 * Các cảnh báo của gcc và clang
 * 
 * https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html
 * 
 * https://clang.llvm.org/docs/DiagnosticsReference.html
 *
 * EL: yum -y install gcc clang
 * Ubuntu: apt -y install gcc clang
 *
 * gcc gcc_clang.c -o gcc.out
 *
 * gcc -Wall gcc_clang.c -o gcc.out
 *
 * gcc -Wextra gcc_clang.c -o gcc.out
 *
 * Biên dịch bằng clang: thay lệnh gcc bằng clang
 */

/*Biên dịch bỏ các symbol: 
 * 
 * gcc -s gcc_clang.c -o gcc_stripped.out
 *
 * --> kích thước file gcc_stripped.out nhỏ hơn gcc.out
 * 
 * Mục đích:
 * giảm kích thước file sau khi biên dịch
 * --> tải file lên RAM nhanh, chạy ít tốn bộ nhớ, khó dịch ngược...
 * 
 * https://gcc.gnu.org/onlinedocs/gcc/Link-Options.html#Link-Options
 * 
 * Tham khảo thêm lệnh strip và
 * https://en.wikipedia.org/wiki/Stripped_binary
 *
 * Dùng lệnh file xem thuộc tính stripped của file sau khi biên dịch
 *
 * file gcc.out | tr , '\n' && file gcc_stripped.out | tr , '\n'
 *
 * Kết quả: gcc.out --> not stripped ; gcc_stripped.out --> stripped
 *
 * Dùng lệnh nm kiểm tra file sau khi biên dịch
 *
 * nm gcc.out --> có symbol
 *
 * nm gcc_stripped.out --> no symbols
 */

#include <stdio.h>

/*Thường thì chương trình main là kiểu int và có dòng return 0 cuối cùng
 * khai báo void để có cảnh báo
 */
void main(void)
{
    	/*Khai báo biến a nhưng không sử dụng để hiển thị cảnh báo
	 * biên dịch bằng -Wall hoặc -Wunused-variable*
	 */
        int a;

	/*Khai báo biến tong nhưng không gán giá trị để sử dụng có cảnh báo 
	 * biên dịch bằng -Wall hoặc -Wuninitialized
	 */
        double tong;
        printf("Gia tri cua bien tong: %lf\n", tong);
	
	/*Biến tong kiểu double, sử dụng %d trong printf để có cảnh báo
	 * định dạng đúng là %f, %lf
	 */
	printf("Gia tri cua bien tong dinh dang %%d : %d\n", tong);

	/*Biến x và y khác dấu, khi so sánh có cảnh báo
	 * biên dịch bằng -Wextra hoặc -Wsign-compare
	 * biên dịch bằng -Wall sẽ không có cảnh báo
	 */
	int x=-1;
	unsigned y=2;
	
	if (x>y)
	printf("So sanh bien x=%d và y=%d khong cung dau\n", x, y);

	printf("So sanh bien dich bang gcc va clang\n");
}
