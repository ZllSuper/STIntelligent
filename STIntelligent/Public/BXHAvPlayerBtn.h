//
//  BXHAvPlayerBtn.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/8/25.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>

@interface BXHAvPlayerBtn : UIButton

@property (nonatomic, assign, readonly) BOOL isPlay;

- (void)circlePlay;

- (void)stopPlay;

@end
