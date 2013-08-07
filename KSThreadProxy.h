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

/**
 Creates a proxy for the receiver that executes messages on a given thread.
 
 Message forwarding is performed synchronously so the proxy will given correct
 return values.
 
 @param thread The thread to forward messages onto. Use `nil` as a convenience for the main thread.
 @return A proxy for the receiver that forwards messages onto `thread`.
*/
- (instancetype)ks_proxyOnThread:(NSThread *)thread;

/**
 Creates a proxy for the receiver that executes messages on a given thread.
 
 Behaves the same as `-ks_proxyOnThread:` unless `waitUntilDone` is `NO`. In
 which case, message forwarding becomes asynchronous, and all messages sent to
 the proxy should have their return vaue ignored.
 
 @param thread The thread to forward messages onto. Use `nil` as a convenience for the main thread.
 @param waitUntilDone `YES` for synchronous message forwarding; `NO` for asynchronous.
 @return A proxy for the receiver that forwards messages onto `thread`.
 */
- (instancetype)ks_proxyOnThread:(NSThread *)thread waitUntilDone:(BOOL)waitUntilDone;

@end


// Just for fun, a macro that gives you a proxy to NSWorkspace on the main thread
#define KSWORKSPACETHREADPROXY [[[NSWorkspace ks_proxyOnThread:nil] sharedWorkspace] ks_proxyOnThread:nil]


#ifdef NS_BLOCKS_AVAILABLE
@interface NSThread (KSThreadProxy)

// Like dispatch_async and dispatch_sync, but copes with the current thread being the same as the one targeted
// Think of it is as a modern equivalent to -performSelector:onThread:withObject:waitUntilDone:

/**
 Asynchronously performs a block on the receiving thread.
 
 @param block The block to perform.
 */
- (void)ks_performBlock:(void (^)())block __attribute((nonnull(1)));

/**
 Synchronously performs a block on the receiving thread.
 
 Unlike `dispatch_sync`, copes with the current thread being the same as the one
 targeted, but immediately executing the block.
 
 @param block The block to perform.
 */
- (void)ks_performBlockAndWait:(void (^)())block __attribute((nonnull(1)));

// As above, but allowing the caller to specify the run mode to run on.
- (void)ks_performUsingMode:(NSString*)mode block:(void (^)(void))block __attribute((nonnull(2)));
- (void)ks_performAndWaitUsingMode:(NSString*)mode block:(void (^)(void))block __attribute((nonnull(2)));

// As above, but allowing multiple run modes
- (void)ks_performUsingModes:(NSArray*)modes block:(void (^)(void))block __attribute((nonnull(2)));
- (void)ks_performAndWaitUsingModes:(NSArray*)modes block:(void (^)(void))block __attribute((nonnull(2)));

@end
#endif
