//
//  TemporaryHistoryTableView.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/7/12.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "BaseTableView.h"
#import "TemporaryHistoryCell.h"
#import "TemporaryHistoryListRequest.h"
#import "TemporaryHistoryModel.h"
#import "PCDelTemporaryHistoryRequest.h"
#import "ODTemporaryOpenDoorRequest.h"
#import "WXApiRequestHandler.h"
#import "WXApiManager.h"

@interface TemporaryHistoryTableView : BaseTableView <TemporaryHistoryCellProtcol,WXApiManagerDelegate, UIAlertViewDelegate>

@property (nonatomic, weak) TemporaryHistoryModel *delWeakModel;

@end
