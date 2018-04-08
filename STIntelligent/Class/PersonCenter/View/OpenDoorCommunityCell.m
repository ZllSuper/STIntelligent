//
//  OpenDoorCommunityCell.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/11.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "OpenDoorCommunityCell.h"

@implementation OpenDoorCommunityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.switchBtn];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView);
            make.left.mas_equalTo(self.contentView).offset(16);
        }];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - action
- (void)switchBtnAction:(LQXSwitch *)sender
{
    if (self.protcol)
    {
        [self.protcol cell:self switchBtnAction:sender];
    }
}

#pragma mark - get
- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = Font_sys_14;
        _titleLabel.text = @"开门";
    }
    return _titleLabel;
}

- (LQXSwitch *)switchBtn
{
    if (!_switchBtn)
    {
        _switchBtn = [[LQXSwitch alloc] initWithFrame:CGRectMake(DEF_SCREENWIDTH - 76, 10, 60, 24) onColor:[UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.buttonColor] offColor:[UIColor getHexColorWithHexStr:@"#C0C0C6"] font:Font_sys_12 ballSize:24];
        _switchBtn.onText = @"打开";
        _switchBtn.offText = @"关闭";
        [_switchBtn addTarget:self action:@selector(switchBtnAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchBtn;
}

@end
