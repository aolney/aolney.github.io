---
layout: post
section-type: post
title: CUDA eGPU Ubuntu 18.04
category: Category
tags: [ 'hardware', 'braintrust','research','nlp' ]
---

CUDA is a platform that allows programs to use the computational capacity of graphics cards (GPUs), and is particularly suited to the massive parallelism of deep neural networks.

If your goal is to maximize performance, then you want a desktop solution, and there are many guides out there [for how to build a desktop machine for deep learning](https://pcpartpicker.com/b/FGP323).

However, some of us really like our laptops and would like decent deep learning performance without having to buy another computer. There are of course [cloud-based options](https://medium.com/@rogerxujiang/setting-up-a-gpu-instance-for-deep-learning-on-aws-795343e16e44), and they may make sense costwise. But since cloud-based gpus are close to $1/hour, they may not.

An eGPU (external GPU) connects to your laptop (or desktop) in much the same way as an external harddrive. Setting one up for CUDA is a bit challenging. Here's how to do it for both Windows and Ubuntu.

### Parts list:

- Laptop supporting Thunderbolt 3 (I have a Thinkpad P50) running Windows 10 and Ubuntu 18.04 (dual boot)
- AKITIO Node eGPU enclosure
- NVIDIA GPU (I have a PNY 1080ti blower-type reference card)

## Steps

### Get it working on Windows

Install the GPU in the Node according to those instructions and boot into BIOS.
If you have hybrid graphics (integrated and discrete) disable that so it is always discrete.
You may also want to disable secure boot while you're in there - I don't know if it's strictly necessary, but I already had this disabled.

Boot into Windows, and plug the Thuderbolt cable in once your desktop appears. 
I found that Windows was much happier with hotplugging than booting with the eGPU plugged in.
Following the Node instructions, see if the GPU is recognized by the OS (in the Thunderbolt tray bottom right).
I had to update Thunderbolt firmware (just as the Node instrucitons said) for it to appear.
Updating the firmware is a major reason for making sure this works in Windows first.

Once the GPU appears, install the latest drivers. 
It is very important that all your NVIDIA cards use the same driver.
On my P50, the discrete GPU is a Quadro, and until I had it on the same driver version as the 1080ti, I would periodically get some flakey behavior.
It was pretty slick for me once I did this - the internal display was handled by the Quadro and the 1080ti was completely left over for CUDA.

You can install CUDA or just run some DNN applications at this point (that's what I did to test b/c I'm not currently interested in developing CUDA in Windows right now).

### Get it working in Ubuntu

Unfortunately it's a bit harder in Linux.
I started with a fresh copy of 18.04 (Bionic Beaver) alpha.

#### Thunderbolt install

If you are using 18.04, you should be pretty much good to go. The main snag is that the Thunderbolt device is not authorized when you boot up. It doesn't seem to matter if it is plugged in during boot or not. Unlike Windows, Linux seems to be happiest when the Thunderbolt is **NOT** hotplugged.

Open up a terminal and execute the following script or commands separately:


```
#!/bin/bash
echo "Check that kernel version is at least 4.13"
uname -a
echo ""
echo "Check that eGPU appears as Thunderbolt device"
cat /sys/bus/thunderbolt/devices/0-1/device_name 
echo ""
echo "Authorize eGPU device"
sudo sh -c 'echo 1 > /sys/bus/thunderbolt/devices/0-1/authorized'
echo ""
echo "Check that eGPU now shows up with lspci"
lspci | grep NVIDIA
```

It's really the last two commands that matter once you establish that Thunderbolt isn't broken for you.
You still need to authorize (if you do this when it is already authorized, you will get an I/O error) and check that your eGPU (i.e. 1080ti) shows with lspci. If you run this as a script, `lspci` may not immediately show the eGPU after authorization, but it will if you type it in again.

**OK this is the weird part.** Once you have the eGPU authorized and showing up in `lspci`, you need to log out and log back in. It seems this is the only way the proper drivers will load for the eGPU. You will need to do this every time you use the eGPU, even after you complete the following installation steps. When you log back in, you do not need to reauthorize.

#### CUDA install
- Open Software & Updates, go to Additional Drivers, and install nvidia-driver-390. 
- [Follow the Pre-installation Actions of CUDA 9.1](http://docs.nvidia.com/cuda/cuda-installation-guide-linux/#pre-installation-actions)
- [Follow the Ubuntu package installation instructions](http://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#ubuntu-installation) **BUT** when you get to "5. Install CUDA" **DO THIS INSTEAD**
`sudo apt install cuda-toolkit-9-1 cuda-libraries-dev-9-1 cuda-libraries-9-1` which will install everything but the driver. You don't want the driver in the `cuda` package (387), you want the one you already installed (390).
- [Follow the Post-installation Actions](http://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#post-installation-actions). I don't think you need to do the `nvidia-persistenced` part because the package installation seems to take care of that for you. If you reboot and later find this missing, you can always add it manually. I also didn't find it necessary to mess with disabling the `udev` rule as was described in the guide.
- Go ahead and follow the [recommended actions](cuda-install-samples-9.1.sh). This will verify that everything is working, i.e. when you run `nvidia-smi` or `deviceQuery` you see your eGPU listed.

## Conclusion

That's it, you should be good to go. I ended up modding my Node with a new case fan because the existing case fan was pretty loud. I also replaced the front grill with metal screen door mesh to increase air flow. It seems to have helped though I wasn't really having heat problems before anyways.

Parts:

- [Noctua 120mm fan](https://www.amazon.com/gp/product/B00BEZKX8Y)
- [Adapter because the stock fan is 2 pin](https://www.amazon.com/gp/product/B002FR84FY)
