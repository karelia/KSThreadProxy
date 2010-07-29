//
//  KSThreadProxy.h
//  Marvel
//
//  Created by Mike Abdullah on 14/10/2008.
//  Copyright 2008-2010 Karelia Software. All rights reserved.
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

