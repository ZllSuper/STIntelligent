//
//  PCSearchCommunityViewController.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/10.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "PCSearchCommunityViewController.h"
#import "PCCommunityAddViewController.h"

#import "PCCommunityManagerCell.h"

#import "PCCommunitySearchRequest.h"

#import "UIScrollView+EmptyDataSet.h"

@interface PCSearchCommunityViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *sourceAry;

@end

@implementation PCSearchCommunityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"添加社区";
    
    [self.view addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.mas_equalTo(self.view);
        make.height.mas_equalTo(@40);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.searchBar.mas_bottom);
    }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - request
- (void)communitySearchRequest
{
    if (StringIsEmpty(self.searchBar.text))
    {
        ToastShowBottom(@"请输入关键字");
        return;
    }
    PCCommunitySearchRequest *request = [[PCCommunitySearchRequest alloc] init];
    request.keyWord = self.searchBar.text;
    request.cUserId = KAccountInfo.userId;
    request.pageSize = @"1000";
    request.curPage = @"0";
    BXHWeakObj(self);
    ProgressShow(self.view);
    [request requestWithSuccess:^(BXHBaseRequest *request) {
        ProgressHidden(selfWeak.view);
        if ([request.response.code integerValue] == 200)
        {
            selfWeak.sourceAry = [PCCommunityModel bxhObjectArrayWithKeyValuesArray:request.response.data];
            [selfWeak.tableView reloadData];
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

#pragma mark - searchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self communitySearchRequest];
}

#pragma mark - tableViewDelegate datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sourceAry.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PCCommunityManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:[PCCommunityManagerCell className]];
    cell.statueLabel.hidden = YES;
    cell.weakModel = self.sourceAry[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PCCommunityAddViewController *vc = [[PCCommunityAddViewController alloc] initWithCommunityModel:self.sourceAry[indexPath.section]];
    [self.navigationController pushViewController:vc animated:YES];
}


- (nullable UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return ImageWithName(@"EmptyImage");
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:@"亲，暂无数据哦~" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName : Font_sys_14}];
    return attribute;
}


#pragma mark - get
- (UISearchBar *)searchBar
{
    if (!_searchBar)
    {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.placeholder = @"请输入社区名称";
        _searchBar.delegate = self;
        _searchBar.backgroundColor = Color_Clear;
        [_searchBar setBackgroundImage:[UIImage new]];
//        [_searchBar setSearchFieldBackgroundImage: forState:UIControlStateNormal];
    }
    return _searchBar;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:[PCCommunityManagerCell className] bundle:nil] forCellReuseIdentifier:[PCCommunityManagerCell className]];
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.emptyDataSetDelegate = self;
        _tableView.emptyDataSetSource = self;
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
