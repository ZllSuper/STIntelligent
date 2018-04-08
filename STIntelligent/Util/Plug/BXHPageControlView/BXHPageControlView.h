//
//  BXHPageControlView.h
//  CollectionView
//
//  Created by 步晓虎 on 2017/8/7.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXHPageView.h"

@class BXHPageControlView;

@protocol BXHPageControlViewDelegate <NSObject>

- (void)pageControlView:(BXHPageControlView *)controlView deltWithPageView:(BXHPageView *)pageView;

@end

@interface BXHPageControlView : UIScrollView

@property (nonatomic, readonly, strong) NSArray <BXHPageView *>*pageViews;

@property (nonatomic, weak) id <BXHPageControlViewDelegate>deltDelegate;

- (void)reloadPageViews:(NSArray <BXHPageView *>*)pageViews;

- (void)addPageView:(BXHPageView *)pageView;

- (void)removePageView:(BXHPageView *)pageView;

@end
