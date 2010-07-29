//
//  KSThreadProxy.h
//  Marvel
//
//  Created by Mike on 14/10/2008.
//  Copyright 2008-2009 Karelia Software. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (KSThreadProxy)
- (id)ks_proxyOnThread:(NSThread *)thread;
- (id)ks_proxyOnThread:(NSThread *)thread waitUntilDone:(BOOL)waitUntilDone;
@end

