//
//  UISearchBar+RACSignalSupport.h
//  ReactiveCocoa
//
//  Created by huang-kun on 16/8/13.
//  Copyright © 2016年 ReactiveCocoa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RACSignal;

@interface UISearchBar (RACSignalSupport)

/// A delegate proxy which will be set as the receiver's delegate when any of the
/// methods in this category are used.
@property (nonatomic, strong, readonly) RACDelegateProxy *rac_delegateProxy;

/// Creates a signal for the text of the receiver.
///
/// When this method is invoked, the `rac_delegateProxy` will become the
/// receiver's delegate. Any previous delegate will become the -[RACDelegateProxy
/// rac_proxiedDelegate], so that it receives any messages that the proxy doesn't
/// know how to handle. Setting the receiver's `delegate` afterward is
/// considered undefined behavior.
///
/// Returns a signal which will send the current text upon subscription, then
/// again whenever the receiver's text is changed. The signal will complete when
/// the receiver is deallocated.
- (RACSignal *)rac_textSignal;

@end
