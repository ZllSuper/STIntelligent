//
//  TemporaryHistoryTableView.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/7/12.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "TemporaryHistoryTableView.h"

@implementation TemporaryHistoryTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style])
    {
        [self creatHeader];
        [self registerNib:[UINib nibWithNibName:[TemporaryHistoryCell className] bundle:nil] forCellReuseIdentifier:[TemporaryHistoryCell className]];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;

        ADD_NOTIFICATIOM(@selector(refreshViceCardListNoti), kRefreshTempListNotification, nil);
    }
    return self;
}

- (void)dealloc
{
    REMOVE_NOTIFICATION(kRefreshTempListNotification, nil);
}

#pragma mark - request
- (void)requestViewSource:(BOOL)refresh
{
    TemporaryHistoryListRequest *request = [[TemporaryHistoryListRequest alloc] init];
    request.cUserId = KAccountInfo.userId;
    BXHWeakObj(self);
    ProgressShow(self.superview);
    [request requestWithSuccess:^(BXHBaseRequest *request) {
        [selfWeak endRefresh];
        ProgressHidden(selfWeak.superview);
        if ([request.response.code integerValue] == 200)
        {
            selfWeak.soureAry = [TemporaryHistoryModel bxhObjectArrayWithKeyValuesArray:request.response.data];
            [selfWeak reloadData];
        }
        else
        {
            ToastShowBottom(request.response.message);
        }
    } failure:^(NSError *error, BXHBaseRequest *request) {
        [selfWeak endRefresh];
        ProgressHidden(selfWeak.superview);
        ToastShowBottom(NetWorkErrorTip);
    }];
}

- (void)delHistoryRequest:(TemporaryHistoryModel *)model
{
    PCDelTemporaryHistoryRequest *request = [[PCDelTemporaryHistoryRequest alloc] init];
    request.invitationLogId = [model.listId stringValue];
    BXHWeakObj(self);
    ProgressShow(self.superview);
    BXHBlockObj(model);
    [request requestWithSuccess:^(BXHBaseRequest *request) {
        ProgressHidden(selfWeak.superview);
        if ([request.response.code integerValue] == 200)
        {
            [selfWeak.soureAry removeObject:modelblock];
            [selfWeak reloadData];
        }
        else
        {
            ToastShowBottom(request.response.message);
        }
    } failure:^(NSError *error, BXHBaseRequest *request) {
        ProgressHidden(selfWeak.superview);
        ToastShowBottom(NetWorkErrorTip);
    }];

}

- (void)resendHistoryRequest:(TemporaryHistoryModel *)model
{
    NSString *doorIds = @"";
 
    for (PCDoorModel *dModel in model.Doors)
    {
        doorIds = [NSString stringWithFormat:@"%@%@;",doorIds,[dModel.did stringValue]];
    }

    ODTemporaryOpenDoorRequest *request = [[ODTemporaryOpenDoorRequest alloc] init];
    request.doorIds = doorIds;
    request.cUserId = KAccountInfo.userId;
    request.peopleType = model.PeopleType;
    request.name = model.Name;
    ProgressShow(self.superview);
    BXHWeakObj(self);
    [request requestWithSuccess:^(BXHBaseRequest *request) {
        ProgressHidden(selfWeak.superview);
        if ([request.response.code integerValue] == 200)
        {
            [WXApiManager sharedManager].delegate = self;
            [WXApiRequestHandler sendLinkURL:request.response.data[@"WechatUrl"] TagName:@"" Title:@"" Description:@"" ThumbImage:ImageWithName(@"ShareIcon") InScene:WXSceneSession];
        }
        else
        {
            ToastShowBottom(request.response.message);
        }
    } failure:^(NSError *error, BXHBaseRequest *request) {
        ProgressHidden(selfWeak.superview);
        ToastShowBottom(NetWorkErrorTip);
    }];
}

#pragma mark - wxDelegate
- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *)response;
{
    if (StringIsEmpty(response.errStr))
    {
        ToastShowBottom(@"分享成功");
        [self.mj_header beginRefreshing];
    }
    else
    {
        ToastShowBottom(response.errStr);
    }
}


#pragma mark - overWrite
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.soureAry.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TemporaryHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:[TemporaryHistoryCell className]];
    cell.protcol = self;
    cell.weakModel = self.soureAry[indexPath.section];
    return cell;
}

- (void)cellRigthBtnAction:(TemporaryHistoryCell *)cell
{
    if (!cell.canIvi)
    {
        [self delHistoryRequest:cell.weakModel];
    }
    else
    {
        [self resendHistoryRequest:cell.weakModel];
    }
}

#pragma mark Notifications
- (void)refreshViceCardListNoti
{
    [self requestViewSource:YES];
}

@end
