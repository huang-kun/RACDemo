//
//  RACDemoTests.m
//  RACDemoTests
//
//  Created by Jack Huang on 16/6/22.
//  Copyright © 2016年 huang-kun. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RWFetcher.h"
#import "NSURLSession+RACSupport.h"

@interface RACDemoTests : XCTestCase
@property (nonatomic, strong) RWFetcher *fetcher;
@end

@implementation RACDemoTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.fetcher = [RWFetcher new];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    /*
    [self.fetcher requestAccessToTwitterWithCompletion:^(BOOL granted, NSError *error) {
        if (granted) {
            NSLog(@"Twitter account access granted.");
        } else {
            NSLog(@"Twitter account access error: %@", error);
        }
    }];
    
    [self.fetcher searchRequestWithText:@"hello" completion:^(NSDictionary *json, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            NSLog(@"%@", json);
        }
    }];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:120]];
     */
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
