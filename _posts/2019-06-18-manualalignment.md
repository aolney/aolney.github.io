---
layout: post
section-type: post
title: Manual Subtitle Speech Alignment
category: Category
tags: ['research','nlp','agents','discourse','fsharp']
---
I've been working on an automated approach to subitle alignment for the creation of [speech data for the deep learning of text to speech synthesis](https://github.com/aolney/SouthParkTTSData).

However, the resulting data isn't clean enough to create good quality TTS because it suffers from the following defects:

- Music/noise in the background
- Overlapping speech
- Clipped final word (e.g. ~100ms)
- Preceeding/following silence 
- Wrong speaker (rare)

To resolve these, I created a web-base UI with data preview/edit capabilities, similar to [finetuneas](https://github.com/ozdefir/finetuneas).
However, unlike that work, my program:

- Allows editing the transcript (i.e., does not assume it is correct)
- Allows rejection of utterances entirely, with rejection codes
- Supports a keyboard-oriented UI for faster review/correction
- Displays a waveform

The input to the program is required to be wav audio and json with the following format, where the times are in milliseconds:
``` javascript
[
  {
    "Start": 184170,
    "Stop": 184284,
    "Text": "YES, HE CAN!"
  }
]
```
The program [is available here](https://olney.ai/manual-subtitle-speech-alignment). It is all client-side, so there's no need to install it yourself.

The GitHub repository [is here](https://github.com/aolney/manual-subtitle-speech-alignment).

<iframe width="560" height="315" src="https://www.youtube.com/embed/mB0pBMFo6Sk" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
