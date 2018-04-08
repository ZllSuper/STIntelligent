//
//  LoginAuthRightView.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/18.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "LoginAuthRightView.h"

@implementation LoginAuthRightView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self addSubview:self.lineView];
        [self addSubview:self.authBtn];
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(5);
            make.bottom.mas_equalTo(self).offset(-5);
            make.width.mas_equalTo(@1);
            make.left.mas_equalTo(self);
        }];
        
        [self.authBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.right.and.left.and.bottom.mas_equalTo(self);
        }];
    }
    return self;
}

#pragma mark - get
- (UIView *)lineView
{
    if (!_lineView)
    {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = Color_Gray_Line;
    }
    return _lineView;
}

- (BXHAuthBtn *)authBtn
{
    if (!_authBtn)
    {
        _authBtn = [BXHAuthBtn buttonWithType:UIButtonTypeCustom];
        [_authBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_authBtn setTitleColor:[UIColor getHexColorWithHexStr:@"#006AFA"] forState:UIControlStateNormal];
        _authBtn.titleLabel.font = Font_sys_14;
    }
    return _authBtn;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
