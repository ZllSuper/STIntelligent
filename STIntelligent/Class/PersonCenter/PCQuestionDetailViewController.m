//
//  PCQuestionDetailViewController.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/12.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "PCQuestionDetailViewController.h"
#import "OpenDoorFooterView.h"
#import "PCCommunityDetailContentCell.h"

@interface PCQuestionDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) OpenDoorFooterView *sectionHeader;

@property (nonatomic, strong) PCCommunityDetailContentCell *contentCell;

@property (nonatomic, weak) PCQuestionModel *model;

@end

@implementation PCQuestionDetailViewController

- (instancetype)initWithQuestionModel:(PCQuestionModel *)model
{
    if (self = [super init])
    {
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"问题反馈";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(8, 0, 0, 0));
    }];
    
    // Do any additional setup after loading the view.
}

#pragma mark - tableView delegate dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [PCCommunityDetailContentCell cellHeightWithContent:self.model.Text];
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.sectionHeader;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.contentCell.contentLabel.text = self.model.Text;
    return self.contentCell;
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

- (OpenDoorFooterView *)sectionHeader
{
    if (!_sectionHeader)
    {
        _sectionHeader = [[OpenDoorFooterView alloc] initWithReuseIdentifier:@"sectionHeader"];
        _sectionHeader.contentView.backgroundColor = Color_White;
        _sectionHeader.titleLabel.text = [NSString stringWithFormat:@"问题：%@",self.model.Name];
    }
    return _sectionHeader;
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
