//
//  OpenDoorCircleMenu.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/19.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleMenuItem : UIControl

@end

@class OpenDoorCircleMenu;
@protocol OpenDoorCircleMenuProtcol <NSObject>

- (void)circleMenu:(OpenDoorCircleMenu *)menu itemAction:(CircleMenuItem *)item;

@end

@interface OpenDoorCircleMenu : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, strong) NSArray <CircleMenuItem*>*items;

@property (nonatomic, weak) id <OpenDoorCircleMenuProtcol>protcol;

- (instancetype)initWithWithItemSize:(CGSize)size;

- (void)animateWithFrameSize:(CGSize)size;

@end
