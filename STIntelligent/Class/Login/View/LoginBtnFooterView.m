//
//  LoginBtnFooterView.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/18.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "LoginBtnFooterView.h"

@implementation LoginBtnFooterView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = Color_Clear;
        
        [self addSubview:self.loginBtn];
        [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(16);
            make.right.mas_equalTo(self).offset(-16);
            make.height.mas_equalTo(@44);
            make.bottom.mas_equalTo(self);
        }];
    }
    return self;
}

#pragma mark - get
- (UIButton *)loginBtn
{
    if (!_loginBtn)
    {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn setBackgroundImage:ImageWithColor([UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.buttonColor]) forState:UIControlStateNormal];
        _loginBtn.titleLabel.font = Font_sys_14;
        _loginBtn.layer.cornerRadius = 4;
        _loginBtn.clipsToBounds = YES;
    }
    return _loginBtn;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
