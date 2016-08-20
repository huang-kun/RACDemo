//
//  Validator.m
//  WeiboStream
//
//  Created by huang-kun on 16/8/11.
//  Copyright © 2016年 huang-kun. All rights reserved.
//

#import "Validator.h"

@interface Validator ()
@property (nonatomic, strong) RACSignal *usernameInputSignal;
@property (nonatomic, strong) RACSignal *passwordInputSignal;
@end

@implementation Validator

- (instancetype)initWithUsernameInputSignal:(RACSignal *)usernameInputSignal
                        passwordInputSignal:(RACSignal *)passwordInputSignal {
    self = [super init];
    if (self) {
        _usernameInputSignal = usernameInputSignal;
        _passwordInputSignal = passwordInputSignal;
        [self setupSignals];
    }
    return self;
}

- (void)setupSignals {
    @weakify(self)
    
    _usernameValidationSignal = [self.usernameInputSignal map:^id(NSString *username) {
        @strongify(self)
        return @([self isValidUsername:username]);
    }];
    
    _passwordValidationSignal = [self.passwordInputSignal map:^id(NSString *password) {
        @strongify(self)
        return @([self isValidPassword:password]);
    }];
    
    _informationValidationSignal = [RACSignal combineLatest:@[ _usernameValidationSignal,
                                                               _passwordValidationSignal ]
                                                     reduce:^id(NSNumber *validUsername, NSNumber *valiedPassword){
                                                         
        return @([validUsername boolValue] && [valiedPassword boolValue]);
    }];
    
    _invalidUsernameDescriptionSignal = [self.usernameInputSignal map:^id(NSString *username) {
        @strongify(self)
        NSString *desc = nil;
        if (!username.length) {
            desc = @"用户名不能为空";
        } else if ([self isTooShortForUsername:username]) {
            desc = @"用户名长度不得少于6位";
        } else if ([self containsInvalidCharactersForUsername:username]) {
            desc = @"用户名不可以包含特殊字符";
        } else if ([self containsWhiteSpaceForString:username]) {
            desc = @"用户名不可以包含空格";
        }
        return desc;
    }];
    
    _invalidPasswordDescriptionSignal = [self.passwordInputSignal map:^id(NSString *password) {
        @strongify(self)
        NSString *desc = nil;
        if (!password.length) {
            desc = @"密码不能为空";
        } else if ([self isTooShortForPassword:password]) {
            desc = @"密码长度不得少于6位";
        } else if ([self containsWhiteSpaceForString:password]) {
            desc = @"密码不可以包含空格";
        } else if (![self isValidCombinationForPassword:password]) {
            desc = @"密码只能包含字母和数字的组合";
        }
        return desc;
    }];    
}

- (BOOL)isValidUsername:(NSString *)username {
    return ![self isTooShortForUsername:username] &&
            ![self containsInvalidCharactersForUsername:username] &&
            ![self containsWhiteSpaceForString:username];
}

- (BOOL)isValidPassword:(NSString *)password {
    return ![self isTooShortForPassword:password] &&
            [self isValidCombinationForPassword:password] &&
            ![self containsWhiteSpaceForString:password];
}

- (BOOL)containsWhiteSpaceForString:(NSString *)string {
    NSCharacterSet *whiteSpaceSet= [NSCharacterSet whitespaceCharacterSet];
    for (NSUInteger i = 0; i < string.length; ++i) {
        unichar character = [string characterAtIndex:i];
        if ([whiteSpaceSet characterIsMember:character]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isTooShortForUsername:(NSString *)username {
    return username.length < 6;
}

- (BOOL)isTooShortForPassword:(NSString *)password {
    return password.length < 6;
}

- (BOOL)containsInvalidCharactersForUsername:(NSString *)username {
    NSCharacterSet *symbols = [NSCharacterSet symbolCharacterSet];
    for (NSUInteger i = 0; i < username.length; ++i) {
        unichar character = [username characterAtIndex:i];
        if ([symbols characterIsMember:character]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isValidCombinationForPassword:(NSString *)password {
    BOOL r1 = YES;
    int a = 0, b = 0;
    
    NSCharacterSet *letterSet = [NSCharacterSet letterCharacterSet];
    NSCharacterSet *digitSet = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *letterAndDigitSet = [NSCharacterSet alphanumericCharacterSet];
    
    for (NSUInteger i = 0; i < password.length; ++i) {
        unichar character = [password characterAtIndex:i];
        if (![letterAndDigitSet characterIsMember:character]) {
            r1 = NO;
            break;
        }
        if ([letterSet characterIsMember:character]) {
            a++;
        }
        if ([digitSet characterIsMember:character]) {
            b++;
        }
    }
    return r1 && a > 0 && b > 0;
}

- (void)dealloc {
    NSLog(@"%@ deallocated.", self);
}

@end
