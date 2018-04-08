//
//  PCCommunityManagerCell.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/10.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "PCCommunityManagerCell.h"

@implementation PCCommunityManagerCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setWeakModel:(PCCommunityModel *)weakModel
{
    _weakModel = weakModel;
    self.nameLabel.text = weakModel.Name;
    self.addressLabel.text = weakModel.Address;
}

- (void)setListWeakModel:(PCCommunityListModel *)weakModel
{
    _listWeakModel = weakModel;
    self.nameLabel.text = weakModel.CommunityName;
    self.addressLabel.text = weakModel.CommunityAddress;
    self.statueLabel.text  = [weakModel statueStr];
    if ([weakModel.ActivatedState integerValue] == 2)
    {
        self.statueLabel.textColor = [UIColor redColor];
    }
    else
    {
        self.statueLabel.textColor = [UIColor lightGrayColor];
    }
}

@end
