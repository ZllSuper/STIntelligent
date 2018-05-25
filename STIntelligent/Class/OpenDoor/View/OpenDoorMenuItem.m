//
//  OpenDoorMenuItem.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/19.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "OpenDoorMenuItem.h"

@implementation OpenDoorMenuItem
- (instancetype)init
{
    if (self = [super init])
    {                
        [self addSubview:self.imageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.subTitleLabel];
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.width.mas_equalTo(self);
            make.bottom.mas_equalTo(self.imageView.mas_top).offset(-2);
        }];
        
        [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.imageView);
        }];
        
        [[STThemeManager shareInstance] addThemeChangeProtcol:self];
        [self themeChange];

    }
    return self;
}

- (void)themeChange
{
    self.titleLabel.textColor = [UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.openDoorColor];
    self.subTitleLabel.textColor = [UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.openDoorColor];
    self.imageView.image = ThemeImageWithName(@"OpenDoorIcon");

}

#pragma mark - get
- (UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = Font_sys_12;
        _titleLabel.text = @"开么";
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel
{
    if (!_subTitleLabel)
    {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = Font_sys_16;
        _subTitleLabel.text = @"门";
    }
    return _subTitleLabel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
