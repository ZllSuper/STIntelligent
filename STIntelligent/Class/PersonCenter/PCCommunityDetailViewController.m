//
//  PCCommunityDetailViewController.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/10.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "PCCommunityDetailViewController.h"
#import "PCCommunityDetailTitleCell.h"
#import "PCCommunityDetailContentCell.h"

@interface PCCommunityDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) PCCommunityDetailTitleCell *nameCell;

@property (nonatomic, strong) PCCommunityDetailTitleCell *addressCell;

@property (nonatomic, strong) PCCommunityDetailTitleCell *introCell;

@property (nonatomic, strong) PCCommunityDetailContentCell *contentCell;

@end

@implementation PCCommunityDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"社区详情";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView delegate dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
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
    if (indexPath.section == 1)
    {
        if (indexPath.row == 1)
        {
            return [PCCommunityDetailContentCell cellHeightWithContent:self.listModel.CommunityIntroduce];
        }
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            return self.nameCell;
        }
        else
        {
            return self.addressCell;
        }
    }
    else
    {
        if (indexPath.row == 0)
        {
            return self.introCell;
        }
        else
        {
            self.contentCell.contentLabel.text = self.listModel.CommunityIntroduce;
            return self.contentCell;
        }
    }
}

#pragma mark - get
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (PCCommunityDetailTitleCell *)nameCell
{
    if (!_nameCell)
    {
        _nameCell = [PCCommunityDetailTitleCell viewFromXIB];
        _nameCell.titleLabel.text = @"社区名称";
        _nameCell.contentLabel.text = self.listModel.CommunityName;
    }
    return _nameCell;
}

- (PCCommunityDetailTitleCell *)addressCell
{
    if (!_addressCell)
    {
        _addressCell = [PCCommunityDetailTitleCell viewFromXIB];
        _addressCell.titleLabel.text = @"社区地址";
        _addressCell.contentLabel.text = self.listModel.CommunityAddress;
    }
    return _addressCell;
}

- (PCCommunityDetailTitleCell *)introCell
{
    if (!_introCell)
    {
        _introCell = [PCCommunityDetailTitleCell viewFromXIB];
        _introCell.titleLabel.text = @"社区介绍";
        _introCell.contentLabel.hidden = YES;
    }
    return _introCell;
}

- (PCCommunityDetailContentCell *)contentCell
{
    if (!_contentCell)
    {
        _contentCell = [PCCommunityDetailContentCell viewFromXIB];
    }
    return _contentCell;
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
