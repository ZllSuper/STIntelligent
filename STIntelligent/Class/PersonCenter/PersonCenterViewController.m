//
//  PersonCenterViewController.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/10.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "PersonCenterViewController.h"
#import "PCCommunityManagerViewController.h"
#import "PCAuthViewController.h"
#import "InviteOpenDoorViewController.h"
#import "PCDeviceManagerViewController.h"
#import "PCQuestionViewController.h"
#import "PCSystemSettingViewController.h"
#import "PCAccountInfoViewController.h"

#import "PersonCenterCell.h"
#import "PersonCenterHeaderView.h"

#import "PCInviteDoorCountRequest.h"
#import "UIImageView+WebCache.h"


@interface PersonCenterViewController () <UITableViewDelegate, UITableViewDataSource,STThemeManagerProtcol>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) PersonCenterHeaderView *headerView;

@property (nonatomic, strong) NSArray *sourceAry;



@end

@implementation PersonCenterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[STThemeManager shareInstance] addThemeChangeProtcol:self];
    
    [self themeChange];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"PersonCenterSource" ofType:@"plist"];
    self.sourceAry = [NSArray arrayWithContentsOfFile:path];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsZero);
    }];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIApplicationBackgroundFetchIntervalNever;
    }
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.headerView.nameLabel.text = StringIsEmpty(KAccountInfo.name) ? KAccountInfo.phone : KAccountInfo.name;
    if (!StringIsEmpty(KAccountInfo.photo))
    {
        NSLog(@"KAccountInfo.photo:%@", KAccountInfo.photo);
//        [self.headerView.headerImageView bxh_imageWithUrlStr:KAccountInfo.photo placeholderImage:ImageWithName(@"PersonCenterHeaderDefault")];
        [self.headerView.headerImageView sd_setImageWithURL:[NSURL URLWithString:KAccountInfo.photo] placeholderImage:ImageWithName(@"PersonCenterHeaderDefault")];
    }
    else
    {
        self.headerView.headerImageView.image = ImageWithName(@"PersonCenterHeaderDefault");
    }
    
    [self inviteCountRequet];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)themeChange
{
    self.headerView.titleLabel.textColor = [UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.navBarTextColor];
    self.headerView.bottomView.openDoorCountLabel.textColor = [UIColor getHexColorWithHexStr: [STThemeManager shareInstance].themeColor.barSelTextColor];
    self.headerView.bottomView.inviteOpenDoorCountLabel.textColor = [UIColor getHexColorWithHexStr: [STThemeManager shareInstance].themeColor.barSelTextColor];
    [self.tableView reloadData];
}

#pragma mark - request
- (void)inviteCountRequet
{
    PCInviteDoorCountRequest *request = [[PCInviteDoorCountRequest alloc] init];
    request.cUserId = KAccountInfo.userId;
    BXHWeakObj(self);
    [request requestWithSuccess:^(BXHBaseRequest *request) {
        if ([request.response.code intValue] == 200)
        {
            selfWeak.headerView.bottomView.openDoorCountLabel.text = [NSString stringWithFormat:@"%ld",[request.response.data[@"OpenDoor"] integerValue]];
            selfWeak.headerView.bottomView.inviteOpenDoorCountLabel.text = [NSString stringWithFormat:@"%ld",[request.response.data[@"Invitation"] integerValue]];

        }
        else
        {
            ToastShowBottom(request.response.message);
        }
    } failure:^(NSError *error, BXHBaseRequest *request) {
        ToastShowBottom(NetWorkErrorTip);
    }];

}

#pragma mark - action
- (void)accountInfoAction
{
    PCAccountInfoViewController *vc = [[PCAccountInfoViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - dataSource delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sourceAry.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.sourceAry[indexPath.row];
    PersonCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:[PersonCenterCell className]];
    cell.iconImageView.image = ThemeImageWithName(dict[@"image"]);
    cell.titleLabel.text = dict[@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row)
    {
//        case 0:
//        {
//            PCAuthViewController *vc = [[PCAuthViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//            break;
        case 0:
        {
            PCCommunityManagerViewController *vc = [[PCCommunityManagerViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            InviteOpenDoorViewController *vc = [[InviteOpenDoorViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            PCDeviceManagerViewController *vc = [[PCDeviceManagerViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            PCQuestionViewController *vc = [[PCQuestionViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:
        {
            PCSystemSettingViewController *vc = [[PCSystemSettingViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:
        {
            
        }
            break;
 
        default:
            break;
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
        _tableView.tableHeaderView = self.headerView;
        [_tableView registerNib:[UINib nibWithNibName:[PersonCenterCell className] bundle:nil] forCellReuseIdentifier:[PersonCenterCell className]];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (PersonCenterHeaderView *)headerView
{
    if (!_headerView)
    {
        _headerView = [[PersonCenterHeaderView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREENWIDTH, 790 / 1080.0 * DEF_SCREENWIDTH)];
        _headerView.headerImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(accountInfoAction)];
        [_headerView.headerImageView addGestureRecognizer:tap];
    }
    return _headerView;
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
