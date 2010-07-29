//
//  KSThreadProxy.m
//  Marvel
//
//  Created by Mike on 14/10/2008.
//  Copyright 2008-2009 Karelia Software. All rights reserved.
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


