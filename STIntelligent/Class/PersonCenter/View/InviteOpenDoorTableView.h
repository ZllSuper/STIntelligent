//
//  InviteOpenDoorTableView.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/11.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCAuthCell.h"
#import "OpenDoorFooterView.h"
#import "OpenDoorCommunityCell.h"

#import "ODCommunityListRequest.h"

#import "ODCommunityModel.h"

@class InviteOpenDoorTableView;

@protocol InviteOpenDoorTableViewdelegate <NSObject>

- (void)tableViewInviteDoorChange:(InviteOpenDoorTableView *)tableView;

@end

@interface InviteOpenDoorTableView : BaseTableView <OpenDoorCommunityCellProtcol>

@property (nonatomic, strong) PCAuthCell *nameCell;

@property (nonatomic, strong) PCAuthCell *releationShipCell;

@property (nonatomic, strong) OpenDoorFooterView *titleFooterView;

@property (nonatomic, weak) id <InviteOpenDoorTableViewdelegate>inviteDelegate;

@end
