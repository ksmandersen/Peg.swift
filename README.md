# Peg.swift

Peg.swift is an implementation of [Parsing Expression Grammar](http://en.wikipedia.org/wiki/Parsing_expression_grammar) written in Swift. Peg.swift is a port of [peg.rb](https://github.com/keleshev/peg.rb) for Ruby by [Vladimir Keleshev](http://twitter.com/kelesehev/).

## Status
50% of the way to 0.1 

```
[=========_________]
```

## Usage

TBD

## How to Install Peg.swift

> This module is beta software. It currently supports Xcode 6.1

There is only one recommended way to install PEG.swift as of now, which is by cloning the repo and adding the ``Peg.xcodeproj`` to your own project. Sadly there is no support for Swift frameworks in CocoaPods yet.

### 1. Clone the PEG.swift repository

```
git clone git@github.com:ksmandersen/Peg.swift.git Vendor/Peg.swift
```

### 2. Add ``Peg.xcodeproj`` to your project

Right-click on the group containing your application in Xcode and select ``Add Files To YourApp...``.

Then select ``Peg.xcodeproj``, which you downloaded in step 1.

Once you've added the Peg project, you should see it in Xcode's project navigator.

### 3. Link ``Peg.framework``

Link the ``Peg.framework`` in your application target's ``Link Binary with Libraries`` build phase.
