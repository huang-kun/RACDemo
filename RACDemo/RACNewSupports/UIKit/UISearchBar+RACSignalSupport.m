//
//  UISearchBar+RACSignalSupport.m
//  ReactiveCocoa
//
//  Created by huang-kun on 16/8/13.
//  Copyright © 2016年 ReactiveCocoa. All rights reserved.
//

#import "UISearchBar+RACSignalSupport.h"
#import "RACEXTKeyPathCoding.h"
#import "RACEXTScope.h"
#import "NSObject+RACDeallocating.h"
#import "NSObject+RACDescription.h"
#import "RACSignal+Operations.h"
#import "RACDelegateProxy.h"
#import "RACTuple.h"
#import <objc/runtime.h>

@implementation UISearchBar (RACSignalSupport)

static void RACUseDelegateProxy(UISearchBar *self) {
    if (self.delegate == self.rac_delegateProxy) return;
    
    self.rac_delegateProxy.rac_proxiedDelegate = self.delegate;
    self.delegate = (id)self.rac_delegateProxy;
}

- (RACDelegateProxy *)rac_delegateProxy {
    RACDelegateProxy *proxy = objc_getAssociatedObject(self, _cmd);
    if (proxy == nil) {
        proxy = [[RACDelegateProxy alloc] initWithProtocol:@protocol(UITextViewDelegate)];
        objc_setAssociatedObject(self, _cmd, proxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return proxy;
}

- (RACSignal *)rac_textSignal {
    @weakify(self);
    RACSignal *signal = [[[[[RACSignal
                             defer:^{
                                 @strongify(self);
                                 return [RACSignal return:RACTuplePack(self)];
                             }]
                             concat:[self.rac_delegateProxy rac_signalForSelector:@selector(searchBar:textDidChange:) fromProtocol:@protocol(UISearchBarDelegate)]]
                             reduceEach:^(UITextView *x) {
                                 return x.text;
                             }]
                             takeUntil:self.rac_willDeallocSignal]
                             setNameWithFormat:@"%@ -rac_textSignal", self.rac_description];
    
    RACUseDelegateProxy(self);
    return signal;
}

@end
