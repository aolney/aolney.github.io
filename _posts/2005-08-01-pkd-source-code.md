---
layout: post
section-type: post
title: PKD Android Source Code
category: Category
tags: [ 'research', 'pkd', 'robots','nlp','semantics','discourse' ]
---

![project logo](https://umdrive.memphis.edu/aolney/public/projects/pkd/PKD_Header.jpg?uniq=fpaqvw)

I’m releasing the source code under the MIT license. Because not all the software was open source to begin with, I can’t release everything – so this source won’t compile to a working version. Regardless, here it is if you want to play with it. All in C#.


Overview
The primary purpose of this code was for demonstration at WIRED NextFest. Because I didn’t really know what I was building / what was possible, the whole thing is a rapid prototype. There are three main conceptual layers. Inputs, control, and outputs. The inputs are the sensory modalities of the robot, e.g. speech recognition, face tracking, face recognition, etc. Control is handled through JESS. The output modalities are servo commands that make the robot move, as well as the sound accompanying the robot’s speech. B/c another developer was supposed to implement the output layer (and didn’t) I just made that part of the control layer.

This is how it all works together. Each input (a plugin) is a JESS shadow fact, like a JavaBean. That means that when one of the plugins, e.g. the ASR plugin, changes, it automatically updates the JESS rulebase. What I did to get JESS to work in C# is to compile a dll of it using IKVMC(all that and a bag of chips). I used the version of JESS that is free with the electronic book version of JESS, available from the publisher. JESS also allows me to access a Protégé ontology (ok, that part had to be in java, but I remote a java object using IIOP.NET) However, there was a significant downside to using JESS with remoting (which I did b/c each plugin is a remoted object that can run on a separate machine). The problem is that the conversion process to C# doesn’t make the Java classes serializable. So I had to use proxy classes, and even worse, use polling instead of callbacks with the proxies (trying to implement a callback led to the same serialization problem). Maybe there’s a way out of that, but I didn’t have the luxury of time to find it. So I’ve noticed some weird threading issues every once and a while as a result of the polling. I’d probably replace JESS with something else open source if I were to do it again (although JESS is a fabulous program); of course, if I had just left it as Java, I wouldn’t have had this problem.

Other issues? Well, there are some copyright issues over PKD’s works. The PKD Android Project is a work of art, and so Fair Use applies. However, I don’t think it would be appropriate for me to release his works on the Internet. So that’s the double whammy – the NLG process that creates responses uses that material. However, you could supply material of your own...

Enough already!

[Get the source](https://umdrive.memphis.edu/aolney/public/projects/pkd/Open%20Source%20PKD%20Software.zip)
