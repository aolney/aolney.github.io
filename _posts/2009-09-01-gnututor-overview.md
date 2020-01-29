---
layout: post
section-type: post
title: GnuTutor Project Overview
category: Category
tags: ['research','its','gnututor','nlp','semantics','discourse','education-research','agents','project-overviews']
---

![gnututor logo](https://blogs.memphis.edu/aolney/files/2019/10/gnututor3.jpg)

[Click here for all GnuTutor posts](/tags/gnututor.html)

GnuTutor is an open source re-imagining of the intelligent tutoring system AutoTutor developed at the Institute for Intelligent Systems at the University of Memphis. GnuTutor has a simple codebase to foster development of derivative ITS.

GnuTutor is written in C# and should run on Window, Linux, and OSX using [Mono](https://www.mono-project.com/Main_Page)

GnuTutor is hosted on [Sourceforge](https://sourceforge.net/projects/gnututor/)


## Demo

<iframe width="425" height="355" src="https://www.youtube.com/embed/k6HDEEnYuIA" frameborder="0" allowfullscreen></iframe>

## Installation

First you need to download the source package from Sourceforge, unzip it, and put it in a convenient folder. At the top level, you will see three folders. One folder, Databases, contains all of the configurable resources for the tutor (except the app.config), including the LSA space (semantic space), the rules for the speech act classifier, the Prolog script for the dialogue manager, and the rule file for the Brill tagger. A seond folder, called Log Files, contains the log files for the sessions that take place in XML format. More on that format later. Finally, the third folder contains all the source for the GnuTutor.

The app.config file tells GnuTutor where to find the folders above. You'll need to change the values to match your environment. Most likely this involves changing only these two lines

{% highlight xml %}
<add key="DatabasePath" value="C:\VAULT\gnututor\code\release\gnututor_0.1\Databases\" />

<add key="LogPath" value="C:\VAULT\gnututor\code\release\gnututor_0.1\LogFiles\" />
{% endhighlight %}

to the correct path of the Databases and LogFiles folders.

Next you will need to install some of the agent libraries/executables depending on what agent you want to use. If you are on windows, install the Haptek Player

https://www.haptek.com/products/player/

This should solve any broken dependencies. Or you could just remove them and rebuild.

If you are on Linux/Mac, you definitely need to remove a lot of the agent lines from the interface. When I have a linux agent that I like, as oppose to tolerate, I'll set up an alternative build for it.

It is possible to go to the GnuTutor/bin/Debug folder, run the executable there, and run GnuTutor. However, it is more likely that you will want to run it in Visual Studio in Debug mode if you want to understand what's going on in more detail. Visual Studio C# Express can be freely downloaded from Microsoft. Alternatively, you can download MonoDevelop for Linux/Mac or SharpDevelop for Windows. You can install one of these programs, double click on the Solution file in the GnuTutor source directory (*.sln), and run GnuTutor by pressing either F5 or the "Play" button (shaped like the play button on you VCR).

Finally, due to my unfortunate oversight, there is a typo in this first release in the gnututor.pl file in the Databases directory. You can fix this by making sure that the license statement at the top of the file has percent signs on the last two lines, or alternatively, you can look at the release notes for this release on the Sourceforge download page, which contains a corrected version of the file in the change log. You can copy/paste the correct version into the current file.

## How does it work?

The first thing you see when you start the program is the interface. Depending on the configuration, the agent could be one of 5 variants. In any case, the text entry box is the same. To start a conversation, type something in that box and press Enter.

What happens next is relatively straightforward. The interface passes the student input string to the Tutor and asks for a response in return. The Tutor consists of a series of modules, each of which operates on the output of the last, to generate the tutor response. This flow of work is organized around the State Table, a notion introduced in AutoTutor 3.0 and further refined here. The State Table consists of a set of attribute/value pairs representing all of the state used by the tutor in the session. What do I mean by state? Memory. All of the memory of the tutor, that which makes the current turn different from all other turns, is held in the state table. Thus the notion is not too dissimilar from the TrindiKit notion of information state. Moreover, you can recreate any point in the tutoring session based on just the last state table. Thus the state table is not only the object that all the modules in the Tutor operates on, it is also the perfect thing to log to the log files.

The state table is passed from module to module, ending with the dialogue management module. Any new module that you might want to add should follow the examples of the existing modules. Each module looks at the state table, operates on its data, and adds more information. For example, the language analysis module, which includes the tagger and speech act classifier, consults the student input, and returns a speech act classification tag. By the time the state table reaches the dialogue manager, it contains all of the information the dialogue manager should need to make a decision. Since the heart of the dialogue manager is written in Prolog, the state table is made available to Prolog via the mechanisms for this in tuProlog/2Prolog. In this way, the keys/values in the state table can be consulted by the Prolog rules. The dialogue manager's Prolog engine also has the ability (through tuProlog) to call methods in C# from Prolog. This substantially simplifies some aspects of the Prolog programming: the procedural aspects can be left to C#, and the remaining declarative dialogue logic can be left to Prolog.

Finally, the dialogue string returned by the dialogue manager is passed back to the interface and acted out by the agent.

## Cross platform

How do I use this on a non-Windows platform?

The GnuTutor source is all in C#, and so is inherently cross platform under Mono. There is no need to recompile (actually this is an over statement: I have some "easy" MS agents set up by default in the release, you need to comment these out and recompile for linux/osx), just run GnuTutor as you would any other program in Mono. However, GnuTutor can link to a variety of agents; these agents are not part of the GnuTutor source. Some of these work only with Windows (e.g. MSAgent and Haptek, though these might possibly run under Wine) others, such as XFace should run under Linux and OSX, but may require some additional tweaking, either in the configuration file or an actual cross compile.

The best way to proceed is in two stages. First, get GnuTutor running under Mono with no agent or voice (you can just pass the tutor's response back to the response box in the GUI). Once that works (it should be trivial), consult the documentation for using your desired agent technology on your platform of choice. In virtually all cases this will include both the agent and the speech engine; it may be easy for one and not the other. Currently the best open source, cross platform voices are in the Open Mary package https://mary.dfki.de/

Some example files for showing how to comment out MS stuff are below.

Interface.cs:

{% highlight csharp %}
﻿#region Copyright
/*
Copyright 2009 Andrew Olney

This file is part of GnuTutor.

GnuTutor is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

GnuTutor is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with GnuTutor.  If not, see <https://www.gnu.org/licenses/>.
*/
#endregion
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace GnuTutor
{
    public enum AgentType { Voice,MSAgent, Haptek, XFace, Greta };

    public partial class Interface : Form
    {        
        //Text to speech
//        public SpeechLib.SpVoice voice;

        //Dialogue engine
        private Dialogue dialogue;

        //Agent selection
        public AgentType agentType = AgentType.Haptek;
//        private AxACTIVEHAPTEKXLib.AxActiveHaptekX axActiveHaptekX1;
//        private AxAgentObjects.AxAgent axAgent1;
        private XFaceClient xface;
        private GretaClient greta;
		

        public Interface()
        {
            InitializeComponent();

            switch( this.agentType )
            {
                case AgentType.Voice:
//                    this.voice = new SpeechLib.SpVoice();
                    break;
                case AgentType.MSAgent:
//                    axAgent1.Characters.Load("Merlin", (object)"C:/Windows/Msagent/chars/merlin.acs");
//                    axAgent1.Characters["Merlin"].Show(null);
                    break;
                case AgentType.Haptek:
//                    axActiveHaptekX1.HyperText = @"\load[file=data/standard/standardStartup.hap]";
//                    axActiveHaptekX1.Query = "current position";
//                    string queryResponse = axActiveHaptekX1.QueryReturn;
                    break;
                case AgentType.XFace:
                    this.xface = new XFaceClient();
                    break;
                case AgentType.Greta:
                    this.greta = new GretaClient();
                    this.greta.Connect();
                    break;
            }

            this.dialogue = new Dialogue();
            this.dialogue.richTextBox1 = this.richTextBox1;
            this.dialogue.textBox3 = this.textBox3;
        }

        private void studentResponseButton_click(object sender, EventArgs e)
        {
            string tutorMove = "", studentMove = "";

            studentMove = this.studentResponseBox.Text;
            tutorMove = dialogue.GetMove(studentMove);

            //Do something with the agent
            switch (this.agentType)
            {
//                case AgentType.Voice:
//                    this.voice.Speak(tutorMove, SpeechLib.SpeechVoiceSpeakFlags.SVSFDefault);
//                    break;
//                case AgentType.MSAgent:
//                    axAgent1.Characters["Merlin"].Speak(tutorMove, null);
//                    break;
//                case AgentType.Haptek:
//                    axActiveHaptekX1.HyperText = tutorMove;
//                    break;
                case AgentType.XFace:
                    this.xface.SendText(tutorMove);
                    break;
                case AgentType.Greta:
                    this.greta.Speak(tutorMove);
                    dialogue.textBox3.Text = this.greta.lastSent;
                    break;
            }
           
        }
    }
 
}
{% endhighlight %}

Interface.Designer.cs

{% highlight csharp %}
﻿namespace GnuTutor
{
    partial class Interface
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Interface));
            this.button1 = new System.Windows.Forms.Button();
            this.studentResponseBox = new System.Windows.Forms.TextBox();
//            this.axActiveHaptekX1 = new AxACTIVEHAPTEKXLib.AxActiveHaptekX();
            this.textBox3 = new System.Windows.Forms.TextBox();
            this.richTextBox1 = new System.Windows.Forms.RichTextBox();
//            ((System.ComponentModel.ISupportInitialize)(this.axActiveHaptekX1)).BeginInit();
            this.SuspendLayout();
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(426, 428);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(75, 56);
            this.button1.TabIndex = 1;
            this.button1.Text = "Enter";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.studentResponseButton_click);
            // 
            // studentResponseBox
            // 
            this.studentResponseBox.Font = new System.Drawing.Font("Microsoft Sans Serif", 32F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.studentResponseBox.Location = new System.Drawing.Point(12, 428);
            this.studentResponseBox.Name = "studentResponseBox";
            this.studentResponseBox.Size = new System.Drawing.Size(397, 56);
            this.studentResponseBox.TabIndex = 2;
            // 
            // axActiveHaptekX1
            // 
//            this.axActiveHaptekX1.Enabled = true;
//            this.axActiveHaptekX1.Location = new System.Drawing.Point(13, 12);
//            this.axActiveHaptekX1.Name = "axActiveHaptekX1";
//            this.axActiveHaptekX1.OcxState = ((System.Windows.Forms.AxHost.State)(resources.GetObject("axActiveHaptekX1.OcxState")));
//            this.axActiveHaptekX1.Size = new System.Drawing.Size(488, 410);
//            this.axActiveHaptekX1.TabIndex = 3;
//            // 
            // textBox3
            // 
            this.textBox3.Location = new System.Drawing.Point(689, 12);
            this.textBox3.Multiline = true;
            this.textBox3.Name = "textBox3";
            this.textBox3.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.textBox3.Size = new System.Drawing.Size(233, 225);
            this.textBox3.TabIndex = 5;
            // 
            // richTextBox1
            // 
            this.richTextBox1.Location = new System.Drawing.Point(565, 259);
            this.richTextBox1.Name = "richTextBox1";
            this.richTextBox1.Size = new System.Drawing.Size(357, 225);
            this.richTextBox1.TabIndex = 6;
            this.richTextBox1.Text = "";
            // 
            // Interface
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(961, 496);
            this.Controls.Add(this.richTextBox1);
            this.Controls.Add(this.textBox3);
//            this.Controls.Add(this.axActiveHaptekX1);
            this.Controls.Add(this.studentResponseBox);
            this.Controls.Add(this.button1);
            this.Name = "Interface";
            this.Text = "GnuTutor.com";
//            ((System.ComponentModel.ISupportInitialize)(this.axActiveHaptekX1)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.TextBox studentResponseBox;
        //private AxACTIVEHAPTEKXLib.AxActiveHaptekX axActiveHaptekX1;
        private System.Windows.Forms.TextBox textBox3;
        private System.Windows.Forms.RichTextBox richTextBox1;
    }
}
{% endhighlight %}


