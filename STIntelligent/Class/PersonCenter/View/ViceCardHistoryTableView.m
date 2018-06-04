//
//  ViceCardHistoryTableView.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/11.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "ViceCardHistoryTableView.h"

@implementation ViceCardHistoryTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style])
    {
        [self creatHeader];
        [self registerNib:[UINib nibWithNibName:[ViceCardHistoryCell className] bundle:nil] forCellReuseIdentifier:[ViceCardHistoryCell className]];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        ADD_NOTIFICATIOM(@selector(refreshViceCardListNoti), kRefreshViceCardListNotification, nil);

    }
    return self;
}

- (void)dealloc
{
    REMOVE_NOTIFICATION(kRefreshViceCardListNotification, nil);
}

- (void)requestViewSource:(BOOL)refresh
{
    ViceCardHistoryListRequest *request = [[ViceCardHistoryListRequest alloc] init];
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
            
            if (selfWeak.delegate1 && [selfWeak.delegate1 respondsToSelector:@selector(viceCardHistoryTableView:sourceAryCount:)]) {
                [selfWeak.delegate1 viceCardHistoryTableView:selfWeak sourceAryCount:selfWeak.soureAry.count];
            }
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
    PCDelViceCardHistoryRequest *request = [[PCDelViceCardHistoryRequest alloc] init];
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
            
            if (selfWeak.delegate1 && [selfWeak.delegate1 respondsToSelector:@selector(viceCardHistoryTableView:sourceAryCount:)]) {
                [selfWeak.delegate1 viceCardHistoryTableView:selfWeak sourceAryCount:selfWeak.soureAry.count];
            }
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.soureAry.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 8;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.1;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ViceCardHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:[ViceCardHistoryCell className]];
    cell.protcol = self;
    cell.weakModel = self.soureAry[indexPath.section];
    return cell;
}

- (void)cellRigthBtnAction:(ViceCardHistoryCell *)cell
{    
    self.delWeakModel = cell.weakModel;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认要删除该副卡授权吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 100;
    [alert show];
}


#pragma mark Notifications
- (void)refreshViceCardListNoti
{
    [self requestViewSource:YES];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
        if (buttonIndex == 1) {
            [self delHistoryRequest:self.delWeakModel];
        }
        self.delWeakModel = nil;
    }
}

@end
