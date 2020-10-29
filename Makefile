
obj-m := rootkit.o

KERNEL_DIR= /mnt/c/Project/Compile/goldfish

all:
	make -C $(KERNEL_DIR) M=$(shell pwd)/ ARCH=arm CROSS_COMPILE=arm-linux-androideabi- modules
clean:
	make -C $(KERNEL_DIR) M=$(shell pwd) clean
