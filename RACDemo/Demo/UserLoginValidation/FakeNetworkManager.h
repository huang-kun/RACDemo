//
//  FakeNetworkManager.h
//  WeiboStream
//
//  Created by huang-kun on 16/8/11.
//  Copyright © 2016年 huang-kun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;

@interface FakeNetworkManager : NSObject

- (RACSignal *)submitSignalForUsername:(NSString *)username
                              password:(NSString *)password;

@end
