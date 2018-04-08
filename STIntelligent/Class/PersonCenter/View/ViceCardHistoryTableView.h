//
//  ViceCardHistoryTableView.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/11.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "BaseTableView.h"
#import "ViceCardHistoryCell.h"
#import "ViceCardHistoryListRequest.h"
#import "PCDelViceCardHistoryRequest.h"

@class ViceCardHistoryTableView;
@protocol ViceCardHistoryTableViewDelegate <NSObject>

- (void)viceCardHistoryTableView:(ViceCardHistoryTableView *)menu sourceAryCount:(NSInteger)sourceAryCount;

@end

@interface ViceCardHistoryTableView : BaseTableView <ViceCardHistoryCellProtcol>

@property (nonatomic, weak) id<ViceCardHistoryTableViewDelegate> delegate1;

@end
