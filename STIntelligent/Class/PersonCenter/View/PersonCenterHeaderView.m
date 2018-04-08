//
//  PersonCenterHeaderView.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/10.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "PersonCenterHeaderView.h"

@implementation PersonCenterHeaderView

- (instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {        
        [self addSubview:self.backImageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.headerBackView];
        [self addSubview:self.headerImageView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.bottomView];
        
        [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_top).offset(42);
            make.centerX.mas_equalTo(self);
        }];
        
        [self.headerBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(88, 88));
        }];
        
        [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(82, 82));
        }];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(self.headerBackView.mas_bottom).offset(5);
        }];
        
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.and.left.and.right.mas_equalTo(self);
            make.height.mas_equalTo(@50);
        }];
    }
    return self;
}


#pragma mark - get
- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = Font_sys_17;
        _titleLabel.text = @"个人中心";
    }
    return _titleLabel;
}

- (UIImageView *)headerBackView
{
    if (!_headerBackView)
    {
        _headerBackView = [[UIImageView alloc] init];
        _headerBackView.image = ImageWithName(@"PersonCenterHeaderBack");
        _headerBackView.layer.cornerRadius = 44;
        _headerBackView.clipsToBounds = YES;
    }
    return _headerBackView;
}

- (UIImageView *)headerImageView
{
    if (!_headerImageView)
    {
        _headerImageView = [[UIImageView alloc] init];
        _headerImageView.image = ImageWithName(@"PersonCenterHeaderDefault");
        _headerImageView.layer.cornerRadius = 41;
        _headerImageView.clipsToBounds = YES;
    }
    return _headerImageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel)
    {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = Font_sys_14;
        _nameLabel.textColor = Color_White;
    }
    return _nameLabel;
}

- (UIImageView *)backImageView
{
    if (!_backImageView)
    {
        _backImageView = [[UIImageView alloc] init];
        _backImageView.image = ImageWithName(@"PCHeaderBack");
        _backImageView.clipsToBounds = YES;
        _backImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _backImageView;
}

- (PersonCenterHeaderBottomView *)bottomView
{
    if (!_bottomView)
    {
        _bottomView = [PersonCenterHeaderBottomView viewFromXIB];
//        _bottomView.backgroundColor = [UIColor colorWithRed:0.81 green:0.81 blue:0.82 alpha:0.9];
    }
    return _bottomView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
