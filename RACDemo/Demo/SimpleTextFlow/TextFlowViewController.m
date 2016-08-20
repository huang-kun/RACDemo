//
//  TextFlowViewController.m
//  RACDemo
//
//  Created by huang-kun on 16/8/12.
//  Copyright © 2016年 huang-kun. All rights reserved.
//

#import "TextFlowViewController.h"

@interface TextFlowViewController ()
@property (nonatomic, strong) IBOutlet UITextField *textField;
@property (nonatomic, strong) IBOutlet UILabel *textLabel;
@end

@implementation TextFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RAC(self.textLabel, text) = self.textField.rac_textSignal;
}

- (void)dealloc {
    NSLog(@"%@ deallocated.", self);
}

@end
