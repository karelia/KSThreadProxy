//
//  KSThreadProxy.m
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

/*  If the specified thead and the current thread are the same, returns self without
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


