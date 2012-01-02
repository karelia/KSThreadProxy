//
//  KSPerformOnThreadOperation.m
//  Sandvox
//
//  Created by Mike on 02/07/2011.
//  Copyright 2011-2012 Karelia Software. All rights reserved.
//

#import "KSPerformOnThreadOperation.h"

#import "KSThreadProxy.h"


@implementation KSPerformOnThreadOperation

static void *sIsReadyObservationContext = &sIsReadyObservationContext;

- (id)initWithOperation:(NSOperation *)operation thread:(NSThread *)thread;
{
    OBPRECONDITION(operation);
    
    if (self = [self init])
    {
        _operation = [operation retain];
        _thread = [_thread retain];
        
        [_operation addObserver:self
                     forKeyPath:@"isReady"
                        options:NSKeyValueObservingOptionPrior
                        context:sIsReadyObservationContext];
    }
    
    return self;
}

- (void)dealloc
{
    [_operation removeObserver:self forKeyPath:@"isReady"];
    
    [_operation release];
    [_thread release];
    
    [super dealloc];
}

@synthesize targetOperation = _operation;

- (void)main
{
    [(NSOperation *)[_operation ks_proxyOnThread:_thread waitUntilDone:NO] start];
}

#pragma mark Readiness

- (BOOL)isReady
{
    return [super isReady] && [_operation isReady];
}
+ (NSSet *)keyPathsForValuesAffectingIsReady;
{
    NSSet *result = [NSSet setWithObject:@"targetOperation.isReady"];
    
    if ([NSOperation respondsToSelector:_cmd])
    {
        result = [result setByAddingObjectsFromSet:[NSOperation performSelector:_cmd]];
    }
    
    return result;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
{
    if (context == sIsReadyObservationContext)
    {
        if ([[change objectForKey:NSKeyValueChangeNotificationIsPriorKey] boolValue])
        {
            [self willChangeValueForKey:@"isReady"];
        }
        else
        {
            [self didChangeValueForKey:@"isReady"];
        }
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
