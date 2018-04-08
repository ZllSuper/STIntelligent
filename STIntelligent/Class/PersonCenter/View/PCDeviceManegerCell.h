//
//  PCDeviceManegerCell.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/12.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SheXiangTouModel.h"
#import "MaoYanModel.h"


typedef NS_ENUM(NSInteger,DeviceType)
{
    DeviceTypeCamera,
    DeviceTypeMaoYan
};

@class PCDeviceManegerCell;
@protocol PCDeviceManagerCellProtcol <NSObject>

- (void)managerCellDelAction:(PCDeviceManegerCell *)cell;

@end

@interface PCDeviceManegerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *cardLabel;

@property (weak, nonatomic) IBOutlet UIButton *delButton;

@property (assign, nonatomic) DeviceType type;

@property (weak, nonatomic) id weakModel;

@property (weak, nonatomic) id <PCDeviceManagerCellProtcol>protcol;

@end
