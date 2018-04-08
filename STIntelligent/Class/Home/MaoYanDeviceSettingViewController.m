//
//  MaoYanDeviceSettingViewController.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/19.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "MaoYanDeviceSettingViewController.h"
#import "DevicePicViewController.h"
#import "DeviceEditNameViewController.h"

#import "DeviceSettingRightCell.h"
#import "OpenDoorCommunityCell.h"
#import "DeviceListModel.h"

#import "MaoYanDelRequest.h"

#import <EquesBusiness/YKBusinessFramework.h>

@interface MaoYanDeviceSettingViewController ()<UITableViewDelegate, UITableViewDataSource,EquesBusinessHelperProtcol,OpenDoorCommunityCellProtcol>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *sourceAry;

@property (nonatomic, strong) UIButton *bottomBtn;

@end

@implementation MaoYanDeviceSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"设备管理";
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MaoYanSettingSource" ofType:@"plist"];
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
    
    
    [[EquesBusinessHelper shareInstance] addProtcol:self forMethod:MAOYAN_DEVICEDETAIL_METHOD];
    [[EquesBusinessHelper shareInstance] addProtcol:self forMethod:MAOYAN_DELRESULT_METHOD];
    [[EquesBusinessHelper shareInstance] addProtcol:self forMethod:MAOYAN_LIGHTENABLE_METHOD];
    [[EquesBusinessHelper shareInstance] addProtcol:self forMethod:MAOYAN_PERSONCHECK_METHOD];

    ProgressShow(self.view);
    [YKBusinessFramework equesGetDeviceInfoWithUid:self.weakModel.uid];

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

#pragma mark - request
- (void)maoYanDelRequest
{
    MaoYanDelRequest *request = [[MaoYanDelRequest alloc] init];
    request.deviceSerial = self.weakModel.bid;
    BXHWeakObj(self);
    ProgressShow(self.view);
    [request requestWithSuccess:^(BXHBaseRequest *request) {
        ProgressHidden(selfWeak.view);
        if ([request.response.code integerValue] == 200)
        {
            [YKBusinessFramework equesDelDeviceWithBid:selfWeak.weakModel.bid];
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

#pragma mark - action
- (void)delDeviceAction
{
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"删除设备" message:@"确认删除当前设备吗" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf maoYanDelRequest];
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - protcol
- (void)equesBusinessHelper:(EquesBusinessHelper *)helper messageDict:(NSDictionary *)messageDict
{
    NSString *method = messageDict[@"method"];
    if([method isEqualToString:MAOYAN_DELRESULT_METHOD])
    {
        NSNumber *code = messageDict[@"code"];
        if ([code integerValue] == 4000)
        {
            self.weakModel.bid = @"";
            self.weakModel.Name = @"";
            self.weakModel.Icon = @"";
            BOOL needPop = NO;
            for (UIViewController *vc in self.navigationController.viewControllers)
            {
                if ([vc isKindOfClass:NSClassFromString(@"PCDeviceManagerViewController")])
                {
                    needPop = YES;
                    break;
                }
            }
            if (needPop)
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
        }
        else
        {
            
        }
    }
    else if ([method isEqualToString:MAOYAN_DEVICEDETAIL_METHOD])
    {
        ProgressHidden(self.view);
        [self.weakModel bxhObjectWithKeyValues:messageDict];
        [self.tableView reloadData];
    }
    else if ([method isEqualToString:MAOYAN_PERSONCHECK_METHOD])
    {
        ProgressHidden(self.view);
        if ([messageDict[@"result"] integerValue] == 1)
        {
            self.weakModel.alarm_enable = [self.weakModel.alarm_enable integerValue] == 1 ? @0 : @1;
        }
        [self.tableView reloadData];
    }
    else if ([method isEqualToString:MAOYAN_LIGHTENABLE_METHOD])
    {
        ProgressHidden(self.view);
        if ([messageDict[@"result"] integerValue] == 1)
        {
            self.weakModel.db_light_enable = [self.weakModel.db_light_enable integerValue] == 1 ? @0 : @1;

        }
        [self.tableView reloadData];
    }
}

- (void)cell:(OpenDoorCommunityCell *)cell switchBtnAction:(LQXSwitch *)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.row == 0)
    {
        ProgressShow(self.view);
        [YKBusinessFramework equesSetDoorbellLightWtihUid:self.weakModel.uid status:sender.on];
    }
    else
    {
        ProgressShow(self.view);
        [YKBusinessFramework equesSetPirEnableWithUid:self.weakModel.uid status:sender.on];
    }
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
        cell.titleLabel.text = model.title;
        cell.accessoryType = UITableViewCellAccessoryNone;
        if (!StringIsEmpty(model.valueKey))
        {
            if (indexPath.row == 1)
            {
                cell.rightLabel.text = [NSString stringWithFormat:@"V%@",[self.weakModel valueForKey:model.valueKey]];
            }
            else
            {
                cell.rightLabel.text = [self.weakModel valueForKey:model.valueKey];
            }
        }
        return cell;
    }
    else if (cellType == 3)
    {
        OpenDoorCommunityCell *cell = [tableView dequeueReusableCellWithIdentifier:[OpenDoorCommunityCell className]];
        cell.protcol = self;
        cell.titleLabel.text = model.title;
        cell.switchBtn.on = [[self.weakModel valueForKey:model.valueKey] integerValue] == 1;
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
        DevicePicViewController *vc = [[DevicePicViewController alloc] initWithDeviceType:DeviceMaoYanPicType devicModel:self.weakModel];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == 0 && indexPath.row == 0)
    {
        DeviceEditNameViewController *vc = [[DeviceEditNameViewController alloc] initWithWeakModel:self.weakModel andType:DeviceMaoYanPicType];
        [self.navigationController pushViewController:vc animated:YES];
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
