//
//  KSThreadProxy.h
//
//  Copyright (c) 2008-2011, Mike Abdullah and Karelia Software
//  All rights reserved.
//  
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//      * Redistributions of source code must retain the above copyright
//        notice, this list of conditions and the following disclaimer.
//      * Redistributions in binary form must reproduce the above copyright
//        notice, this list of conditions and the following disclaimer in the
//        documentation and/or other materials provided with the distribution.
//  
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL MIKE ABDULLAH OR KARELIA SOFTWARE BE LIABLE FOR ANY
//  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//   LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//


#import <Foundation/Foundation.h>


@interface NSObject (KSThreadProxy)

//  Any messages sent to the returned proxy object are neatly forwarded onto the
//  real object using the desired thread. You'll even get the return value back properly.
//  For convenience, can specify nil to target the main thread.
//
//  Example:
//  NSString *foo = [[self ks_proxyOnThread:nil] foo];
//  
- (id)ks_proxyOnThread:(NSThread *)thread;

//  The default behaviour is to wait until done so that return values can be used. If
//  targetting a void returning method (or method whose result you don't care about), can
//  turn off waitUntilDone to avoid blocking.
- (id)ks_proxyOnThread:(NSThread *)thread waitUntilDone:(BOOL)waitUntilDone;

@end


// Just for fun, a macro that gives you a proxy to NSWorkspace on the main thread
#define KSWORKSPACETHREADPROXY [[[NSWorkspace ks_proxyOnThread:nil] sharedWorkspace] ks_proxyOnThread:nil]
