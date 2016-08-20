//
//  RWTableViewCell.m
//  TwitterInstant
//
//  Created by Colin Eberhardt on 03/12/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "RWTableViewCell.h"

@implementation RWTableViewCell

- (void)loadAvatarImageWithURL:(NSString *)urlString {
    self.twitterAvatarView.image = nil;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        UIImage *image = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.twitterAvatarView.image = image;
        });
    });
}

@end
