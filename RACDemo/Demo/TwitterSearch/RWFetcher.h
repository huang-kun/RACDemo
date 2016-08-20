//
//  RWFetcher.h
//  RACDemo
//
//  Created by huang-kun on 16/8/13.
//  Copyright © 2016年 huang-kun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;

typedef NS_ENUM(NSInteger, TWError) {
    TWErrorAccessDenied,
    TWErrorNoTwitterAccounts,
    TWErrorInvalidResponse
};

static NSString * const TWDomain = @"TWDemo";


@interface RWFetcher : NSObject

- (RACSignal *)requestAccessToTwitterSignal;

- (RACSignal *)signalForSearchWithText:(NSString *)text;

/// only for test
- (void)requestAccessToTwitterWithCompletion:(void(^)(BOOL granted, NSError *error))completion;
- (void)searchRequestWithText:(NSString *)text
                   completion:(void(^)(NSDictionary *json, NSHTTPURLResponse *urlResponse, NSError *error))completion;

@end
