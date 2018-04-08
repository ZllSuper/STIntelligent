//
//  PCCommunityManagerViewController.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/10.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "PCCommunityManagerViewController.h"
#import "PCSearchCommunityViewController.h"
#import "PCCommunityDetailViewController.h"

#import "PCCommunityManagerTableView.h"

@interface PCCommunityManagerViewController ()

@property (nonatomic, strong) PCCommunityManagerTableView *tableView;

@property (nonatomic, strong) UIButton *bottomBtn;

@end

@implementation PCCommunityManagerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"社区管理";
    
    [self.view addSubview:self.bottomBtn];
    [self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(16);
        make.right.mas_equalTo(self.view).offset(-16);
        make.height.mas_equalTo(@44);
        make.bottom.mas_equalTo(self.view).offset(-20);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.bottomBtn.mas_top).offset(-20);
    }];
    
    BXHWeakObj(self);
    [self.tableView tableViewDidSelectCallBack:^(BaseTableView *tableView, NSIndexPath *indexPath) {
        PCCommunityDetailViewController *vc = [[PCCommunityDetailViewController alloc] init];
        vc.listModel = tableView.soureAry[indexPath.section];
        [selfWeak.navigationController pushViewController:vc animated:YES];
    }];
    
    [self.tableView.mj_header beginRefreshing];
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

#pragma mark - action
- (void)communityAddAction:(UIButton *)sender
{
    PCSearchCommunityViewController *vc = [[PCSearchCommunityViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - get
- (PCCommunityManagerTableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[PCCommunityManagerTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    }
    return _tableView;
}

- (UIButton *)bottomBtn
{
    if (!_bottomBtn)
    {
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomBtn.backgroundColor = [UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.buttonColor];
        [_bottomBtn setTitle:@"添加社区" forState:UIControlStateNormal];
        [_bottomBtn setTitleColor:Color_White forState:UIControlStateNormal];
        _bottomBtn.layer.cornerRadius = 4;
        _bottomBtn.clipsToBounds = YES;
        _bottomBtn.titleLabel.font = Font_sys_16;
        [_bottomBtn addTarget:self action:@selector(communityAddAction:) forControlEvents:UIControlEventTouchUpInside];
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
