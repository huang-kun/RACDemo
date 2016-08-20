//
//  RWFetcher.m
//  RACDemo
//
//  Created by huang-kun on 16/8/13.
//  Copyright © 2016年 huang-kun. All rights reserved.
//

#import "RWFetcher.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>

/* 
 
 Reference:
 
 https://www.raywenderlich.com/62796/reactivecocoa-tutorial-pt2
 http://benbeng.leanote.com/post/ReactiveCocoaTutorial-part2 （中文）
 
 */

@interface RWFetcher()
@property (nonatomic, strong) ACAccountStore *accountStore;
@property (nonatomic, strong) ACAccountType *twitterAccountType;
@end

@implementation RWFetcher

- (instancetype)init {
    self = [super init];
    if (self) {
        self.accountStore = [[ACAccountStore alloc] init];
        self.twitterAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    }
    return self;
}

- (void)requestAccessToTwitterWithCompletion:(void(^)(BOOL granted, NSError *error))completion {
    // 1 - define an error
//    NSError *accessError = [NSError errorWithDomain:TWDomain
//                                               code:TWErrorAccessDenied
//                                           userInfo:nil];
    // 3 - request access to twitter
    [self.accountStore requestAccessToAccountsWithType:self.twitterAccountType
                                               options:nil
                                            completion:^(BOOL granted, NSError *error) {
                                                // 4 - handle the response
                                                if (completion) completion(granted, error);
                                            }];
}

- (RACSignal *)requestAccessToTwitterSignal {
    // 2 - create the signal
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id subscriber) {
        @strongify(self)
        [self requestAccessToTwitterWithCompletion:^(BOOL granted, NSError *error) {
            if (!granted) {
                [subscriber sendError:error];
            } else {
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            }
        }];
        return nil;
    }];
}

- (SLRequest *)requestforTwitterSearchWithText:(NSString *)text {
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/search/tweets.json"];
    NSDictionary *params = @{@"q" : text};
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodGET
                                                      URL:url
                                               parameters:params];
    return request;
}

- (void)searchRequestWithText:(NSString *)text
                   completion:(void(^)(NSDictionary *json, NSHTTPURLResponse *urlResponse, NSError *error))completion {
    
    // 1 - define the errors
    NSError *noAccountsError = [NSError errorWithDomain:TWDomain
                                                   code:TWErrorNoTwitterAccounts
                                               userInfo:nil];
//    NSError *invalidResponseError = [NSError errorWithDomain:TWDomain
//                                                        code:TWErrorInvalidResponse
//                                                    userInfo:nil];
    
    // 3 - create the request
    SLRequest *request = [self requestforTwitterSearchWithText:text];
    
    // 4 - supply a twitter account
    NSArray *twitterAccounts = [self.accountStore accountsWithAccountType:self.twitterAccountType];
    if (twitterAccounts.count == 0) {
        if (completion) completion(nil, nil, noAccountsError);
    } else {
        [request setAccount:[twitterAccounts lastObject]];
        
        // 5 - perform the request
        [request performRequestWithHandler: ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
            if (urlResponse.statusCode == 200) {
                
                // 6 - on success, parse the response
                NSDictionary *timelineData = [NSJSONSerialization JSONObjectWithData:responseData
                                                                             options:NSJSONReadingAllowFragments
                                                                               error:nil];
                if (completion) completion(timelineData, urlResponse, nil);
            } else {
                // 7 - send an error on failure
                if (completion) completion(nil, urlResponse, error);
            }
        }];
    }
}

- (RACSignal *)signalForSearchWithText:(NSString *)text {
    
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id subscriber) {
        @strongify(self);
        
        [self searchRequestWithText:text completion:^(NSDictionary *json, NSHTTPURLResponse *urlResponse, NSError *error) {
            if (error) {
                [subscriber sendError:error];
            } else {
                [subscriber sendNext:json];
                [subscriber sendCompleted];
            }
        }];
        return nil;
    }];
}

- (void)dealloc {
    NSLog(@"%@ deallocated.", self);
}

@end
