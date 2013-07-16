//
//  KSThreadProxy.h
//
//  Created by Mike Abdullah
//  Copyright © 2008 Karelia Software
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
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


#ifdef NS_BLOCKS_AVAILABLE
@interface NSThread (KSThreadProxy)

// Like dispatch_async and dispatch_sync, but copes with the current thread being the same as the one targeted
// Think of it is as a modern equivelant to -performSelector:onThread:withObject:waitUntilDone:
- (void)ks_performBlock:(void (^)())block;
- (void)ks_performBlockAndWait:(void (^)())block;

// As above, but allowing the caller to specify the run mode to run on.
- (void)ks_performUsingMode:(NSString*)mode block:(void (^)(void))block;
- (void)ks_performAndWaitUsingMode:(NSString*)mode block:(void (^)(void))block;

// As above, but allowing multiple run modes
- (void)ks_performUsingModes:(NSArray*)modes block:(void (^)(void))block;
- (void)ks_performAndWaitUsingModes:(NSArray*)modes block:(void (^)(void))block;

@end
#endif
