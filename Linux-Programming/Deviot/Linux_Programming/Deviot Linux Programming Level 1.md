Here is the text from the images you've provided:

---

### PHẦN 3: NỘI DUNG KHÓA HỌC

**Buổi 1: Introduction & Setup working environment**
- Những Linux là gì? Cơ hội nghề nghiệp và roadmap
- Cài đặt, sử dụng Mobaxterm và Visual Studio Code
- Các Command line thông dụng
- Làm việc với máy chủ từ xa
- Chương trình helloworld với makefile

**Buổi 2: General Topics**
- Giới thiệu chung
- Makefile advances
- Quá trình biên dịch chương trình C
  - Static Libs and Shared Libs
  - Tạo static libs và shared libs
  - Cách hệ điều hành làm việc với libs

**Buổi 3: FILE I/O**
- Giới thiệu chung
- Quản trị file và thư mục trong Linux
- Tương tác cơ bản (open(), read(), write(), close(), lseek())
- Inode và mối quan hệ giữa file descriptor với inode
- Thuộc tính cơ bản của file và lấy thông tin của file (stat())
- I/O Buffering

**Buổi 4: PROCESS**
- Giới thiệu chung
- Phân biệt Process với Program
- Tổ chức bộ nhớ của Process
- Thao tác với Process
  - Tạo tiến trình mới
  - Chạy chương trình mới
  - Kết thúc tiến trình
- Quản lý Process
  - Quản lý tiến trình con
  - Trạng thái của tiến trình
  - Tiến trình Zombie
  - Tiến trình Orphan
  - Kỹ thuật ngăn chặn tiến trình Zombie

**Buổi 5: THREAD**
- Giới thiệu chung
- Phân biệt Process với Thread
- Tổ chức bộ nhớ của Thread
- Thao tác với Thread
  - Tạo Thread mới
  - Kết thúc Thread
- Quản lý Thread
  - Bài toán đồng bộ, bất đồng bộ
  - Mutex
  - Conditional variables

**Buổi 6: SIGNAL**
- Giới thiệu chung
- Bắt và xử lý Signal
- Một số Signal thông dụng xuyên sử dụng
- Sending Signal
- Signal Sets
- Blocking và unblocking signals

**Buổi 7 + 8: Socket**
- Giới thiệu chung
- Khái niệm Domain, Type, Protocol
- Flow hoạt động
  - Stream Socket
  - Datagram Socket
- Sockets: Unix Domain
  - Unix Socket Address
  - Stream Socket
  - Datagram Socket
- Sockets: Internet Domain
  - IPv4 Socket Address
  - IPv6 Socket Address
  - Stream Socket
  - Datagram Socket

**Buổi 9: Pipe and FIFO**
- Giới thiệu chung
- Tạo lập và sử dụng Pipe
- Pipe với bài toán đồng bộ tiến trình
- Tạo lập và sử dụng FIFO
- FIFO với bài toán client/server.

**Buổi 10: Message queues**
- Tạo lập và sử dụng Message Queue
  - Gửi dữ liệu
  - Nhận dữ liệu
- Kiểm soát hoạt động Message queues
- Message queues với bài toán client/server

**Buổi 11: Shared Memory**
- Giới thiệu chung
- System V và Posix Shared Memory
- Tạo và mở một vùng Shared Memory
- Sử dụng Shared Memory
- Kiểm soát hoạt động Shared Memory

**Buổi 12: Linux kernel module basics**
- Giới thiệu chung
- Linux kernel headers
- Hello world kernel module với Makefile
- ioctl kernel module

---

This text outlines a course on Linux programming, detailing the topics and sessions from introduction and setup to advanced topics like kernel module basics.


---
# [Linux] Bài 1: Introduction & setup working environment
https://www.youtube.com/watch?v=KU-m1Vgoz9E&list=PL0LsX_xUaMBPG-ZwodcRVJJR8mRc1p2Gz&index=1


Here is the text from the image:

---

- cpu  
- hệ thống ngoại vi  
- hệ thống bus  
- clock  

- Làm một con bóng đèn đáp ứng chức năng bluetooth, zigbee vv..

### ARM:  
- Applications: Lập trình ứng dụng người dùng  
  Tốn năng lượng  
  Khả năng xử lý cao.

- Realtime  
  Ứng dụng có tính quan trọng về mặt thời gian thực  
  - hard-realtime  ex: expected execute the command in 5 second, then, smaller than 5 seconds 
  - soft-realtime  ex: expected execute the command in 5 second, then, larger than 5 seconds 

