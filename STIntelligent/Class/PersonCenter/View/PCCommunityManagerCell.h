//
//  PCCommunityManagerCell.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/10.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PCCommunityListModel.h"
#import "PCCommunityModel.h"


@interface PCCommunityManagerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *statueLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) PCCommunityListModel *listWeakModel;

@property (weak, nonatomic) PCCommunityModel *weakModel;

@end
