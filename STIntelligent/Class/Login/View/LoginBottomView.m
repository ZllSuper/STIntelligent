//
//  LoginBottomView.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/18.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "LoginBottomView.h"

@implementation LoginBottomView

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.titleLabel.backgroundColor = [UIColor getHexColorWithHexStr:@"#EDEDF2"];
    
    self.oneControl.imageView.image = ImageWithName(@"LoginIcon1");
    self.oneControl.titleLabel.text = @"微信";
    self.twoControl.imageView.image = ImageWithName(@"LoginIcon2");
    self.twoControl.titleLabel.text = @"QQ";
    self.threeControl.imageView.image = ImageWithName(@"LoginIcon3");
    self.threeControl.titleLabel.text = @"新浪";
    self.fourControl.imageView.image = ImageWithName(@"LoginIcon4");
    self.fourControl.titleLabel.text = @"支付宝";
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
