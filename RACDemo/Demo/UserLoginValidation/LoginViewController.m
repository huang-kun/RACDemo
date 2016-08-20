//
//  LoginViewController.m
//  WeiboStream
//
//  Created by huang-kun on 16/8/10.
//  Copyright © 2016年 huang-kun. All rights reserved.
//

#import "LoginViewController.h"
#import "Validator.h"
#import "FakeNetworkManager.h"

@interface LoginViewController ()
@property (nonatomic, strong) IBOutlet UITextField *usernameField;
@property (nonatomic, strong) IBOutlet UITextField *passwordField;
@property (nonatomic, strong) IBOutlet UILabel *usernameLabel;
@property (nonatomic, strong) IBOutlet UILabel *passwordLabel;
@property (nonatomic, strong) IBOutlet UIButton *submitButton;
@property (nonatomic, strong) Validator *validator;
@property (nonatomic, strong) FakeNetworkManager *fnManager;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.submitButton setBackgroundImage:[UIImage imageNamed:@"button_blue"] forState:UIControlStateNormal];
    [self.submitButton setBackgroundImage:[UIImage imageNamed:@"button_blue"] forState:UIControlStateHighlighted];
    [self.submitButton setBackgroundImage:[UIImage imageNamed:@"button_gray"] forState:UIControlStateDisabled];
    
    [self setupSignals];
}

- (void)setupSignals {
    
    @weakify(self)
    
    self.fnManager = [FakeNetworkManager new];
    self.validator = [[Validator alloc] initWithUsernameInputSignal:self.usernameField.rac_textSignal
                                                passwordInputSignal:self.passwordField.rac_textSignal];
    
    // 用户名和密码格式都合法时，允许点击提交按钮
    RAC(self.submitButton, enabled) = self.validator.informationValidationSignal;
    
    // 输入不合法的背景色
    UIColor *invalidBGColor = [UIColor colorWithRed:1.000 green:0.553 blue:0.565 alpha:1.00];
    
    // 输入用户名不合法时显示背景色
    RAC(self.usernameField, backgroundColor) =
    [self.validator.usernameValidationSignal
     map:^id(id value) {
        @strongify(self)
        return [value boolValue] || self.usernameField.text.length == 0 ? UIColor.whiteColor : invalidBGColor;
     }];
    
    // 输入密码不合法时显示背景色
    RAC(self.passwordField, backgroundColor) =
    [self.validator.passwordValidationSignal
     map:^id(id value) {
        @strongify(self)
        return [value boolValue] || self.passwordField.text.length == 0 ? UIColor.whiteColor : invalidBGColor;
     }];
    
    // 提示用户名输入
    RAC(self.usernameLabel, text) =
    [RACSignal combineLatest:@[ self.validator.invalidUsernameDescriptionSignal,
                                self.usernameField.rac_textSignal ]
                      reduce:^NSString *(NSString *desc, NSString *text){
                          return text.length == 0 ? nil : desc;
                      }];
    
    // 提示密码输入
    RAC(self.passwordLabel, text) =
    [RACSignal combineLatest:@[ self.validator.invalidPasswordDescriptionSignal,
                                self.passwordField.rac_textSignal ]
                      reduce:^NSString *(NSString *desc, NSString *text){
                          return text.length == 0 ? nil : desc;
                      }];
    
//    self.submitButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//        // it will crash if you use RAC(self.submitButton, enabled) = ...
//        return [RACSignal empty];
//    }];
    
    // 给提交按钮添加点击事件
    [[[[self.submitButton
        rac_signalForControlEvents:UIControlEventTouchUpInside]
        doNext:^(id x) {
            @strongify(self)
            self.submitButton.enabled = NO;
        }]
        flattenMap:^id(id value) {
            @strongify(self)
            return [self.fnManager submitSignalForUsername:self.usernameField.text password:self.passwordField.text];
        }]
        subscribeNext:^(id x) {
            NSLog(@"Submit success!");
            @strongify(self)
            /* success */
            if ([x boolValue] == YES) {
                self.usernameField.text = nil;
                self.passwordField.text = nil;
            }
            /* failure */
            else {
                self.submitButton.enabled = YES;
            }
        }];
}

- (void)dealloc {
    NSLog(@"%@ deallocated.", self);
}

@end
