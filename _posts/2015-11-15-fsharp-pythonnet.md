---
layout: post
section-type: post
title: Calling NLTK from F# Using PythonNet
category: Category
tags: [ 'research', 'fsharp','nlp' ]
---
<!-- Place this tag in your head or just before your close body tag. -->
<!-- <script type="text/javascript" src="https://apis.google.com/js/plusone.js"></script> -->

<!-- Place this tag where you want the widget to render. -->
<!-- <div class="g-post" data-href="https://plus.google.com/115988942600478124988/posts/YezaJi4mPug"></div> -->

*Post reconstructed from Google Plus*

You can use PythonNet with the dynamic keyword as described [here](https://github.com/tonyroberts/pythonnet) , but in F# you can make this a bit nicer using  FSharp.Interop.Dynamic from Nuget. The trick is to install the develop branch of PythonNet (with PYTHON34 defined in project options), the 3.4 CPython and NLTK for Windows as described [here](https://www.nltk.org/install.html) and reference the PythonNet and nuget package in an F# console app. The Nuget allows you to use "?" for the dynamic (late binding) calls. The only thing I can't get to work is the numpy array. Also it seems that when multiple "?" are used in the same line, breakpoints time out by the time evaluation hits them. Thus the printfns for output.

```
open Python.Runtime
open FSharp.Interop.Dynamic
open System.Collections.Generic


[<EntryPoint>]
let main argv =
    //set up for garbage collection?
    use gil = Py.GIL()

    //-----
    //NUMPY
    //import numpy
    let np = Py.Import("numpy")

    //call a numpy function dynamically
    let sinResult = np?sin(5)
    
    //make a python list the hard way
    let list = new Python.Runtime.PyList()
    list.Append( new PyFloat(4.0) )
    list.Append( new PyFloat(5.0) )

    //run the python list through np.array dynamically
    let a = np?array( list )
    let sumA = np?sum(a)

    //again, but use a keyword to change the type
    let b = np?array( list, Py.kw("dtype", np?int32 ) )
    let sumAB = np?add(a,b)

    let SeqToPyFloat ( aSeq : float seq ) =
        let list = new Python.Runtime.PyList()
        aSeq |> Seq.iter( fun x -> list.Append( new PyFloat(x)))
        list

    //Worth making some convenience functions (see below for why)
    let a2 = np?array( [|1.0;2.0;3.0|] |> SeqToPyFloat )

    //--------------------
    //Problematic cases: these run but don't give good results
    //make a np.array from a generic list
    let list2 = [|1;2;3|] |> ResizeArray
    let c = np?array( list2 )
    printfn "%A" c //gives type not value in debugger

    //make a np.array from an array
    let d = np?array( [|1;2;3|] )
    printfn "%A" d //gives type not value in debugger

    //use a np.array in a function
    let sumD = np?sum(d)  //gives type not value in debugger
    //let sumCD = np?add(d,d) // this will crash

    //can't use primitive f# operators on the np.arrays without throwing an exception; seems to work in c#
    //https://github.com/tonyroberts/pythonnet //develop branch
    //let e = d + 1

    //-----
    //NLTK
    //import nltk
    let nltk = Py.Import("nltk")
    let sentence = "I am happy"
    let tokens = nltk?word_tokenize(sentence)
    let tags = nltk?pos_tag(tokens)

    let taggedWords = nltk?corpus?brown?tagged_words()
    let taggedWordsNews = nltk?corpus?brown?tagged_words(Py.kw("categories", "news") )
    printfn "%A" taggedWordsNews

    let tlp = nltk?sem?logic?LogicParser(Py.kw("type_check",true))
    let parsed = tlp?parse("walk(angus)")
    printfn "%A" parsed?argument

    0 // return an integer exit code
```