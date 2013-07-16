Features
========

KSThreadProxy provides a few convenient means of executing code on a different thread to the current one, both for pre and post-block worlds.

To send a message to an object on a different thread:

    [[object ks_proxyOnThread:thread] doThing];

Note that you can pass nil to automatically target the main thread. The call is blocking so that you even receive the return value back properly. Alternatively, `ks_proxyOnThread:waitUntilDone:` is available to explicitly do the work asynchronously.

`dispatch_sync` has one annoyance: it deadlocks when used by a serial queue to target itself. KSThreadProxy adds a handful of convenience methods for bouncing blocks over to specific threads, in a non-deadlocking fashion, such as `-[NSThread ks_performBlockAndWait:]`

Contact
=======

I'm Mike Abdullah, of [Karelia Software](http://karelia.com). [@mikeabdullah](http://twitter.com/mikeabdullah) on Twitter.

Questions about the code should be left as issues at https://github.com/karelia/KSThreadProxy or message me on Twitter.

Dependencies
============

None beyond Foundation. Works back to OS X v10.5 for the actual thread proxy. Compiler support for blocks is required for methods that use them, which in practice means OS X v10.6.

License
=======

Copyright © 2008 Karelia Software

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

Usage
=====

Add `KSThreadProxy.h` and `KSThreadProxy.m` to your project. Ideally, make this repo a submodule, but hey, it's your codebase, do whatever you feel like.
