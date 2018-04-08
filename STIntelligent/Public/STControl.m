//
//  STControl.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/8.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "STControl.h"

@implementation STControl

- (instancetype) init
{
    if (self = [super init])
    {
        [self addSubview:self.imageView];
        [self addSubview:self.titleLabel];
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(5);
            make.right.mas_equalTo(self).offset(-5);
            make.top.mas_equalTo(self).offset(5);
            make.height.mas_equalTo(self.imageView.mas_width);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(self);
            make.top.mas_equalTo(self.imageView.mas_bottom).offset(5);
        }];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self addSubview:self.imageView];
        [self addSubview:self.titleLabel];
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(32.5, 32.5));
            make.bottom.mas_equalTo(self.mas_centerY).offset(0);
            make.height.mas_equalTo(self.imageView.mas_width);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(self);
            make.top.mas_equalTo(self.imageView.mas_bottom).offset(5);
        }];
        self.titleLabel.font = Font_sys_12;
        self.titleLabel.textColor = Color_Text_DarkGray;
    }
    return self;
}

#pragma mark - get

- (void)setCameraModel:(SheXiangTouModel *)cameraModel
{
    _cameraModel = cameraModel;
    self.titleLabel.text = StringIsEmpty(self.cameraModel.Name)? @"摄像头" : self.cameraModel.Name;
}

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
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
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
