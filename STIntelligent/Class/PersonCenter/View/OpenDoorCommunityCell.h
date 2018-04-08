//
//  OpenDoorCommunityCell.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/11.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQXSwitch.h"

@class OpenDoorCommunityCell;
@protocol OpenDoorCommunityCellProtcol <NSObject>

- (void)cell:(OpenDoorCommunityCell *)cell switchBtnAction:(LQXSwitch *)sender;

@end

@interface OpenDoorCommunityCell : UITableViewCell

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) LQXSwitch *switchBtn;

@property (weak, nonatomic) id <OpenDoorCommunityCellProtcol>protcol;

@property (weak, nonatomic) id weakModel;

@end
