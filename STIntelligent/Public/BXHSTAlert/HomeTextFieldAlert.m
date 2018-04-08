//
//  HomeTextFieldAlert.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/6/13.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "HomeTextFieldAlert.h"

@implementation HomeTextFieldAlert

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.sureBtn.layer.cornerRadius = 4;
    self.sureBtn.clipsToBounds = YES;
    self.layer.cornerRadius = 4;
    self.clipsToBounds = YES;
    self.sureBtn.backgroundColor = [UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.buttonColor];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
