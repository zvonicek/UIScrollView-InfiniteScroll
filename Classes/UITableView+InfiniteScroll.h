//
//  UITableView+InfiniteScroll.h
//  InfiniteScrollViewDemoSwift
//
//  Created by pronebird on 8/23/15.
//  Copyright © 2015 pronebird. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (InfiniteScroll)

- (void)endUpdatesWithCompletion:(nullable void(^)(void))completion;

@end

NS_ASSUME_NONNULL_END
