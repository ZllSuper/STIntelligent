//
//  CameraSettingHeader.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/19.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "CameraSettingHeader.h"

@implementation CameraSettingHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = Color_White;
    
        [self addSubview:self.iconImageView];
        [self addSubview:self.titleLabel];
        
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 80));
            make.left.mas_equalTo(self).offset(16);
            make.centerY.mas_equalTo(self);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.left.mas_equalTo(self.iconImageView.mas_right).offset(10);
        }];
    }
    return self;
}

#pragma mark - get
- (UIImageView *)iconImageView
{
    if (!_iconImageView)
    {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.backgroundColor = Color_Gray_ImageBg;
    }
    return _iconImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = Font_sys_14;
        _titleLabel.textColor = [UIColor darkTextColor];
    }
    return _titleLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
