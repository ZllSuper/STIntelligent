//
//  MessageViewController.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/10.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageSegmentView.h"
#import "AlarmMessageTableView.h"
#import "SystemMessageTableView.h"
#import "MessageContentViewController.h"

@interface MessageViewController () <MessageSegmentViewDelegate,STThemeManagerProtcol>

@property (nonatomic, strong) MessageSegmentView *segmentView;

@property (nonatomic, strong) AlarmMessageTableView *alarmTableView;

@property (nonatomic, strong) SystemMessageTableView *systemTableView;

@end

@implementation MessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[STThemeManager shareInstance] addThemeChangeProtcol:self];
    
    self.title = @"消息";
    
    [self.view addSubview:self.segmentView];
    [self.view addSubview:self.alarmTableView];
    [self.view addSubview:self.systemTableView];
    
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.mas_equalTo(self.view);
        make.height.mas_equalTo(@44);
    }];
    
    [self.alarmTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.segmentView.mas_bottom);
    }];
    
    [self.systemTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.segmentView.mas_bottom);
    }];
    
    [self.alarmTableView.mj_header beginRefreshing];
    
    __weak typeof(self) weakSelf = self;
    [self.systemTableView tableViewDidSelectCallBack:^(BaseTableView *tableView, NSIndexPath *indexPath) {
       
        SystemMessageModel *messageModel = tableView.soureAry[indexPath.section];
        MessageContentType contentType = MessageContentTextType;
        if([TSRegularExpressionUtil urlValidation:messageModel.Content])
        {
            contentType = MessageContentWebType;
        }
        MessageContentViewController *vc = [[MessageContentViewController alloc] initWithContentType:contentType andSystemModel:messageModel];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)themeChange
{
    [self.alarmTableView reloadData];
    [self.systemTableView reloadData];
}

#pragma mark - segmentDelegate
- (void)segmentView:(MessageSegmentView *)segmentView btnSelectIndex:(NSInteger)index
{
    if (index == 0)
    {
        self.alarmTableView.hidden = NO;
        self.systemTableView.hidden = YES;
    }
    else
    {
        self.alarmTableView.hidden = YES;
        self.systemTableView.hidden = NO;
        if (self.systemTableView.soureAry.count <= 0)
        {
            [self.systemTableView.mj_header beginRefreshing];
        }
    }
}

#pragma mark - get
- (MessageSegmentView *)segmentView
{
    if(!_segmentView)
    {
        _segmentView = [[MessageSegmentView alloc] initWithLeftTitle:@"报警消息" andRightTitle:@"系统消息"];
        _segmentView.delegate = self;
    }
    return _segmentView;
}

- (AlarmMessageTableView *)alarmTableView
{
    if (!_alarmTableView)
    {
        _alarmTableView = [[AlarmMessageTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _alarmTableView.tableFooterView = [UIView new];

    }
    return _alarmTableView;
}

- (SystemMessageTableView *)systemTableView
{
    if (!_systemTableView)
    {
        _systemTableView = [[SystemMessageTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _systemTableView.hidden = YES;
        _systemTableView.tableFooterView = [UIView new];
    }
    return _systemTableView;
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
