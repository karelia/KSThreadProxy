//
//  KSPerformOnThreadOperation.h
//  Sandvox
//
//  Created by Mike on 02/07/2011.
//  Copyright 2011 Karelia Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface KSPerformOnThreadOperation : NSOperation
{
@private
    NSOperation *_operation;
    NSThread    *_thread;
}

// Thread may be nil to signify main
- (id)initWithOperation:(NSOperation *)operation thread:(NSThread *)thread;

@property(nonatomic, retain, readonly) NSOperation *targetOperation;

// A KSPerformOnThreadOperation is only ready once the operation it contains is
- (BOOL)isReady;

@end
