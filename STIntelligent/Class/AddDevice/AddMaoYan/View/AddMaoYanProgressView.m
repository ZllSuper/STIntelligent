//
//  AddMaoYanProgressView.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/6/5.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "AddMaoYanProgressView.h"



@interface AddMaoYanProgressView ()

@property (nonatomic, strong) UIView *backProgressView;

@property (nonatomic, strong) UIView *foregoundProgressView;

@end

@implementation AddMaoYanProgressView

- (instancetype)initWithMark:(NSInteger)mark
{
    if (self = [super init])
    {
        self.backgroundColor = [UIColor getHexColorWithHexStr:@"#EEEEF3"];
        
        self.mark = mark;
        
        [self addSubview:self.backProgressView];
        [self addSubview:self.foregoundProgressView];
        [self addSubview:self.markOneLabel];
        [self addSubview:self.markTwoLabel];
        [self addSubview:self.markThreeLabel];
        [self addSubview:self.markFourLabel];
        [self addSubview:self.stateLabel];
        
        CGFloat unit = (DEF_SCREENWIDTH - 32) / 5;
        
        [self.backProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(16);
            make.right.mas_equalTo(self).offset(-16);
            make.height.mas_equalTo(@3);
            make.centerY.mas_equalTo(self).offset(20);
        }];
        
        [self.foregoundProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.backProgressView);
            make.centerY.mas_equalTo(self.backProgressView);
            make.height.mas_equalTo(@3);
//            make.width.mas_equalTo(@(unit * (self.mark + 1) - unit / 2 * ((self.mark == 4) ? 2 : 1)));
            make.width.mas_equalTo(@(unit * (self.mark + 1)));
        }];
        
        [self.markOneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.backProgressView);
            make.size.mas_equalTo(CGSizeMake(20, 20));
            make.centerX.mas_equalTo(self.backProgressView.mas_left).offset(unit);
        }];
        
        [self.markTwoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.backProgressView);
            make.size.mas_equalTo(CGSizeMake(20, 20));
            make.centerX.mas_equalTo(self.backProgressView.mas_left).offset(unit * 2);
        }];
        
        [self.markThreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.backProgressView);
            make.size.mas_equalTo(CGSizeMake(20, 20));
            make.centerX.mas_equalTo(self.backProgressView.mas_left).offset(unit * 3);
        }];
        
        [self.markFourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.backProgressView);
            make.size.mas_equalTo(CGSizeMake(20, 20));
            make.centerX.mas_equalTo(self.backProgressView.mas_left).offset(unit * 4);
        }];
        
        if (self.mark == 1)
        {
            self.stateLabel.text = @"准备";
        }
        else if (self.mark == 2)
        {
            self.stateLabel.text = @"连接网络";
        }
        else if (self.mark == 3)
        {
            self.stateLabel.text = @"扫描二维码";
        }
        
        [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.backProgressView.mas_top).offset(-15);
            make.centerX.mas_equalTo(self.backProgressView.mas_left).offset(unit * self.mark);
//            make.size.mas_equalTo(CGSizeMake(40, 20));
        }];
        
        self.markOneLabel.backgroundColor = self.mark >= 1 ? [UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.buttonColor] : Color_White;
        self.markOneLabel.textColor = self.mark >= 1 ? Color_White : Color_Text_Gray;
        
        self.markTwoLabel.backgroundColor = self.mark >= 2 ? [UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.buttonColor] : Color_White;
        self.markTwoLabel.textColor = self.mark >= 2 ? Color_White : Color_Text_Gray;
        
        self.markThreeLabel.backgroundColor = self.mark >= 3 ? [UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.buttonColor] : Color_White;
        self.markThreeLabel.textColor = self.mark >= 3 ? Color_White : Color_Text_Gray;
        
        self.markFourLabel.backgroundColor = self.mark >= 4 ? [UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.buttonColor] : Color_White;
        self.markFourLabel.textColor = self.mark >= 4 ? Color_White : Color_Text_Gray;
    }
    return self;
}

#pragma mark - get
- (UILabel *)stateLabel
{
    if (!_stateLabel)
    {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.font = Font_sys_14;
        _stateLabel.textColor = [UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.buttonColor];
    }
    return _stateLabel;
}

- (UILabel *)markOneLabel
{
    if (!_markOneLabel)
    {
        _markOneLabel = [[UILabel alloc] init];
        _markOneLabel.font = Font_sys_10;
        _markOneLabel.textAlignment = NSTextAlignmentCenter;
        _markOneLabel.text = @"1";
        _markOneLabel.layer.cornerRadius = 10;
        _markOneLabel.clipsToBounds = YES;
    }
    return _markOneLabel;
}

- (UILabel *)markTwoLabel
{
    if (!_markTwoLabel)
    {
        _markTwoLabel = [[UILabel alloc] init];
        _markTwoLabel.font = Font_sys_10;
        _markTwoLabel.textAlignment = NSTextAlignmentCenter;
        _markTwoLabel.text = @"2";
        _markTwoLabel.layer.cornerRadius = 10;
        _markTwoLabel.clipsToBounds = YES;
    }
    return _markTwoLabel;
}

- (UILabel *)markThreeLabel
{
    if (!_markThreeLabel)
    {
        _markThreeLabel = [[UILabel alloc] init];
        _markThreeLabel.font = Font_sys_10;
        _markThreeLabel.textAlignment = NSTextAlignmentCenter;
        _markThreeLabel.text = @"3";
        _markThreeLabel.layer.cornerRadius = 10;
        _markThreeLabel.clipsToBounds = YES;
    }
    return _markThreeLabel;
}

- (UILabel *)markFourLabel
{
    if (!_markFourLabel)
    {
        _markFourLabel = [[UILabel alloc] init];
        _markFourLabel.font = Font_sys_10;
        _markFourLabel.textAlignment = NSTextAlignmentCenter;
        _markFourLabel.text = @"4";
        _markFourLabel.layer.cornerRadius = 10;
        _markFourLabel.clipsToBounds = YES;
    }
    return _markFourLabel;
}

- (UIView *)backProgressView
{
    if (!_backProgressView)
    {
        _backProgressView = [[UIView alloc] init];
        _backProgressView.backgroundColor = Color_White;
    }
    return _backProgressView;
}

- (UIView *)foregoundProgressView
{
    if (!_foregoundProgressView)
    {
        _foregoundProgressView = [[UIView alloc] init];
        _foregoundProgressView.backgroundColor = [UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.buttonColor];
    }
    return _foregoundProgressView;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
