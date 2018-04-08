//
//  PCDeviceManagerTableView.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/12.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "PCDeviceManagerTableView.h"

@implementation PCDeviceManagerTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style])
    {
        [self creatHeader];
        [self registerNib:[UINib nibWithNibName:[PCDeviceManegerCell className] bundle:nil] forCellReuseIdentifier:[PCDeviceManegerCell className]];
    }
    return self;
}

#pragma mark - request
- (void)requestViewSource:(BOOL)refresh
{
    BXHWeakObj(self);
    PCDeviceListRequest *request = [[PCDeviceListRequest alloc] init];
    request.communityUserId = KAccountInfo.userId;
    [request requestWithSuccess:^(BXHBaseRequest *request) {
        [self endRefresh];
        if ([request.response.code integerValue] == 200)
        {
            [selfWeak.soureAry removeAllObjects];
            [selfWeak.soureAry addObjectsFromArray:[MaoYanModel bxhObjectArrayWithKeyValuesArray:request.response.data[@"CatEyes"]]];
            [selfWeak.soureAry addObjectsFromArray:[SheXiangTouModel bxhObjectArrayWithKeyValuesArray:request.response.data[@"Cameras"]]];
            [selfWeak reloadData];
//            selfWeak.soureAry = [PCCommunityListModel bxhObjectArrayWithKeyValuesArray:request.response.data];
//            [selfWeak reloadData];
        }
        else
        {
            ToastShowBottom(request.response.message);
        }
        
    } failure:^(NSError *error, BXHBaseRequest *request) {
        ToastShowBottom(NetWorkErrorTip);
        
    }];
}

- (void)cameraDelReqyest:(SheXiangTouModel *)weakModel
{
    __block SheXiangTouModel *blockModel = weakModel;
    CameraDelRequest *request = [[CameraDelRequest alloc] init];
    request.deviceSerial = weakModel.deviceSerialNo;
    request.num = @"1";
    BXHWeakObj(self);
    ProgressShow(self.superview);
    [request requestWithSuccess:^(BXHBaseRequest *request) {
        ProgressHidden(selfWeak.superview);
        if ([request.response.code integerValue] == 200)
        {
            [selfWeak.soureAry removeObject:blockModel];
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

- (void)maoYanDelRequest:(MaoYanModel *)maoYanModel
{
    __block MaoYanModel *blockModel = maoYanModel;
    MaoYanDelRequest *request = [[MaoYanDelRequest alloc] init];
    request.deviceSerial = maoYanModel.bid;
    BXHWeakObj(self);
    ProgressShow(self.superview);
    [request requestWithSuccess:^(BXHBaseRequest *request) {
        ProgressHidden(selfWeak.superview);
        if ([request.response.code integerValue] == 200)
        {
            [selfWeak.soureAry removeObject:blockModel];
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

#pragma mark - protcol
- (void)managerCellDelAction:(PCDeviceManegerCell *)cell
{
    __weak typeof(self) weakSelf = self;
    __block PCDeviceManegerCell *blockCell = cell;
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"删除设备" message:@"确认删除当前设备吗" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        BXHStrongObj(weakSelf);
        if (blockCell.type == DeviceTypeMaoYan)
        {
            [weakSelfStrong maoYanDelRequest:blockCell.weakModel];
        }
        else
        {
            [weakSelfStrong cameraDelReqyest:blockCell.weakModel];
        }
    }]];
    [MainAppDelegate.mainTabBarController presentViewController:alertVC animated:YES completion:nil];
}

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
    return 58;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PCDeviceManegerCell *cell = [tableView dequeueReusableCellWithIdentifier:[PCDeviceManegerCell className]];
    [cell.delButton setTitleColor:[UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.barSelTextColor] forState:UIControlStateNormal];
    cell.delButton.layer.borderColor = [UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.barSelTextColor].CGColor;
    
    id model = self.soureAry[indexPath.section];
    
    cell.type = [model isKindOfClass:[SheXiangTouModel class]] ? DeviceTypeCamera : DeviceTypeMaoYan;
    cell.weakModel = model;
    cell.protcol = self;
    return cell;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
