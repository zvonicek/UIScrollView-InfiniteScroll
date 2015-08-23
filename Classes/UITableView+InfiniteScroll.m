//
//  UITableView+InfiniteScroll.m
//  InfiniteScrollViewDemoSwift
//
//  Created by pronebird on 8/23/15.
//  Copyright © 2015 pronebird. All rights reserved.
//

#import "UITableView+InfiniteScroll.h"
#import <objc/runtime.h>

static void PBSwizzleMethod(Class c, SEL original, SEL alternate) {
    Method origMethod = class_getInstanceMethod(c, original);
    Method newMethod = class_getInstanceMethod(c, alternate);
    
    if(class_addMethod(c, original, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
        class_replaceMethod(c, alternate, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, newMethod);
    }
}

@implementation UITableView (InfiniteScroll)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PBSwizzleMethod(self, @selector(beginUpdates), @selector(pb_beginUpdates));
        PBSwizzleMethod(self, @selector(endUpdates), @selector(pb_endUpdates));
    });
}

- (void)pb_beginUpdates {
    [CATransaction begin];
    
    [self pb_beginUpdates];
}

- (void)pb_endUpdates {
    [self pb_endUpdates];
    
    [CATransaction commit];
}

- (void)endUpdatesWithCompletion:(void(^)(void))completion {
    [CATransaction setCompletionBlock:^{
        // skip one run loop to let UITableView to update contentSize
        dispatch_async(dispatch_get_main_queue(), ^{
            if(completion) {
                completion();
            }
        });
    }];

    [self endUpdates];
    
}

@end
