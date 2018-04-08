//
//  CarmeraDeviceSettingViewController.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/19.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "CarmeraDeviceSettingViewController.h"
#import "DevicePicViewController.h"
#import "DeviceEditNameViewController.h"

#import "CameraSettingHeader.h"
#import "DeviceSettingRightCell.h"
#import "OpenDoorCommunityCell.h"
#import "DeviceListModel.h"

#import "EZOpenSDKHeader.h"

#import "CameraDelRequest.h"


@interface CarmeraDeviceSettingViewController () <UITableViewDelegate, UITableViewDataSource, OpenDoorCommunityCellProtcol, UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *sourceAry;

@property (nonatomic, strong) UIButton *bottomBtn;

@end

@implementation CarmeraDeviceSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"设备管理";
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CameraSettingSource" ofType:@"plist"];
    NSArray *ary = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *mAry = [NSMutableArray array];
    for (NSArray *inAry in ary)
    {
        [mAry addObject:[DeviceListModel bxhObjectArrayWithKeyValuesArray:inAry]];
    }
    self.sourceAry = [NSArray arrayWithArray:mAry];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomBtn];
    
    [self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(16);
        make.right.mas_equalTo(self.view).offset(-16);
        make.bottom.mas_equalTo(self.view).offset(-10);
        make.height.mas_equalTo(@44);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.bottomBtn.mas_top).offset(10);
    }];
    
    if(!self.deviceInfo)
    {
        __weak typeof(self) weakSelf = self;
        ProgressShow(self.view);
        [EZOpenSDK getDeviceInfo:self.weakModel.deviceSerialNo completion:^(EZDeviceInfo *deviceInfo, NSError *error) {
            ProgressHidden(weakSelf.view);
            if (error)
            {
                ToastShowBottom(@"获取失败");
            }
            else
            {
                weakSelf.deviceInfo = deviceInfo;
            }
        }];
    }
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [(BaseNaviController *)self.navigationController setAutorotate:NO];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action
- (void)delDeviceAction
{
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"删除设备" message:@"确认删除当前设备吗" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf cameraDelReqyest];
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

