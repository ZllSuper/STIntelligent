//
//  TemporaryHistoryCell.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/7/12.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemporaryHistoryModel.h"

@class TemporaryHistoryCell;
@protocol TemporaryHistoryCellProtcol <NSObject>

- (void)cellRigthBtnAction:(TemporaryHistoryCell *)cell;

@end

@interface TemporaryHistoryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *invitedLabel;

@property (weak, nonatomic) IBOutlet UILabel *authLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@property (assign, nonatomic) BOOL canIvi;

@property (nonatomic, weak) TemporaryHistoryModel *weakModel;

@property (nonatomic, weak) id <TemporaryHistoryCellProtcol>protcol;

@end