- Microcontroller  
  Được sử dụng rộng rãi cho các hệ thống smarthome, IoT...  
  Tiết kiệm năng lượng.

### Bộ BSP  
- Bootloader: Bộ nạp khởi động, Start and init hardware (hard-drive, RAM, bus, ...)  
- Linux Kernel: after that Bootloader will load Kernel, now, Kernel can use I/O pins (Linux kernel contain Device Drivers)
- Rootfs: == Terminal == User Space, where we execute linux command (ls, vim, ss -tupln, ..)
- Toolchain: cross-compiler (gcc/g++), debugger (gdb), linker(ld), valgrind, và các libs cần thiết khác...

## Linux Embedded có thể chia ra thành 3 mảng kiến thức lớn sau:

### 1. Linux Programming: Viết các ứng dụng trên môi trường Linux.

- Lập trình tốt ngôn ngữ C/C++ trên môi trường Linux (FileIO, Process, Thread, Signal vv...).

- Có kiến thức cơ bản về hệ điều hành.



### 2. Linux Porting: Phần này sẽ thiên về tối ưu, customize hệ thống.

- Cần có kiến thức về Makefile, shell scripts.

- Hiểu biết về các build system như build-root, yocto.

- Hiểu biết về quá trình khởi động của hệ điều hành.

- Biết cách sửa đổi bootloader, kernel, thêm hay loại bỏ các package ở rootfs.



### 3. Linux Device Drivers: Viết các trình điều khiển thiết bị.

- Thường dành cho những bạn đã có kiến thức cơ bản về hai phần trên.

- Học viết một số các drivers cơ bản như I2C/SPI/UART/USB/Watchdog vv...

### What we do:
### in outsource: (FPT)
- for Toolchain: we only learn to use
- for bootloader: Optimize init time, add more command, partition flash memory, .... . Optimize bootloader to load Kernel and Rootfs as soon as posible
- linux Kernel: write driver: I2C/SPI/USBT/CAN/GPIO ....
- Rootfs: develop application in user space. (phát triển app là phụ thoai :)), do app cần sáng tạo nên mấy cty start up làm. còn mình chỉ bán cho họ phần lõi :((, NOTE: Nhưng mà phải biết hết câu lệnh nha :)), code interface mà không có hướng dẫn ai mua cha ))

- product company: (VNPT, FPT, LUMI, Dasan, Vinfast,...)
ex: Làm một con bóng đèn đáp ứng chức năng bluetooth, zigbee vv..
### Hardware
B1: tìm một thiết bị có sãn trên thị trường đáp ingws được chức năng + chi phí mà bài toán ban đầu đưa ra. (Tiết kiệm thời gian + chi phí design phần cứng, mình chỉ cần mua rồi thiết kế lại thôi )

B2: Design lại phần cứng, loại bỏ những phần không cần thiết (design PCB, remove I/O, remove pheripheral)
### Software:
#### B1: Bring up, Porting hệ điều hành phần cứng đã design
- Tối ưu lại các phần mềm của hệ thống, phần cứng I/O remove rùi thì code remove theo :)) :
NOTE: using menuconfig (GUI), k-config 
+ Uboot(famous Bootloader):
NOTE: uboot nằm ở bộ nhớ flash, sau đó sẽ load lên RAM để chạy, rồi load kernel, rồi load rootfs. 
==> Tối ưu hóa RAM, càng nhiều RAM dư càng chạy được nhiều APP, thì mình sẽ phát triển đa dạng hơn 
? Tại sao không mua thêm flash, mua thêm RAM. ans: đây là bài toán về chi phí, nâng 8GB lên 16GB RAM cũng mắc rồi đó. Camera 8MB phải tối ưu lên tối ưu xuống, phải tính theo 100 kBytes là phát triển thêm vài ứng dụng rồi 
? Tại sao dùng C/C++. Do giới hạn bộ nhớ :)) nên không dùng ngôn ngữ bậc cao :)). Bộ nhớ càng thấp càng phải dùng C. Assembly chỉ cần biết để đọc thoai, ex: đoạn mã đầu tiên trong Uboot :)) , không ai code assembly đâu, hahaha
+ Kernel:
+ rootfs:

#### B1.1 : Phát triển applications:
- Viết app




#
 Client-Ubuntu do not have hardware to use, Server-ubuntu have the setting for hardware
 ==> Client wil ssh to server to use the setting

sudo apt install openssh-server 
sudo apt install openssh-client 
sudo ssh htritai@192.168.1.128

















