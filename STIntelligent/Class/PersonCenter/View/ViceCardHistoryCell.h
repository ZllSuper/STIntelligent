//
//  ViceCardHistoryCell.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/11.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemporaryHistoryModel.h"

@class ViceCardHistoryCell;
@protocol ViceCardHistoryCellProtcol <NSObject>

- (void)cellRigthBtnAction:(ViceCardHistoryCell *)cell;

@end

@interface ViceCardHistoryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *invitedLabel;

@property (weak, nonatomic) IBOutlet UILabel *authLabel;

@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@property (weak, nonatomic) TemporaryHistoryModel *weakModel;

@property (nonatomic, weak) id <ViceCardHistoryCellProtcol>protcol;

@end
