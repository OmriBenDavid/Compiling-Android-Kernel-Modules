# Compiling-Android-Kernel-Modules
This is the way I managed to compile an android kernel module for the ARM architecture.

There are some guides throughout the web that claim to be the correct way to do that but none of them worked for me so I decided to share the way I managed to cross-compile a kernel module for android.

I hope whoever finds this repo will find it helpful.

### Note
This Guide is a work in progress and might change slightly throughout the following weeks.

## Disclamer
This guide is for a linux system, I'll safely assume you all use linux systems when programming kernel modules.
I would not reccomend trying to cross-compile your android kernel module on a windows system.
If you choose to do so on a windows system do so at your own frustration.

However, windows does offer a subsystem for linux (WSL) which works great in our case.

## Step 1 - Fetching the kernel:
In this guide we are going to use the goldfish kernel.

    git clone https://android.googlesource.com/kernel/goldfish -b android-goldfish-4.14-dev

This might take some time so in the meanwhile feel free to play some minecraft and listen to your favorite spotify playlist.

## Step 2 - Making the kernel makable
In order to make the kernel makable we need to alter the configurations file used in compilation.
In our case we use a file called 'ranchu_defconfig'

For this part you are free to use your favorite text editor, I'll assume it's vim.

    cd goldfish
    vim arch/arm/configs/ranchu_defconfig

Now that the file is open follow these instructions:

1) At the very top add the line:

line:

    # CONFIG_IPV6 is not set
    

2) Go down the file and comment out (using the '#' character) the following lines:

Lines:
    
    #CONFIG_NF_CONNTRACK_IPV6=y
    
    #CONFIG_IP6_NF_IPTABLES=y
    
    #CONFIG_IP6_NF_FILTER=y
    
    #CONFIG_IP6_NF_TARGET_REJECT=y
    
    #CONFIG_IP6_NF_MANGLE=y
    
    #CONFIG_IP6_NF_RAW=y

3) Scroll down to the very bottom of the file and add the following lines:

lines:
    
    CONFIG_MODULES=y
    
    CONFIG_MODULE_FORCE_LOAD=y
    
    CONFIG_MODULE_UNLOAD=y
    
    CONFIG_MODULE_FORCE_UNLOAD=y
    
    CONFIG_MODULE_SIG=y
    
    CONFIG_MODULE_SIG_FORCE=y

## Step 3 - Fetching the cross-compiler
For cross compiling the kernel and later the module we will use the android NDK.
The version that worked best for me was android-ndk-r12b and this is the one we will use in this guide.


    curl -O http://dl.google.com/android/repository/android-ndk-r12b-linux-x86_64.zip


When the download is done it's time to unzip the file.

    unzip android-ndk.zip

Both parts will also take some time. 
In the meanwhile feel free to rewatch bojack horseman (or just watch if you haven't) and feel better about your life.

After the unpackaging is done and you feel well rested it's time to mess with environment variables! 

It's not 100% necessary but it will be very helpful and save us some work later.

    export PATH="/path/to/folder/android-ndk-r12b/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin:${PATH}"
    
### Note:
instead of path/to/folder write the actual path. I don't know your machines.

## Step 4 - Making the kernel
To make the kernel we first need to make the configuration file (remember? the one we changed earlier?)

    cd goldfish
    make ARCH=arm CROSS_COMPILE=arm-linux-androideabi- ranchu_defconfig
    
If everything looks dandy it's time to make the kernel

    make ARCH=arm CROSS_COMPILE=arm-linux-androideabi- -j$(nproc --all)

(This way the make command uses all CPU cores to speed up the compilation)

This part will also take some time.
This time feel free to browse the web for some nice dinner recipes, find one that you wish to try and make yourself and your SO dinner.
You two deserve it.
(it's okay if you are your own SO, double the food for you)

## Step 5 - Making the module
In order to make the module you need a Makefile.
I have already uploaded a sample makefile.

Download the Makefile into the directory where the module's sorce code is saved and run the command:
    
    make

It should work absolutely fine.

Once compilation is done (which happens very quickly) you should have a ready .ko file.


## Step 6 - Signing the module
Android demands kernel modules to be digitally signed in order to insert them.
Luckily the goldfish kernel provides us with the needed certifications in order to sign a module.

To do so just enter the goldfish directory and run:

    ./scripts/sign-file sha512 ./certs/signing_key.pem ./certs/signing_key.x509 /path/to/helloworld.ko /path/to/helloworld-signed.ko

Assuming you are using my helloworld.c source code.

## Conclusion
This is the guide so far. 
This is the way I managed to compile android kernel modules.
I do appologize that there are no demonstrations, I could not find a way to make an emulator that supports kernel modules.
I hope you found this guide helpful.
