//
//  AddMaoYanProgressView.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/6/5.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddMaoYanProgressView : UIView

@property (nonatomic, strong) UILabel *stateLabel;

@property (nonatomic, strong) UILabel *markOneLabel;

@property (nonatomic, strong) UILabel *markTwoLabel;

@property (nonatomic, strong) UILabel *markThreeLabel;

@property (nonatomic, strong) UILabel *markFourLabel;

@property (nonatomic, assign) NSInteger mark;

- (instancetype)initWithMark:(NSInteger)mark;

@end
