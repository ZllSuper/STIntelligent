//
//  PCCommunityAddViewController.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/10.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "PCCommunityAddViewController.h"
#import "BXHSTAlertViewController.h"

#import "PCCommunityAddHeaderView.h"
#import "PCcommunityAddTitleCell.h"
#import "PCCommunityDetailTitleCell.h"
#import "PCCommunityManagerCell.h"
#import "ValuePickerView.h"
#import "PCCommunityAlertView.h"

#import "PCCommunityBuildingListRequest.h"
#import "PCAddCommunityRequest.h"

#import "PCBuildModel.h"

@interface PCCommunityAddViewController () <UITableViewDelegate, UITableViewDataSource, BXHSTAlertViewControllerProtcol>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *bottomBtn;

@property (nonatomic, strong) PCCommunityAddHeaderView *headerView;

@property (nonatomic, strong) PCcommunityAddTitleCell *titleCell;

@property (nonatomic, strong) PCCommunityManagerCell *communityCell;

@property (nonatomic, strong) PCCommunityDetailTitleCell *countCell;

@property (nonatomic, weak) PCCommunityModel *weakModel;

@property (nonatomic, strong) ValuePickerView *pickerView;

@property (nonatomic, strong) NSArray *buildAry;

@property (nonatomic, weak) PCBuildModel *chooseBuildModel;

@end

@implementation PCCommunityAddViewController

- (instancetype)initWithCommunityModel:(PCCommunityModel *)model
{
    if (self = [super init])
    {
        self.weakModel = model;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"添加社区";
    
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

    [self buildRequest];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - request
- (void)buildRequest
{
    PCCommunityBuildingListRequest *request = [[PCCommunityBuildingListRequest alloc] init];
    request.communityId = [self.weakModel.communtyId stringValue];
    BXHWeakObj(self);
    ProgressShow(self.view);
    [request requestWithSuccess:^(BXHBaseRequest *request) {
        ProgressHidden(selfWeak.view);
        if ([request.response.code integerValue] == 200)
        {
            selfWeak.buildAry = [PCBuildModel bxhObjectArrayWithKeyValuesArray:request.response.data];
            NSMutableArray *dataSource = [NSMutableArray array];
            for (PCBuildModel *model in selfWeak.buildAry)
            {
                [dataSource addObject:model.Name];
            }
            
            selfWeak.pickerView.dataSource = dataSource;
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

- (void)communityAddRequest
{
    if (!self.chooseBuildModel)
    {
        ToastShowBottom(@"请选择楼栋编号");
        return;
    }
    PCAddCommunityRequest *request = [[PCAddCommunityRequest alloc] init];
    request.communityId = [self.weakModel.communtyId stringValue];
    request.cUserId = KAccountInfo.userId;
    request.floorId = self.chooseBuildModel.buildId;
    BXHWeakObj(self);
    ProgressShow(self.view);
    [request requestWithSuccess:^(BXHBaseRequest *request) {
        ProgressHidden(selfWeak.view);
        if ([request.response.code integerValue] == 200)
        {
            ToastShowBottom(@"申请成功，请等待审核");
            POST_NOTIFICATION(kRefreshCommunityListNotification, nil);
            [selfWeak.navigationController popViewControllerAnimated:YES];
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
- (void)communityAddAction:(UIButton *)sender
{
    if (!self.chooseBuildModel)
    {
        ToastShowBottom(@"请选择楼栋编号");
        return;
    }
    
    PCCommunityAlertView *content = [PCCommunityAlertView viewFromXIB];
    content.sureBtn.tag = 1;
    content.cancelBtn.tag = 2;
    BXHSTAlertViewController *vc = [BXHSTAlertViewController alertControllerWithContentView:content andSize:CGSizeMake(DEF_SCREENWIDTH - 40, 180)];
    [content.sureBtn addTarget:vc action:@selector(actionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [content.cancelBtn addTarget:vc action:@selector(actionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    vc.protcol = self;
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

#pragma mark - alertDelegate
- (void)bxhAlertViewController:(BXHSTAlertViewController *)vc clickIndex:(NSInteger)index
{
    if (index == 0)
    {
        [self communityAddRequest];
    }
    else
    {
        //取消添加
    }
    [vc dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - tableViewDelegate dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 2;
    }
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
    if (indexPath.section == 0)
    {
        if (indexPath.row == 1)
        {
            return 65;
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
            return self.titleCell;
        }
        else
        {
            return self.communityCell;
        }
    }
    else
    {
        return self.countCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1)
    {
        BXHWeakObj(self);
        [self.pickerView setValueDidSelect:^(NSInteger index){
            selfWeak.chooseBuildModel = selfWeak.buildAry[index];
            selfWeak.countCell.contentLabel.text = selfWeak.chooseBuildModel.Name;
        }];
        [self.pickerView show];
    }
}

#pragma mark - get
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREENWIDTH, 0) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableHeaderView = self.headerView;
    }
    return _tableView;
}

- (UIButton *)bottomBtn
{
    if (!_bottomBtn)
    {
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomBtn.backgroundColor = [UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.buttonColor];
        [_bottomBtn setTitle:@"添加" forState:UIControlStateNormal];
        [_bottomBtn setTitleColor:Color_White forState:UIControlStateNormal];
        _bottomBtn.layer.cornerRadius = 4;
        _bottomBtn.clipsToBounds = YES;
        _bottomBtn.titleLabel.font = Font_sys_16;
        [_bottomBtn addTarget:self action:@selector(communityAddAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBtn;
}

- (PCcommunityAddTitleCell *)titleCell
{
    if (!_titleCell)
    {
        _titleCell = [PCcommunityAddTitleCell viewFromXIB];
    }
    return _titleCell;
}

- (PCCommunityManagerCell *)communityCell
{
    if (!_communityCell)
    {
        _communityCell = [PCCommunityManagerCell viewFromXIB];
        _communityCell.statueLabel.hidden = YES;
        _communityCell.weakModel = self.weakModel;
    }
    return _communityCell;
}

- (PCCommunityDetailTitleCell *)countCell
{
    if (!_countCell)
    {
        _countCell = [PCCommunityDetailTitleCell viewFromXIB];
        _countCell.titleLabel.text = @"楼栋编号";
        _countCell.contentLabel.text = @"请选择楼栋编号";
    }
    return _countCell;
}

- (PCCommunityAddHeaderView *)headerView
{
    if (!_headerView)
    {
        _headerView = [[PCCommunityAddHeaderView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREENWIDTH, 450 / 1080.0 * DEF_SCREENWIDTH)];
        
        NSString *ImgUrl = [self.weakModel.ImgUrl stringByReplacingOccurrencesOfString:@" " withString:@""];
        [_headerView.headerImageView bxh_imageWithUrlStr:ImgUrl];
        _headerView.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headerView.headerImageView.clipsToBounds = YES;
    }
    return _headerView;
}

- (ValuePickerView *)pickerView
{
    if (!_pickerView)
    {
        _pickerView = [[ValuePickerView alloc] init];
        _pickerView.pickerTitle = @"楼栋编号";
    }
    return _pickerView;
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