#pragma mark - request
- (void)cameraDelReqyest
{
    CameraDelRequest *request = [[CameraDelRequest alloc] init];
    request.deviceSerial = [self.deviceInfo deviceSerial];
    request.num = @"1";
    BXHWeakObj(self);
    ProgressShow(self.view);
    [request requestWithSuccess:^(BXHBaseRequest *request) {
        ProgressHidden(selfWeak.view);
        if ([request.response.code integerValue] == 200)
        {
            selfWeak.weakModel.deviceSerialNo = @"";
            selfWeak.weakModel.deviceVerifyCode = @"";
            selfWeak.weakModel.Icon = @"";
            selfWeak.weakModel.Name = @"";
            BOOL needPop = NO;
            for (UIViewController *vc in selfWeak.navigationController.viewControllers)
            {
                if ([vc isKindOfClass:NSClassFromString(@"PCDeviceManagerViewController")])
                {
                    needPop = YES;
                    break;
                }
            }
            if (needPop)
            {
                [selfWeak.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [selfWeak.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
        }
        else
        {
            ToastShowBottom(request.response.message);
        }
    } failure:^(NSError *error, BXHBaseRequest *request) {
        ProgressHidden(selfWeak.view);
        ToastShowBottom(NetWorkErrorTip);
    }];
}

#pragma mark - tableDelegate dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sourceAry.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *ary = self.sourceAry[section];
    return ary.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *ary = self.sourceAry[indexPath.section];
    DeviceListModel *model = ary[indexPath.row];
    NSInteger cellType = [model.cellType integerValue];
    if (cellType == 2)
    {
        DeviceSettingRightCell *cell = [tableView dequeueReusableCellWithIdentifier:[DeviceSettingRightCell className]];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.titleLabel.text = model.title;
        cell.rightLabel.text = self.deviceInfo.deviceVersion;
        return cell;
    }
    else if (cellType == 3)
    {
        OpenDoorCommunityCell *cell = [tableView dequeueReusableCellWithIdentifier:[OpenDoorCommunityCell className]];
        cell.protcol = self;
        cell.titleLabel.text = model.title;
        if (indexPath.row == 0)
        {
            cell.switchBtn.on = self.deviceInfo.isEncrypt;
        }
        else if (indexPath.row == 1)
        {
            cell.switchBtn.on = self.deviceInfo.defence;
        }
    
        
        return cell;
    }
    else
    {
        DeviceSettingRightCell *cell = [tableView dequeueReusableCellWithIdentifier:[DeviceSettingRightCell className]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.titleLabel.text = model.title;
        if (indexPath.row == 0)
        {
            cell.rightLabel.text = self.weakModel.Name;
        }
        else
        {
            cell.rightLabel.text = @"";
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 1)
    {
        DevicePicViewController *vc = [[DevicePicViewController alloc] initWithDeviceType:DeviceCameraPicType devicModel:self.weakModel];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == 0 && indexPath.row == 0)
    {
        DeviceEditNameViewController *vc = [[DeviceEditNameViewController alloc] initWithWeakModel:self.weakModel andType:DeviceCameraPicType];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    OpenDoorCommunityCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    if (buttonIndex == 1)
    {
        ProgressShow(self.view);
        BXHWeakObj(self);
        BXHBlockObj(cell);
        NSString *smsCode = [alertView textFieldAtIndex:0].text;
        [EZOpenSDK setDeviceEncryptStatus:self.deviceInfo.deviceSerial
                               verifyCode:smsCode
                                  encrypt:NO
                               completion:^(NSError *error) {
                                   ProgressHidden(selfWeak.view);
                                   if (!error)
                                   {
                                       selfWeak.deviceInfo.isEncrypt = NO;
                                   }
                                   else
                                   {
                                       ToastShowBottom(@"操作失败");
                                       cellblock.switchBtn.on = YES;
                                   }
                               }];
    } else {
        cell.switchBtn.on = NO;
    }
}


#pragma mark - protcol
- (void)cell:(OpenDoorCommunityCell *)cell switchBtnAction:(LQXSwitch *)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.row == 0)
    {
        if(!sender.on)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"设备操作安全验证" message:@"请输入该设备的设备验证码（设备标签上的6位字母）" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alertView show];
        }
        else
        {
            ProgressShow(self.view);
            BXHWeakObj(self);
            BXHBlockObj(sender);
            [EZOpenSDK setDeviceEncryptStatus:self.deviceInfo.deviceSerial
                                   verifyCode:nil
                                      encrypt:YES
                                   completion:^(NSError *error) {
                                       ProgressHidden(selfWeak.view);
                                       if (!error)
                                       {
                                           selfWeak.deviceInfo.isEncrypt = YES;
                                       }
                                       else
                                       {
                                           ToastShowBottom(@"操作失败");
                                           senderblock.on = NO;
                                       }
                                   }];
        }
    }
    else if (indexPath.row == 1)
    {
        ProgressShow(self.view);
        BXHWeakObj(self);
        BXHBlockObj(sender);
        [EZOpenSDK setDefence:sender.on
                 deviceSerial:self.deviceInfo.deviceSerial
                   completion:^(NSError *error) {
                       ProgressHidden(self.view);
                       selfWeak.deviceInfo.defence = senderblock.on;
                   }];

    }
    
}
#pragma mark - get
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREENWIDTH, 0) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerNib:[UINib nibWithNibName:[DeviceSettingRightCell className] bundle:nil] forCellReuseIdentifier:[DeviceSettingRightCell className]];
        [_tableView registerClass:[OpenDoorCommunityCell class] forCellReuseIdentifier:[OpenDoorCommunityCell className]];
    }
    return _tableView;
}


- (UIButton *)bottomBtn
{
    if (!_bottomBtn)
    {
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomBtn.backgroundColor = Color_Clear;
        [_bottomBtn setTitle:@"删除设备" forState:UIControlStateNormal];
        [_bottomBtn setTitleColor: [UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.buttonColor] forState:UIControlStateNormal];
        _bottomBtn.layer.cornerRadius = 4;
        _bottomBtn.clipsToBounds = YES;
        _bottomBtn.layer.borderColor =  [UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.buttonColor].CGColor;
        _bottomBtn.layer.borderWidth = 1;
        _bottomBtn.titleLabel.font = Font_sys_16;
        [_bottomBtn addTarget:self action:@selector(delDeviceAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBtn;
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
