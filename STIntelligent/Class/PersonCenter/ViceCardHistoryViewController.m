//
//  ViceCardHistoryViewController.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/11.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "ViceCardHistoryViewController.h"
#import "ViceCardOpenDoorViewController.h"

#import "ViceCardHistoryTableView.h"

@interface ViceCardHistoryViewController () <ViceCardHistoryTableViewDelegate>

@property (nonatomic, strong) ViceCardHistoryTableView *tableView;

@property (nonatomic, strong) UIButton *bottomBtn;

@end

@implementation ViceCardHistoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"副卡邀请记录";
    
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
    
    [self.tableView.mj_header beginRefreshing];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)newInviteAction
{
    ViceCardOpenDoorViewController *vc = [[ViceCardOpenDoorViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - get
- (ViceCardHistoryTableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[ViceCardHistoryTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate1 = self;
    }
    return _tableView;
}

- (UIButton *)bottomBtn
{
    if (!_bottomBtn)
    {
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomBtn setBackgroundImage:ImageWithColor([UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.buttonColor]) forState:UIControlStateNormal];
        [_bottomBtn setBackgroundImage:ImageWithColor([UIColor lightGrayColor]) forState:UIControlStateDisabled];
        [_bottomBtn setTitle:@"新增邀请" forState:UIControlStateNormal];
        [_bottomBtn setTitleColor:Color_White forState:UIControlStateNormal];
        _bottomBtn.layer.cornerRadius = 4;
        _bottomBtn.clipsToBounds = YES;
        _bottomBtn.titleLabel.font = Font_sys_16;
        [_bottomBtn addTarget:self action:@selector(newInviteAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBtn;
}

#pragma mark ViceCardHistoryTableViewDelegate
- (void)viceCardHistoryTableView:(ViceCardHistoryTableView *)menu sourceAryCount:(NSInteger)sourceAryCount
{
    if (sourceAryCount < 3) {
        self.bottomBtn.enabled = YES;
        [_bottomBtn setTitle:@"新增邀请" forState:UIControlStateNormal];
    }
    else {
        self.bottomBtn.enabled = NO;
        [_bottomBtn setTitle:@"已上限3人，请删除后再邀请" forState:UIControlStateNormal];
    }
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
