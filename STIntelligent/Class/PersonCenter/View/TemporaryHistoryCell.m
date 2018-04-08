//
//  TemporaryHistoryCell.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/7/12.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "TemporaryHistoryCell.h"

@implementation TemporaryHistoryCell

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
    
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[weakModel.StartTime integerValue]];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:[weakModel.EndTime integerValue]];
    NSString *startTime = [startDate dateStrWithFormatStr:@"MM.dd HH:mm"];
    NSString *endTime = [endDate dateStrWithFormatStr:@"MM.dd HH:mm"];
    self.dateLabel.text = [NSString stringWithFormat:@"有效期：%@至%@",startTime,endTime];
    
    BXHLog(@"endDate = %@",endDate);
    BXHLog(@"currentDate = %@",[NSDate date]);
    if ([[endDate earlierDate:[NSDate date]] isEqualToDate:endDate])
    {
        self.canIvi = YES;
        [self.rightBtn setTitle:@"重新授权" forState:UIControlStateNormal];
    }
    else
    {
        self.canIvi = NO;
        [self.rightBtn setTitle:@"删除授权" forState:UIControlStateNormal];
    }
    
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
