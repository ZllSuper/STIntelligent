//
//  TemporaryOpenDoorViewController.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/11.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "TemporaryOpenDoorViewController.h"
#import "TemporaryHistoryViewController.h"

#import "InviteOpenDoorTableView.h"
#import "ValuePickerView.h"

#import "ODTemporaryOpenDoorRequest.h"

#import "WXApiRequestHandler.h"
#import "WXApiManager.h"

@interface TemporaryOpenDoorViewController () <PCAuthCellDelegate,WXApiManagerDelegate,InviteOpenDoorTableViewdelegate>

@property (nonatomic, strong) InviteOpenDoorTableView *tableView;

@property (nonatomic, strong) UIButton *bottomBtn;

@property (nonatomic, strong) ValuePickerView *pickerView;

@end

@implementation TemporaryOpenDoorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"新增临时邀请";
    
//    [self initRightNavigationItemWithTitle:@"邀请记录" target:self action:@selector(rightBtnAction)];
    
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

    [WXApiManager sharedManager].delegate = self;

    [self.tableView requestViewSource:YES];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - request
- (void)inviteDoorRequestWithDoorIds:(NSString *)doorIds
{
    ODTemporaryOpenDoorRequest *request = [[ODTemporaryOpenDoorRequest alloc] init];
    request.doorIds = doorIds;
    request.cUserId = KAccountInfo.userId;
    request.peopleType = self.tableView.releationShipCell.inputTextFiled.text;
    request.name = self.tableView.nameCell.inputTextFiled.text;
    ProgressShow(self.view);
    BXHWeakObj(self);
    [request requestWithSuccess:^(BXHBaseRequest *request) {
        ProgressHidden(selfWeak.view);
        if ([request.response.code integerValue] == 200)
        {
            POST_NOTIFICATION(kRefreshTempListNotification, nil);
            [WXApiRequestHandler sendLinkURL:request.response.data[@"WechatUrl"] TagName:@"" Title:@"临时卡" Description:@"临时卡开门钥匙" ThumbImage:ImageWithName(@"ShareIcon") InScene:WXSceneSession];
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
- (void)rightBtnAction
{
    TemporaryHistoryViewController *vc = [[TemporaryHistoryViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)inviteAction:(UIButton *)sender
{
    [self.view endEditing:YES];
    if (StringIsEmpty(self.tableView.nameCell.inputTextFiled.text))
    {
        ToastShowBottom(@"请输入被邀请人姓名");
        return;
    }
    
    if (StringIsEmpty(self.tableView.releationShipCell.inputTextFiled.text))
    {
        ToastShowBottom(@"请选择被邀请人关系");
        return;
    }

    NSString *doorIds = @"";
    for (ODCommunityModel *cModel in self.tableView.soureAry)
    {
        for (ODDoorModel *dModel in cModel.doorListAll)
        {
            if (dModel.select)
            {
                doorIds = [NSString stringWithFormat:@"%@%@;",doorIds,[dModel.did stringValue]];
            }
        }
    }
    
    if (StringIsEmpty(doorIds))
    {
        ToastShowBottom(@"请选择需要授权的门");
        return;
    }
    
    [self inviteDoorRequestWithDoorIds:doorIds];
}

#pragma mark - inviteDoorDelegate
- (void)tableViewInviteDoorChange:(InviteOpenDoorTableView *)tableView
{
    NSString *doorIds = @"";
    for (ODCommunityModel *cModel in self.tableView.soureAry)
    {
        for (ODDoorModel *dModel in cModel.doorListAll)
        {
            if (dModel.select)
            {
                doorIds = [NSString stringWithFormat:@"%@%@;",doorIds,[dModel.did stringValue]];
            }
        }
    }
    self.bottomBtn.enabled = !StringIsEmpty(doorIds);
}

#pragma mark - authCellDelegate
- (BOOL)authCellTextFiledWillBegainEditing:(PCAuthCell *)authCell
{
    if ([self.tableView.nameCell isEqual:authCell])
    {
        return YES;
    }
    else
    {
        [self.tableView endEditing:YES];
        [self.pickerView show];
        BXHWeakObj(authCell);
        [self.pickerView setValueDidSelect:^(NSInteger index) {
            authCellWeak.inputTextFiled.text = [@[@"外卖",@"快递",@"来访"] objectAtIndex:index];
        }];
        return NO;
    }
}

- (void)authCellTextFileEndEdit:(PCAuthCell *)authCell
{
    
}

#pragma mark - wxDelegate
- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *)response;
{
    if (StringIsEmpty(response.errStr))
    {
        ToastShowBottom(@"分享成功");
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        ToastShowBottom(response.errStr);
    }
}

#pragma mark - get
- (ValuePickerView *)pickerView
{
    if (!_pickerView)
    {
        _pickerView = [[ValuePickerView alloc] init];
        _pickerView.dataSource = @[@"外卖",@"快递",@"来访"];
        _pickerView.pickerTitle = @"被邀请人关系";
    }
    return _pickerView;
}

- (InviteOpenDoorTableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[InviteOpenDoorTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.releationShipCell.titleLabel.text = @"被邀请人用途";
        _tableView.releationShipCell.inputTextFiled.placeholder = @"请选择被邀请人用途";
        _tableView.releationShipCell.delegate = self;
        _tableView.nameCell.delegate = self;
        _tableView.inviteDelegate = self;
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
        [_bottomBtn setTitle:@"发起邀请" forState:UIControlStateNormal];
        [_bottomBtn setTitleColor:Color_White forState:UIControlStateNormal];
        _bottomBtn.layer.cornerRadius = 4;
        _bottomBtn.clipsToBounds = YES;
        _bottomBtn.titleLabel.font = Font_sys_16;
        _bottomBtn.enabled = NO;
        [_bottomBtn addTarget:self action:@selector(inviteAction:) forControlEvents:UIControlEventTouchUpInside];
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
