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

Licensed under the BSD License <http://www.opensource.org/licenses/bsd-license>
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Usage
=====

Add `KSThreadProxy.h` and `KSThreadProxy.m` to your project. Ideally, make this repo a submodule, but hey, it's your codebase, do whatever you feel like.
