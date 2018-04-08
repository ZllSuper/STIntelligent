//
//  HomePageControlView.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/9/12.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomePageControlView;
@protocol HomePageControlViewProtcol <NSObject>

- (void)pageControlView:(HomePageControlView *)controlView scrollAtIndex:(NSInteger)index;

@end

@interface HomePageControlView : UICollectionView <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) NSArray *sourceAry;

@property (nonatomic, assign) NSInteger currentItem;

@property (nonatomic, weak) id <HomePageControlViewProtcol>protcol;

@end
