//
//  RWTweet.h
//  TwitterInstant
//
//  Created by Colin Eberhardt on 05/01/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWTweet : NSObject

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *profileImageUrl;

+ (instancetype)tweetWithStatus:(NSDictionary *)status;

@end
