//
//  FakeNetworkManager.m
//  WeiboStream
//
//  Created by huang-kun on 16/8/11.
//  Copyright © 2016年 huang-kun. All rights reserved.
//

#import "FakeNetworkManager.h"

@implementation FakeNetworkManager

- (RACSignal *)submitSignalForUsername:(NSString *)username
                              password:(NSString *)password {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@(1)];
            [subscriber sendCompleted];
        });
        
        return nil;
    }];
}

- (void)dealloc {
    NSLog(@"%@ deallocated.", self);
}

@end
