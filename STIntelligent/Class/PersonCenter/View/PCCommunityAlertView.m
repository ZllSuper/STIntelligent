//
//  PCCommunityAlertView.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/6/29.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "PCCommunityAlertView.h"

@implementation PCCommunityAlertView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.sureBtn.layer.cornerRadius = 4;
    self.sureBtn.clipsToBounds = YES;
    
    self.cancelBtn.layer.cornerRadius = 4;
    self.cancelBtn.clipsToBounds = YES;
    self.cancelBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.cancelBtn.layer.borderWidth = 1;
    
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
