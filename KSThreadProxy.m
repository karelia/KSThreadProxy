//
//  KSThreadProxy.m
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


#import "KSThreadProxy.h"


@interface KSThreadProxy : NSProxy
{
@private
    id          _target;
    NSThread    *_thread;
    BOOL        _waitUntilDone;
}

- (id)initWithTarget:(id)target
              thread:(NSThread *)thread
       waitUntilDone:(BOOL)waitUntilDone;

@end


@interface NSInvocation (KSThreadProxyAdditions)
- (void)ks_invokeWithTargetAndReportExceptions:(id)target;
@end


@implementation KSThreadProxy

- (id)initWithTarget:(id)target
              thread:(NSThread *)thread
       waitUntilDone:(BOOL)waitUntilDone;

{
    NSParameterAssert(target);
    NSParameterAssert(thread);
    
    _target = [target retain];
    _thread = [thread retain];
    _waitUntilDone = waitUntilDone;
    
    return self;
}

- (void)dealloc
{
    [_target release];
    [_thread release];
    
    [super dealloc];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature *result = [_target methodSignatureForSelector:aSelector];
    return result;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    [anInvocation retainArguments];
    
    [anInvocation performSelector:@selector(ks_invokeWithTargetAndReportExceptions:)
                         onThread:_thread
                       withObject:_target
                    waitUntilDone:_waitUntilDone];
}

@end


@implementation NSInvocation (KSThreadProxyAdditions)

/*  We perform our own exception handling as by default -performSelectorOnMainThread:
 *  does nothing more than log exceptions.
 */
- (void)ks_invokeWithTargetAndReportExceptions:(id)target
{
	@try
    {
        [self invokeWithTarget:target];
        [self retainArguments];
    }
    @catch (NSException *exception)
    {
        [NSApp reportException:exception];
    }
}

@end


#pragma mark -


@implementation NSObject (KSThreadProxy)

/*  If the specified thread and the current thread are the same, returns self without
 *  creating a proxy object.
 *  For convenience, you can use nil to represent the main thread.
 */
- (id)ks_proxyOnThread:(NSThread *)thread
{
    return [self ks_proxyOnThread:thread waitUntilDone:YES];
}

- (id)ks_proxyOnThread:(NSThread *)thread waitUntilDone:(BOOL)waitUntilDone;
{
    if (!thread) thread = [NSThread mainThread];
    
    id result;
    if (thread == [NSThread currentThread])
    {
        result = self;
    }
    else
    {
        result = [[[KSThreadProxy alloc] initWithTarget:self
                                                 thread:thread
                                          waitUntilDone:waitUntilDone] autorelease];
    }
    
    return result;
}

@end


#pragma mark - 


#ifdef NS_BLOCKS_AVAILABLE
@implementation NSThread (KSThreadProxy)

- (void)ks_performBlock:(void (^)())block;
{
    NSOperation *op = [NSBlockOperation blockOperationWithBlock:block];
    [op performSelector:@selector(start) onThread:self withObject:nil waitUntilDone:NO];
}

- (void)ks_performBlockAndWait:(void (^)())block;
{
    NSOperation *op = [NSBlockOperation blockOperationWithBlock:block];
    [op performSelector:@selector(start) onThread:self withObject:nil waitUntilDone:YES];
}

- (void)ks_performUsingMode:(NSString*)mode block:(void (^)(void))block
{
    NSOperation *op = [NSBlockOperation blockOperationWithBlock:block];
    [op performSelector:@selector(start) onThread:self withObject:nil waitUntilDone:NO modes:[NSArray arrayWithObject:mode]];
}

- (void)ks_performAndWaitUsingMode:(NSString*)mode block:(void (^)(void))block
{
    NSOperation *op = [NSBlockOperation blockOperationWithBlock:block];
    [op performSelector:@selector(start) onThread:self withObject:nil waitUntilDone:YES modes:[NSArray arrayWithObject:mode]];
}

- (void)ks_performUsingModes:(NSArray*)modes block:(void (^)(void))block
{
    NSOperation *op = [NSBlockOperation blockOperationWithBlock:block];
    [op performSelector:@selector(start) onThread:self withObject:nil waitUntilDone:NO modes:modes];
}

- (void)ks_performAndWaitUsingModes:(NSArray*)modes block:(void (^)(void))block
{
    NSOperation *op = [NSBlockOperation blockOperationWithBlock:block];
    [op performSelector:@selector(start) onThread:self withObject:nil waitUntilDone:YES modes:modes];
}

@end
#endif

