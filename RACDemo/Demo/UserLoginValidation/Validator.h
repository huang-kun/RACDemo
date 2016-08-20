//
//  Validator.h
//  WeiboStream
//
//  Created by huang-kun on 16/8/11.
//  Copyright © 2016年 huang-kun. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 需求：
 
 1.用户名和密码都不得少于6位，并且不能包含空格
 2.用户名不可以包含 ~ + * 等特殊符号
 3.密码必须包含字母和数字组合
 
 */

@interface Validator : NSObject

- (instancetype)initWithUsernameInputSignal:(RACSignal *)usernameInputSignal
                        passwordInputSignal:(RACSignal *)passwordInputSignal;

@property (nonatomic, readonly, strong) RACSignal *usernameValidationSignal; /// 发送BOOL
@property (nonatomic, readonly, strong) RACSignal *passwordValidationSignal; /// 发送BOOL
@property (nonatomic, readonly, strong) RACSignal *informationValidationSignal; /// 发送BOOL

@property (nonatomic, readonly, strong) RACSignal *invalidUsernameDescriptionSignal; /// 发送NSString
@property (nonatomic, readonly, strong) RACSignal *invalidPasswordDescriptionSignal; /// 发送NSString

@end
