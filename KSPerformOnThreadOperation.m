//
//  KSPerformOnThreadOperation.m
//  Sandvox
//
//  Created by Mike on 02/07/2011.
//  Copyright © 2011 Karelia Software
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
