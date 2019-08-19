#!/bin/bash

# Script này chỉ kiểm tra chạy trên EL 7/8 và Ubuntu 18.04

### B1. Tạo file lệnh cmdtime ###

# Dùng 'EOF' để giữ nguyên các kí tự bên trong muốn ghi ra file, 
# không để vô tình dịch biến ra giá trị

cat > /usr/bin/cmdtime << 'EOF'
#!/bin/bash

# %T = %H:%M:%S, xem trong man date

# Ghi thời gian, dừng 1 giây (sleep 1) rồi ghi tiếp

while true;
do
        thoigian=$(date +%T' '%d/%m/%Y)
        echo "Thời gian chạy lệnh cmdtime: $thoigian" >> /var/log/cmdtime.log;
        sleep 1;
done
EOF

### B2. Làm cho lệnh cmdtime có thể chạy được ###
chmod +x /usr/bin/cmdtime

### B3. Tạo dịch vụ cmdtime.service trong systemd ###

# Nếu là EL 7/8 thì phải tạo trong /usr/lib/systemd/system/
# Nếu là Ubuntu thì phải tạo trong /lib/systemd/system/

duongdan='/usr/lib/systemd/system'

# Kiểm tra là Ubuntu
if [ -f /etc/lsb-release ] && grep -i 'DISTRIB_ID=Ubuntu' /etc/lsb-release &>/dev/null; then
	duongdan='/lib/systemd/system'
fi

cat > $duongdan/cmdtime.service << 'EOF'
[Unit]
Description=Ghi thời gian chạy lệnh 1 giây 1 lần vào /var/log/cmdtime.log
After=default.target

[Service]
Type=simple
ExecStart=/usr/bin/cmdtime

[Install]
WantedBy=default.target
EOF

### B4. Cập nhật cmdtime.service cho systemd ###
systemctl daemon-reload 

# Xem cấu hình dịch vụ cmdtime.service ###
# systemctl cat cmdtime.service

### B5. Chạy dịch vụ ###
systemctl start cmdtime.service &&
systemctl status cmdtime.service --no-pager

# Lệnh echo có -e để dịch \n thành xuống hàng

echo -e '\n1. Nhấn Ctrl + C để nghỉ xem\n'

echo -e '2. Chạy lệnh systemctl stop cmdtime.service để dừng dịch vụ\n'

### B6. Xem cmdtime ghi thời gian mỗi giây 1 lần, nhấn Ctrl + C để thoát ###
tail -f /var/log/cmdtime.log
