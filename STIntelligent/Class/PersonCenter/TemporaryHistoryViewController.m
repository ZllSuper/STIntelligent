//
//  TemporaryHistoryViewController.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/7/12.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "TemporaryHistoryViewController.h"
#import "TemporaryOpenDoorViewController.h"


#import "TemporaryHistoryTableView.h"

@interface TemporaryHistoryViewController ()

@property (nonatomic, strong) TemporaryHistoryTableView *tableView;

@property (nonatomic, strong) UIButton *bottomBtn;

@end

@implementation TemporaryHistoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"临时邀请记录";
    
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

- (void)newInviteAction
{
    TemporaryOpenDoorViewController *vc = [[TemporaryOpenDoorViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - get
- (TemporaryHistoryTableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[TemporaryHistoryTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    }
    return _tableView;
}

- (UIButton *)bottomBtn
{
    if (!_bottomBtn)
    {
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomBtn.backgroundColor = [UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.buttonColor];
        [_bottomBtn setTitle:@"新增邀请" forState:UIControlStateNormal];
        [_bottomBtn setTitleColor:Color_White forState:UIControlStateNormal];
        _bottomBtn.layer.cornerRadius = 4;
        _bottomBtn.clipsToBounds = YES;
        _bottomBtn.titleLabel.font = Font_sys_16;
        [_bottomBtn addTarget:self action:@selector(newInviteAction) forControlEvents:UIControlEventTouchUpInside];
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
