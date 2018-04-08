//
//  MessageSegmentView.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/10.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MessageSegmentView;
@protocol MessageSegmentViewDelegate <NSObject>

- (void)segmentView:(MessageSegmentView *)segmentView btnSelectIndex:(NSInteger)index;

@end

@interface MessageSegmentView : UIView

@property (nonatomic, weak) id <MessageSegmentViewDelegate>delegate;

- (instancetype)initWithLeftTitle:(NSString *)leftTitle andRightTitle:(NSString *)rightTitle;

@end
