//
//  PCDeviceManegerCell.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/12.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "PCDeviceManegerCell.h"

@implementation PCDeviceManegerCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.delButton.layer.cornerRadius = 4;
    self.delButton.layer.borderWidth = 1;
    self.delButton.clipsToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)delAction:(id)sender
{
    if (self.protcol)
    {
        [self.protcol managerCellDelAction:self];
    }

}

- (void)setWeakModel:(id)weakModel
{
    _weakModel = weakModel;
    if (self.type == DeviceTypeMaoYan)
    {
        self.nameLabel.text = [NSString stringWithFormat:@"设备用途：%@",[(MaoYanModel *)weakModel Name]];
        self.cardLabel.text = [NSString stringWithFormat:@"设备ID：%@",[(MaoYanModel *)weakModel bid]];
    }
    else
    {
        self.nameLabel.text = [NSString stringWithFormat:@"设备用途：%@",[(SheXiangTouModel *)weakModel Name]];
        self.cardLabel.text = [NSString stringWithFormat:@"设备ID：%@",[(SheXiangTouModel *)weakModel deviceSerialNo]];
    }
    
}

@end
