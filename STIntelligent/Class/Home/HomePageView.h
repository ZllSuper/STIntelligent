//
//  HomePageView.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/8/8.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "BXHPageView.h"

#import "BXHAvPlayerBtn.h"

@class HomePageView;

@protocol HomePageViewDelegate <NSObject>

- (void)pageView:(HomePageView *)pageView  maoYanAction:(MaoYanModel *)maoYanModel;

- (void)pageView:(HomePageView *)pageView cameraAction:(SheXiangTouModel *)cameraModel;

- (void)pageViewTopDefaultAction:(HomePageView *)pageView;

@end

@interface HomePageView : UICollectionViewCell

@property (nonatomic, strong) BXHAvPlayerBtn *imageBtn;

@property (nonatomic, weak) DeveicePageModel *pageModel;

@property (nonatomic, weak) id <HomePageViewDelegate>delegate;

- (void)reload;

@end
