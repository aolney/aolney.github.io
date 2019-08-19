---
layout: post
section-type: post
title: Pure Data Virtual MIDI on a Chromebook
category: Category
tags: ['hardware','outreach','music']
---

Here's how to use a virtual MIDI keyboard on a Chromebook to control a synth in Pure Data.

Chromebooks have become an increasingly interesting option for many computer applications since [Crouton](https://github.com/dnschneid/crouton) and later [Crostini](https://chromium.googlesource.com/chromiumos/docs/+/master/containers_and_vms.md) made it possible to run Linux on Chromebooks.
Crostini in particular has a nice integration that allows the sandboxed Linux VM to spawn individual application windows rather than a full Linux desktop.
This makes user-perspective interoperability between ChromeOS, Linux, and [even Android apps](https://support.google.com/chromebook/answer/7021273?hl=en) fairly seemless.

Recent [USB support for Linux apps](https://kmyers.me/blog/chromeos/chromeos-75-0-3759-4-brings-proper-usb-support-to-linux-applications-and-breaks-a-few-things-in-the-process/) led me to believe I could plug a class-compliant MIDI keyboard into a Chromebook and have it connect to the Linux VM.
However, [it turns out](https://kmyers.me/blog/chromeos/crostini-usb-what-works-and-what-does-not/) that keyboard USB is not supported.

All is not lost, however, because there are plenty of virtual keyboards for Linux, perhaps the most famous being VMPK.
The idea here is to simulate a MIDI keyboard and then route the messages it generates to [Pure Data](https://puredata.info/).
Pure Data can then interpret those messages as commands to a synth (play this note for this long). 
As simple as that sounds, it took a bit of hacking to get it working on the Chromebook.

The first gotcha is to use a really old virtual MIDI keyboard, [vkeybd](http://ccrma.stanford.edu/planetccrma/man/man1/vkeybd.1.html).
The reason is that vkeybd uses ALSA as opposed to JACK, and while this is less ideal from a performance standpoint, it seems to be all the Chromebook can currently handle.
JACK installations of any type completely broke sound on my Chromebook.

The seconds gotcha is that even though Pure Data (PD) has MIDI configurations in its interface, these don't seem to work for our purposes.
If you set them to ALSA and channel 1, they will happily comply and remember the settings, but no ports will be open in Linux corresponding to those choices.
To make them work, they need to be passed in as command line flags.

Finally, the ports openned by vkeybd must be connected to PD, and the easiest way to do this is with 
[aconnectgui](https://packages.debian.org/sid/sound/aconnectgui), which gives a graphical representation of cable patching options between the two.
Once this is done, pressing a key on vkeybd will trigger a MIDI message for PD.

Install these applications with `sudo apt install puredata aconnectgui vkeybd` and then run the above steps using the script below.

<script src="https://gist.github.com/aolney/5123deaddc4abaa30900c6985686d5fe.js"></script>

I believe this will all work with the `Debian Strech` that comes standard with Chromebooks, but I upgraded mine for other reasons to `Debian Buster` using the script below.

<script src="https://gist.github.com/aolney/844e80d34d551eaf9ff23ec69246f9cb.js"></script>

