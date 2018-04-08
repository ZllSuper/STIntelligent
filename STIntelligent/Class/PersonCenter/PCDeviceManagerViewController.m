//
//  PCDeviceManagerViewController.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/12.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "PCDeviceManagerViewController.h"
#import "PCDeviceManagerTableView.h"
#import "MaoYanDeviceSettingViewController.h"
#import "CarmeraDeviceSettingViewController.h"
#import "STYSTokenGetRequest.h"

@interface PCDeviceManagerViewController () <STThemeManagerProtcol>

@property (nonatomic, strong) PCDeviceManagerTableView *tableView;

@end

@implementation PCDeviceManagerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"设备管理";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsZero);
    }];
    
    
    [[STThemeManager shareInstance] addThemeChangeProtcol:self];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView tableViewDidSelectCallBack:^(BaseTableView *tableView, NSIndexPath *indexPath) {
        PCDeviceManegerCell *cell = (PCDeviceManegerCell *)[tableView cellForRowAtIndexPath:indexPath];
        if (cell.type == DeviceTypeMaoYan)
        {
            MaoYanDeviceSettingViewController *vc = [[MaoYanDeviceSettingViewController alloc] init];
            vc.weakModel = cell.weakModel;
            vc.weakModel.uid = [(MaoYanModel *)cell.weakModel bid];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            if (!StringIsEmpty(KAccountInfo.cameraAccessToken))
            {
                [weakSelf goToVcWithWeakModel:cell.weakModel];
            }
            else
            {
                [weakSelf cameraAccessTokenGet:cell.weakModel];
            }
        }
    }];
    // Do any additional setup after loading the view.
}

- (void)goToVcWithWeakModel:(SheXiangTouModel *)model
{
    CarmeraDeviceSettingViewController *vc = [[CarmeraDeviceSettingViewController alloc] init];
    vc.weakModel = model;
    [EZOpenSDK setAccessToken:KAccountInfo.cameraAccessToken];
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)cameraAccessTokenGet:(SheXiangTouModel *)cameraModel
{
    STYSTokenGetRequest *request = [[STYSTokenGetRequest alloc] init];
    request.communityUserId = KAccountInfo.userId;
    __block SheXiangTouModel *blockModel = cameraModel;
    BXHWeakObj(self);
    ProgressShow(self.view);
    [request requestWithSuccess:^(BXHBaseRequest *request) {
        ProgressHidden(selfWeak.view);
        if ([request.response.code integerValue] == 200)
        {
            KAccountInfo.cameraAccessToken = request.response.data[@"Token"];
            [selfWeak goToVcWithWeakModel:blockModel];
            [KAccountInfo saveToDisk];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)themeChange
{
    [self.tableView reloadData];
}

#pragma mark - get
- (PCDeviceManagerTableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[PCDeviceManagerTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    }
    return _tableView;
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
