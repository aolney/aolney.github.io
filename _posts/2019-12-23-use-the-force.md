---
layout: post
section-type: post
title: Use the F#orce
category: Category
tags: ['service','demo','hardware','outreach','fsharp']
---
<blockquote>
  <p>Any sufficiently advanced technology is indistinguishable from magic.</p>
  <footer>Arthur C. Clarke, <cite>Profiles of the Future</cite></footer>
</blockquote>

In this [FsAdvent](https://sergeytihon.com/tag/fsadvent/) post, I will show you how to **move a ball with the power of your mind**.

Since this is science, the [ball is a robot](https://en.wikipedia.org/wiki/Sphero), the power of your mind [is measured with EEG](https://en.wikipedia.org/wiki/NeuroSky), and everything is glued together using F#/[Fable](https://fable.io/).

Let's get started!

&nbsp;
## History

My inspiration for this project was *BrainBall* at [Wired NextFest 2005](https://www.wired.com/2005/06/nextfest/).
In that game, two players wear EEG in a kind of tug of war to move a metal ball into their opponent's goal.
Here's the kicker: you win by **relaxing**.
The more excited you get, the more you lose!

In 2011 came the Sphero robot and Neurosky MindSet; I think both were about $100.
I very quickly put together the first version of the demo described in this post using Visual Studio, C#, the .NET SDKs provided by Sphero and Neurosky, and MVVM.
And I used this demo at an outreach event I've been doing for some years called [Geek101](https://olney.ai/tags/geek101.html).

However, sometime around Windows 10, it just stopped working reliably.
I'm not sure what happened really, but I decided I'd rather make the demo cross platform using Fable than try to figure out what was going wrong.

Here's the end goal:

<iframe width="560" height="315" src="https://www.youtube.com/embed/S2VGBZl17N4" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

&nbsp;
## Design

The first important thing to know about these devices is that they communicate using Bluetooth.
While it might be possible to get this to work in some browsers, I decided to use [Electron](https://electronjs.org/) to help future proof things against any changes browsers might make in the name of security.
If you haven't heard of Electron, it uses Chromium/Node to effectively present a web application as a desktop application.
That means a desktop application security model rather than a web application security model, which is ideal for this project.

Fable [has bindings for Electron](https://github.com/fable-compiler/fable-electron), so in much the same way that one can create web apps with F# using Fable, one can create Electron apps.
And even better, one of the contributors to that repo [has created a nice Electron demo app](https://github.com/cmeeren/fable-elmish-electron-material-ui-demo) with FAKE build scripts and Electron deployment/installer scripts.
This is the overall environment I used to create the demo.
The only major change I made was replacing [Material UI](https://material-ui.com/) with [Fulma](https://fulma.github.io/Fulma/) and simplifying the application down to the bare minimum using [Elmish](https://elmish.github.io/elmish/) for Model-View-Update.

&nbsp;
## Development

### Getting the devices ready

Let's start with the devices.
Both are using a serial over Bluetooth protocol.
On Ubuntu 18.04 LTS and Node 10, it takes a bit of love to get them going.
You can [see the repo](https://github.com/aolney/sphero-mindwave-demo) for the detailed steps, but the basic idea is that you need to give yourself permissions to use those ports, get the device ids for the devices, and then connect to the devices over those ports [using rfcomm](https://en.wikipedia.org/wiki/List_of_Bluetooth_protocols#Radio_frequency_communication_(RFCOMM)).
While rustic, this approach has the advantage that you know exactly where things are breaking when they break.

### Communicating with the devices

Since we are speaking over emulated serial ports, we need to know how to package commands for the devices/receive data from the devices over the wire.

**Good news**: there is a neat project called [cylon.js](https://cylonjs.com/) that knows how to talk to both devices!

**Bad news**: cylon.js [hasn't released a new NPM package in 4 years](https://www.npmjs.com/package/cylon)!

As we all know, time in NPM is exponential in dog years, which means **our top choice library is about 16,384 years old.**

Part of this post is about how to commune with the ancients.
Let's start with `package.json` and work backward.

A regular usage of `cylon.js` for these devices would require three packages: `cylon`, `cylon-neurosky`, and `cylon-sphero`.
It turns out that `cylon` was OK, but I had to create forks for [cylon-neurosky](https://github.com/aolney/cylon-neurosky) and [cylon-sphero](https://github.com/aolney/cylon-sphero) in order to bump outdated packages.
`cylon-sphero` also depends on [sphero.js, which also had to be forked to bump dependencies and make API changes.](https://github.com/aolney/sphero.js)

I learned a couple of cool tricks along the way.
First, there's a cool little NPM org called `abandonware` that is taking abandoned packages and keeping them up to date.
Don't get too excited: it's small, but I hope the idea takes off.
Second, [you can use GitHub instead of NPM](https://glebbahmutov.com/blog/use-github-instead-of-npm/), which is great if you need to fork old packages but don't want to distribute them.
The aforementioned packages therefore show up in my `packages.json` as

```
    "cylon-neurosky": "github:aolney/cylon-neurosky#1.0.1",
    "cylon-sphero": "github:aolney/cylon-sphero#1.0.1",
```
and I call `npm install` in the regular way to build the dependencies. Nice!

&nbsp;
## Code

Things are pretty straightforward.
We have the Elmish GUI and the Cylon interop.
This is the UI the code presents:

![screenshot of demo interface](https://cpb-us-w2.wpmucdn.com/blogs.memphis.edu/dist/d/2954/files/2019/12/sphero-mindwave-demo-screenshot-web.png)

The main elements:

- Inputs for port numbers
- Button to connect
- Display of meditation value (from EEG)

### The UI

Following the Elmish or the MVU style we have:

<p></p>
#### Model

This is how we represent the state of the application.

```
type Model =
  {
    NeuroskyPort : string
    SpheroPort : string
    Meditation : float
  }
```

<p></p>
#### Update

We receive messages from the View and create a new Model.

```
type Msg =
  | Connect
  | UpdateNeuroskyPort of string
  | UpdateSpheroPort of string
  | Meditation of float

let update msg model =
  match msg with
  | Connect ->
    Cylon.Connect model.NeuroskyPort model.SpheroPort
    model, Cmd.none
  | UpdateNeuroskyPort port ->
    {model with NeuroskyPort = port},Cmd.none
  | UpdateSpheroPort port ->
    {model with SpheroPort = port},Cmd.none
  | Meditation m ->
    {model with Meditation = m},Cmd.none
```

<p></p>
#### View

This is the most complex part for us because we are using React and Fulma with a fair number of elements.
The canonical structure for the React DSL is the name of the element, a list of properties, and a list of children.
For the text inputs, we have `OnChange` handlers that send messages to Update, and similarly the button has an `OnClick` handler.

Let's hit a few highlights.
The view uses the [new React 5 FunctionComponent](https://fable.io/blog/Announcing-Fable-React-5.html).
The cat corner is [a lovely animation](https://tholman.com/github-corners/) that I couldn't resist adding; it also gave me the chance to `DangerouslySetInnerHTML`, which has been on my bucket list.
Finally, you might have noticed `|> Program.withSubscription mapEventSubscription`.
[As I discussed last year](https://olney.ai/category/2018/12/02/fabletekno.html), Elmish allows [subscriptions to external events](https://elmish.github.io/elmish/subscriptions.html) that you can [more generically map to events](https://github.com/elmish/elmish/issues/127) and convert any event to an Elmish message.
Why this is needed is about to become apparent.

```
/// https://tholman.com/github-corners/
let catCorner = "<a href='https://github.com/aolney/sphero-mindwave-demo' class='github-corner' aria-label='View source on GitHub'><svg width='80' height='80' viewBox='0 0 250 250' style='fill:#151513; color:#fff; position: absolute; top: 0; border: 0; right: 0;' aria-hidden='true'><path d='M0,0 L115,115 L130,115 L142,142 L250,250 L250,0 Z'></path><path d='M128.3,109.0 C113.8,99.7 119.0,89.6 119.0,89.6 C122.0,82.7 120.5,78.6 120.5,78.6 C119.2,72.0 123.4,76.3 123.4,76.3 C127.3,80.9 125.5,87.3 125.5,87.3 C122.9,97.6 130.6,101.9 134.4,103.2' fill='currentColor' style='transform-origin: 130px 106px;' class='octo-arm'></path><path d='M115.0,115.0 C114.9,115.1 118.7,116.5 119.8,115.4 L133.7,101.6 C136.9,99.2 139.9,98.4 142.2,98.6 C133.8,88.0 127.5,74.4 143.8,58.0 C148.5,53.4 154.0,51.2 159.7,51.0 C160.3,49.4 163.2,43.6 171.4,40.1 C171.4,40.1 176.1,42.5 178.8,56.2 C183.1,58.6 187.2,61.8 190.9,65.4 C194.5,69.0 197.7,73.2 200.1,77.6 C213.8,80.2 216.3,84.9 216.3,84.9 C212.7,93.1 206.9,96.0 205.4,96.6 C205.1,102.4 203.0,107.8 198.3,112.5 C181.9,128.9 168.3,122.5 157.7,114.1 C157.9,116.9 156.7,120.9 152.7,124.9 L141.0,136.5 C139.8,137.7 141.6,141.9 141.8,141.8 Z' fill='currentColor' class='octo-body'></path></svg></a><style>.github-corner:hover .octo-arm{animation:octocat-wave 560ms ease-in-out}@keyframes octocat-wave{0%,100%{transform:rotate(0)}20%,60%{transform:rotate(-25deg)}40%,80%{transform:rotate(10deg)}}@media (max-width:500px){.github-corner:hover .octo-arm{animation:none}.github-corner .octo-arm{animation:octocat-wave 560ms ease-in-out}}</style>"

let RootView = FunctionComponent.Of((fun (model, dispatch) ->
  div [] [
    div[ DangerouslySetInnerHTML { __html = catCorner } ] [ ]
    Section.section [] [
      Container.container [ Container.IsFluid ] [
        Heading.h2 [ ] [ str "Sphero Mindwave Demo"]
        Content.content [ ] [
          p [] [ str "This app demonstrates simple control for a Sphero robot using a Neurosky EEG. Click on the cat in the corner for more information." ]
        ]
        Columns.columns [] [
          Column.column [ Column.Width  (Screen.All, Column.IsOneThird )  ] [
            Label.label [ ] [ str "Meditation level" ]
            Box.box'[] [
              Label.label[ Label.Size IsLarge ] [
                 model.Meditation.ToString() |> str
              ]
            ]
          ]
          Column.column [ Column.Width  (Screen.All, Column.IsOneThird )  ] [
            Field.div [ ] [
              Label.label [ ] [ str "Neurosky EEG port" ]
              Control.div [  ] [
                Input.text [
                  // Input.Color IsPrimary
                  Input.IsRounded
                  Input.Placeholder "/dev/rfcomm1"
                  Input.Value ( model.NeuroskyPort.ToString() )
                  Input.Props [ OnChange (fun ev ->  !!ev.target?value |> UpdateNeuroskyPort|> dispatch ) ]
                ]
              ]
            ]
            Field.div [ ] [
              Label.label [ ] [ str "Sphero EEG port" ]
              Control.div [  ] [
                Input.text [
                  // Input.Color IsPrimary
                  Input.IsRounded
                  Input.Placeholder "/dev/rfcomm0"
                  Input.Value ( model.SpheroPort.ToString() )
                  Input.Props [ OnChange (fun ev ->  !!ev.target?value |> UpdateSpheroPort|> dispatch ) ]
                ]
              ]
            ]
            Button.button [
              Button.Color IsPrimary
              Button.OnClick (fun _ -> dispatch Connect )
            ] [ str "Connect" ]
          ]
        ]
      ]
    ]
  ]
), "RootView", memoEqualsButFunctions)

let view model dispatch =
  RootView (model, dispatch)

Program.mkProgram init update view
|> Program.withSubscription mapEventSubscription
// |> Program.withDebugger
|> Program.withReactSynchronous "app"
|> Program.run
```

<p></p>
### The interop

`cylon` essentially works by passing in a giant configuration object and then saying "go."
So most of the interop focuses on this configuration object.
Fable offers multiple ways to do interop with Javascript.
Here we will use three: `Emit`, which allows us to directly emit Javascript; `foreign interfaces`, which allow us to import Javascript but wrap it in a type; and the dynamic operator `?` that compiles to "." but won't throw a static type check error during compile.
The way I've done this isn't necessarily the best/prettiest approach, but it's certainly the simplest for the minimal usage we need in the API.

Let's start with the configuration object, where we use `Emit` and `?`.

[Emit](https://fable.io/docs/communicate/js-from-fable.html#Emit-when-F-is-not-enough) renders the quoted code, with argument substitution, wherever the corresponding F# function is called.

The `inline` operators are sugar for creating a plain old javascript object (POJO), which as you can see, is fairly deeply nested.

The `Connect` function takes the port values from our model and places them into the POJO.
The most interesting part then the `work` function.
This is where we are catching the `meditation` event from the Neurosky, where
[meditation is a 0 to 100 value of calmness](https://neurosky.com/biosensors/eeg-sensor/algorithms/).
This value is written to console for debugging and converted into a message through MapEvent, which Update then uses to display the meditation value in the View.
When the meditation value is above a threshold of 70, the color of the Sphero is set to green, and it is given a roll command.
Otherwise it is given a color correlated with the meditation value (a kind of pulsing maroon) and given a stop command.
All of the commands are given using the dynamic `?` operator.

```
let inline (!!) x = createObj x
let inline (=>) x y = x ==> y

[<Emit("every($0,$1)")>]
let every( o : obj, o2:obj ) : unit = jsNative

[<Emit("(1).second()")>]
let oneSecond : obj = jsNative

let Connect neuroskyPort spheroPort =
    let cylonConfig =
        !! [
            "connections" =>
                !! [
                    "neurosky" =>
                        !! [
                            "adaptor" => "neurosky"
                            //can be on any rfcomm as long as channel is 1
                            "port" => neuroskyPort
                        ]
                    "sphero" =>
                        !! [
                            "adaptor" => "sphero"
                            //can be on any rfcomm as long as channel is 1
                            "port" => spheroPort
                        ]
                ]
            "devices" =>
                !! [
                    "headset" =>
                        !! [
                            "driver" => "neurosky"
                        ]
                    "sphero" =>
                        !! [
                            "driver" => "sphero"
                            "connection" => "sphero"
                        ]
                ]
            "work" => fun my -> my?headset?on("meditation", fun (data : int) ->
                Browser.Dom.console.log("meditation:" + data.ToString() )
                let meditation = data |> float
                MapEvent.mapEvent.Trigger ( Meditation meditation)
                if meditation > 70.0 then
                    my?sphero?color("green")
                    my?sphero?roll(60,0);
                else
                    my?sphero?color(
                        !! [
                            "red" => (meditation / 100.0) * 255.0
                            "blue" => (100.0 - meditation / 100.0) * 255.0
                            "green" => 0
                        ]
                    )
                    my?sphero?stop()
                )
        ]
```

The code that passes the configuration object to `cylon` uses a foreign interface:

```
type [<AllowNullLiteralAttribute>] Robot =
    abstract start : unit -> Robot

type [<AllowNullLiteralAttribute>] Cylon =
    abstract robot  : obj -> Robot

[<Import("*","cylon")>]
let cylon : Cylon = jsNative

...

cylon.robot(cylonConfig).start() |> ignore
```

The interface specifies that `Cylon` has a `Robot` that can `start`.
Once we have that, we can `Import` the `cylon` library, create the eponymous variable `cylon`, and call `start` using the configuration object.
This is about the simplest foreign interface I've ever seen :).

What about `MapEvent` you say? Well, here it is:

```
///External event wrapping a message
let mapEvent = Event<Msg>()
///Subscription on external events to bring them into Elmish message queue
let mapEventSubscription initial =
    let sub dispatch =
        let msgSender msg =
            msg
            |> dispatch

        mapEvent.Publish.Add(msgSender)

    Cmd.ofSub sub
```

&nbsp;
## Wrapping up

I hope you've enjoyed this post!
If you haven't tried Fable, I hope I've encouraged you to [give it a shot](https://github.com/kunjee17/awesome-fable).
