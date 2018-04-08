//
//  PCSystemSettingViewController.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/18.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "PCSystemSettingViewController.h"
#import "PCSkinViewController.h"
#import "AboutUsViewController.h"
#import "DeviceSettingRightCell.h"

#import "PCLogoutRequest.h"


@interface PCSystemSettingViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *bottomBtn;

@property (nonatomic, strong) NSArray *sourceAry;

@end

@implementation PCSystemSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"系统设置";
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"PCSystemSettingSource" ofType:@"plist"];
    self.sourceAry = [NSArray arrayWithContentsOfFile:path];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
    }];
    
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - request
- (void)logOutRequest
{
    
    ProgressShow(self.view);
    PCLogoutRequest *request = [[PCLogoutRequest alloc] init];
    request.cUserId = KAccountInfo.userId;
    BXHWeakObj(self);
    [request requestWithSuccess:^(BXHBaseRequest *request) {
        ProgressHidden(selfWeak.view);
        if ([request.response.code intValue] == 200)
        {
            [KAccountInfo logout];
            [MainAppDelegate.loginViewController show];
            MainAppDelegate.window.hidden = YES;
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
- (void)logOut
{
    [self logOutRequest];
}

#pragma mark - dataSource / delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sourceAry.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionAry = self.sourceAry[section];
    return sectionAry.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1)
    {
        return 40;
    }
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DeviceSettingRightCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PCSettingCell"];
    NSArray *sectionAry = self.sourceAry[indexPath.section];
    NSDictionary *dict = [sectionAry objectAtIndex:indexPath.row];
    cell.titleLabel.text = dict[@"title"];
    if (indexPath.section == 1 && indexPath.row == 1)
    {
        cell.rightLabel.text = @"1.0";
        cell.accessoryType = UITableViewCellAccessoryNone;

    }
    else
    {
        cell.rightLabel.text = @"";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0)
    {
        PCSkinViewController *vc = [[PCSkinViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else if (indexPath.row == 0)
    {
        AboutUsViewController *vc = [[AboutUsViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - get
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = self.bottomBtn;
        [_tableView registerNib:[UINib nibWithNibName:@"DeviceSettingRightCell" bundle:nil] forCellReuseIdentifier:@"PCSettingCell"];
    }
    return _tableView;
}

- (UIButton *)bottomBtn
{
    if (!_bottomBtn)
    {
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomBtn.frame = CGRectMake(0, 0, DEF_SCREENWIDTH, 44);
        [_bottomBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [_bottomBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        _bottomBtn.layer.cornerRadius = 4;
        _bottomBtn.clipsToBounds = YES;
        _bottomBtn.titleLabel.font = Font_sys_16;
        [_bottomBtn addTarget:self action:@selector(logOut) forControlEvents:UIControlEventTouchUpInside];
        _bottomBtn.backgroundColor = [UIColor whiteColor];

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
