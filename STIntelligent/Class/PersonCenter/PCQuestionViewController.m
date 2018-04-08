//
//  PCQuestionViewController.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/12.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "PCQuestionViewController.h"
#import "PCQuestionDetailViewController.h"
#import "PCFeedBackViewController.h"

#import "PCHelpListRequest.h"
#import "PCQuestionModel.h"

@interface PCQuestionViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *sourceAry;

@property (nonatomic, strong) UIButton *bottomBtn;

@end

@implementation PCQuestionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"问题反馈";
    
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

    [self questionListRequest];
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
- (void)questionListRequest
{
    PCHelpListRequest *request = [[PCHelpListRequest alloc] init];
    BXHWeakObj(self);
    ProgressShow(self.view);
    [request requestWithSuccess:^(BXHBaseRequest *request) {
        ProgressHidden(selfWeak.view);
        if ([request.response.code integerValue] == 200)
        {
            selfWeak.sourceAry = [PCQuestionModel bxhObjectArrayWithKeyValuesArray:request.response.data];
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

#pragma mark - action
- (void)feedBackAction
{
    PCFeedBackViewController *vc = [[PCFeedBackViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - tableDelegate datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sourceAry.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuestionCell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QuestionCell"];
        cell.textLabel.font = Font_sys_14;
        cell.textLabel.textColor = Color_MainText;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    PCQuestionModel *questionModel = self.sourceAry[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"问题%ld：%@",indexPath.row + 1,questionModel.Name];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PCQuestionModel *questionModel = self.sourceAry[indexPath.row];
    PCQuestionDetailViewController *vc = [[PCQuestionDetailViewController alloc] initWithQuestionModel:questionModel];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - get
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


- (UIButton *)bottomBtn
{
    if (!_bottomBtn)
    {
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomBtn.backgroundColor = [UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.buttonColor];
        [_bottomBtn setTitle:@"意见反馈" forState:UIControlStateNormal];
        [_bottomBtn setTitleColor:Color_White forState:UIControlStateNormal];
        _bottomBtn.layer.cornerRadius = 4;
        _bottomBtn.clipsToBounds = YES;
        _bottomBtn.titleLabel.font = Font_sys_16;
        [_bottomBtn addTarget:self action:@selector(feedBackAction) forControlEvents:UIControlEventTouchUpInside];
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
