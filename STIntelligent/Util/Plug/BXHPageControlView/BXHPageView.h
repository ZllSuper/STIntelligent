//
//  BXHPageView.h
//  CollectionView
//
//  Created by 步晓虎 on 2017/8/7.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BXHPageView;
@protocol BXHPageViewDelegate <NSObject>

- (void)deltBtnActionPageView:(BXHPageView *)pageView;

@end

@interface BXHPageView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGFloat scale;

@property (nonatomic, weak) id <BXHPageViewDelegate>deltDelegate;

@end
