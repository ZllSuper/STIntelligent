//
//  MessageSegmentView.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/10.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "MessageSegmentView.h"

@interface MessageSegmentView () <STThemeManagerProtcol>

@property (nonatomic, strong) UIButton *leftBtn;

@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) UIView *midLine;

@property (nonatomic, strong) UIView *selLine;

@property (nonatomic, strong) MASConstraint *selLineLeft;

@end

@implementation MessageSegmentView

- (instancetype)initWithLeftTitle:(NSString *)leftTitle andRightTitle:(NSString *)rightTitle
{
    if (self = [super init])
    {
        [[STThemeManager shareInstance] addThemeChangeProtcol:self];
        [self themeChange];
        
        self.backgroundColor = Color_White;
    
        [self.leftBtn setTitle:leftTitle forState:UIControlStateNormal];
        [self.rightBtn setTitle:rightTitle forState:UIControlStateNormal];
        
        [self addSubview:self.leftBtn];
        [self addSubview:self.rightBtn];
        [self addSubview:self.midLine];
        [self addSubview:self.selLine];
        
        [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.and.bottom.mas_equalTo(self);
        }];
        
        [self.midLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(5);
            make.bottom.mas_equalTo(self).offset(-5);
            make.left.mas_equalTo(self.leftBtn.mas_right);
            make.width.mas_equalTo(@0.7);
        }];
        
        [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.midLine.mas_right);
            make.right.and.top.and.bottom.mas_equalTo(self);
            make.width.mas_equalTo(self.leftBtn);
        }];
        
        [self.selLine mas_makeConstraints:^(MASConstraintMaker *make) {
            self.selLineLeft = make.left.mas_equalTo(self).offset(0);
            make.height.mas_equalTo(@1);
            make.width.mas_equalTo(self.leftBtn);
            make.bottom.mas_equalTo(self);
        }];
        
        self.leftBtn.selected = YES;
    }
    return self;
}

- (void)btnAction:(UIButton *)sender
{
    if (sender.selected)
    {
        return;
    }
    sender.selected = YES;
    if ([sender isEqual:self.leftBtn])
    {
        self.rightBtn.selected = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.selLineLeft.offset(0);
        }];
        
        [self.delegate segmentView:self btnSelectIndex:0];
    }
    else
    {
        self.leftBtn.selected = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.selLineLeft.offset(DEF_SCREENWIDTH / 2);
        }];
        [self.delegate segmentView:self btnSelectIndex:1];
    }
    
}

- (void)themeChange
{
    [self.leftBtn setTitleColor:[UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.barSelTextColor] forState:UIControlStateSelected];
    [self.rightBtn setTitleColor:[UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.barSelTextColor] forState:UIControlStateSelected];
    self.selLine.backgroundColor = [UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.barSelTextColor];

}

#pragma mark - get
- (UIButton *)leftBtn
{
    if (!_leftBtn)
    {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftBtn setTitleColor:Color_Text_LightGray forState:UIControlStateNormal];
        _leftBtn.titleLabel.font = Font_sys_14;
        [_leftBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

- (UIButton *)rightBtn
{
    if (!_rightBtn)
    {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setTitleColor:Color_Text_LightGray forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = Font_sys_14;
        [_rightBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (UIView *)midLine
{
    if (!_midLine)
    {
        _midLine = [[UIView alloc] init];
        _midLine.backgroundColor = Color_Gray_Line;
    }
    return _midLine;
}

- (UIView *)selLine
{
    if (!_selLine)
    {
        _selLine = [[UIView alloc] init];
    }
    return _selLine;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