## LSA

### Prepare Corpus

Conceptually, your corpus file should be a collection of text on whatever you domain is.

For example, if you are doing american history, you should use an american history textbook.

Format the corpus so there is one line per paragraph, with no blank lines b/w paragraphs.

Make sure you have at least 1 MB. More is better.

Also, to LSA "the" and "the." are 2 different words. If that matters to you, you might want to selectively strip punctuation. But beware of situations like didn't -> didn t

To do transformations like this, I like to use TextPad, which can lowercase an entire document in 1 step, as well as use regular expressions for character substitution.

The reason GnuTutor doesn't do these transformations automatically is that you might have different requirements depending on your domain.

Also note that whatever transformation you do here needs to be matched at runtime. For example, if you corpus contained "Abraham Lincoln", you lowercased it to "abraham lincoln", and at runtime the student types "Abraham Lincoln", then you have to lowercase what the student typed if you expect to find it in the corpus/LSA space

Put your corpus file and put it in the LSA/bin/debug directory


### Create Matrix

Run the LSA executable and follow the onscreen instructions

The octave part requires that you have octave installed. You need octave >= 3.0. Make sure you have both octave3.0 and octave3.0-headers,e.g. for ubuntu:

sudo apt-get octave3.0 octave3.0-headers

You also need to have Arpack installed

sudo apt-get install libsuitesparse-dev libarpack2-dev

You also need to install the arpack from octave forge.

https://downloads.sourceforge.net/octave/arpack-1.0.8.tar.gz?download

This is as easy as downloading the arpack package, opening a octave shell in that directory, and typing 'pkg install arpack-1.0.8.tar.gz'

When the LSA executable prompts you to run the octave script, you can type 'octave svds_oct $corpus_name.SPARSE $300' where $corpus_name should be replaced by the name of your corpus and $300 by the number of dimensions you want.

The process will create an LSA space object, serialized to file, that you can load and use. GnuTutor expects this file to be in the Databases directory. You may also need to change the config file if you decide you want a special name for your new space.





