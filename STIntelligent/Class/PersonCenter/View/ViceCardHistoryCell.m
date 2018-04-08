//
//  ViceCardHistoryCell.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/11.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "ViceCardHistoryCell.h"

@implementation ViceCardHistoryCell

- (void)setWeakModel:(TemporaryHistoryModel *)weakModel
{
    _weakModel = weakModel;
    
    self.invitedLabel.text = [NSString stringWithFormat:@"被邀请人：%@",weakModel.Name];
    NSString *doorName = @"";
    for (PCDoorModel *dModel in weakModel.Doors)
    {
        if (StringIsEmpty(doorName))
        {
            doorName = dModel.Name;
        }
        else
        {
            doorName = [NSString stringWithFormat:@"%@,%@",doorName,dModel.Name];
        }
    }
    self.authLabel.text = [NSString stringWithFormat:@"授权门：%@",doorName];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - action
- (void)rightBtnAction
{
    if (self.protcol)
    {
        [self.protcol cellRigthBtnAction:self];
    }
}

@end
