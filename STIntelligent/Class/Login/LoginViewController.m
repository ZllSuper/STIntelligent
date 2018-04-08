//
//  LoginViewController.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/18.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginBottomView.h"
#import "LoginCell.h"
#import "LoginAuthRightView.h"
#import "LoginBtnFooterView.h"

#import "STGetCodeRequest.h"
#import "STTokenLoginRequest.h"

#import "WXApiRequestHandler.h"
#import "WechatAuthSDK.h"
#import "WXApiManager.h"

#import "STWXTokenGetRequest.h"
#import "STThirdPartLoginRequest.h"
#import "STThirdPartBindRequest.h"
#import "STYSTokenGetRequest.h"
#import "STWXUserInfoRequest.h"
#import "STAliUserInfoRequest.h"

#import "WeiboApiManager.h"
#import "QQApiManager.h"
#import "AliPayManager.h"

#import "STUpdatePushRequest.h"

static NSString *kAuthScope = @"snsapi_userinfo";
static NSString *kAuthOpenID = @"0c806938e2413ce73eef92cc3";
static NSString *kAuthState = @"xxx";

typedef NS_ENUM(NSInteger, ThirdPartLoginType)
{
    ThirdPartLoginWXType = 3,
    ThirdPartLoginQQType,
    ThirdPartLoginSINAType,
    ThirdPartLoginALIPAYType,
};

@interface LoginViewController () <UITableViewDelegate, UITableViewDataSource,WXApiManagerDelegate,LoginViewControllerProtcol>

@property (nonatomic, strong) UIWindow *ownWindow;

@property (nonatomic, strong) LoginBottomView *bottomView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) LoginCell *phoneCell;

@property (nonatomic, strong) LoginCell *passwordCell;

@property (nonatomic, strong) LoginAuthRightView *authView;

@property (nonatomic, strong) LoginBtnFooterView *footerView;

@property (nonatomic, copy) NSString *captchaId;

@property (nonatomic, assign) ThirdPartLoginType loginType;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"登录";
    
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.tableView];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(@120);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.bottomView.mas_top);
    }];
    
    [WXApiManager sharedManager].delegate = self;
    
    if (self.flag == 1)
    {
        self.bottomView.hidden = YES;
    }
    
    // Do any additional setup after loading the view.
}


#pragma mark - action
- (void)wxLoginAction
{
    [self.view endEditing:YES];
    self.loginType = ThirdPartLoginWXType;
    BOOL ret = [WXApiRequestHandler sendAuthRequestScope:kAuthScope
                                        State:kAuthState
                                       OpenID:kAuthOpenID
                             InViewController:self];
    if (!ret)
    {
        NSLog(@"====");
    }
}

- (void)qqLoginAction
{
    [self.view endEditing:YES];
    self.loginType = ThirdPartLoginQQType;
    BXHWeakObj(self);
    [[QQApiManager shareInstance] qqStartLoginWithCallBack:^(BOOL success, NSString *message, NSString *userId, NSString *nickName, NSString *headerImage) {
        if (success)
        {
            ProgressShow(selfWeak.view);
            selfWeak.nickName = nickName;
            selfWeak.headerImage = headerImage;
            [selfWeak thirdPartLoginReuqest:userId];
        }
        else
        {
            ToastShowBottom(message);
        }


    }];
}

- (void)weiboLoginAction
{
    [self.view endEditing:YES];
    self.loginType = ThirdPartLoginSINAType;
    BXHWeakObj(self);
    [[WeiboApiManager shareManager] weiboLoginStartCallBack:^(BOOL success, NSString *message, NSString *userId, NSString *nickName, NSString *headerImage) {
        if (success)
        {
            ProgressShow(selfWeak.view);
            selfWeak.nickName = nickName;
            selfWeak.headerImage = headerImage;
            [selfWeak thirdPartLoginReuqest:userId];
        }
        else
        {
            ToastShowBottom(message);
        }
    }];
}

- (void)aliPayLoginAction
{
    self.loginType = ThirdPartLoginALIPAYType;
    BXHWeakObj(self);
    [[[AliPayManager alloc] init] alipayAuthLogin:^(NSDictionary *resultDic) {
        if ([resultDic[@"resultStatus"] integerValue] == 9000)
        {
             NSDictionary *queryDict = [resultDic[@"result"] queryContentsUsingEncoding:NSUTF8StringEncoding];
            if ([queryDict[@"result_code"] integerValue] == 200)
            {
                [selfWeak aliUserInfoRequest:queryDict[@"auth_code"] andOpenId:queryDict[@"alipay_open_id"]];
            }
            else
            {
                ToastShowBottom(@"失败");
            }
        }
        else
        {
            NSString *memo = resultDic[@"memo"];
            ToastShowBottom(memo);
        }
    }];
}

- (void)authViewBtnAction
{
    [self.view endEditing:YES];
    if (StringIsEmpty(self.phoneCell.inputTextFiled.text))
    {
        ToastShowBottom(@"请输入手机号");
        return;
    }
    STGetCodeRequest *request = [[STGetCodeRequest alloc] init];
    request.phoneNumber = self.phoneCell.inputTextFiled.text;
    BXHWeakObj(self);
    ProgressShow(self.view);
    [request requestWithSuccess:^(BXHBaseRequest *request) {
        ProgressHidden(selfWeak.view);
        if ([request.response.code integerValue] == 200)
        {
            [selfWeak.authView.authBtn startVerify:60];
            [selfWeak.passwordCell.inputTextFiled becomeFirstResponder];
            selfWeak.captchaId = [NSString stringWithFormat:@"%ld",[request.response.data[@"CaptchaId"] integerValue]];
        }
        else
        {
            ToastShowBottom(@"获取验证码失败");
        }
    } failure:^(NSError *error, BXHBaseRequest *request) {
        ProgressHidden(selfWeak.view);
        ToastShowBottom(NetWorkErrorTip);
    }];
}

- (void)loginBtnAction
{
    [self.view endEditing:YES];
    if (StringIsEmpty(self.phoneCell.inputTextFiled.text))
    {
        ToastShowBottom(@"请输入手机号");
        return;
    }
    
    if (StringIsEmpty(self.passwordCell.inputTextFiled.text))
    {
        ToastShowBottom(@"请输入验证码");
        return;
    }
    
    if (StringIsEmpty(self.captchaId))
    {
        ToastShowBottom(@"请先获取验证码");
        return;
    }
    
    if(self.flag == 0)
    {
        [self normalLogIn];
    }
    else
    {
        [self thirdPartBindRequest];
    }
    
}

#pragma mark - request
- (void)normalLogIn
{
    BXHWeakObj(self);
    ProgressShow(self.view);
    STTokenLoginRequest *request = [[STTokenLoginRequest alloc] init];
    request.phoneNumber = self.phoneCell.inputTextFiled.text;
    request.captchad = self.passwordCell.inputTextFiled.text;
    request.captchadId = self.captchaId;
    [request requestWithSuccess:^(BXHBaseRequest *request) {
        if ([request.response.code integerValue] == 200)
        {
            KAccountInfo.userId = [request.response.data[@"Id"] stringValue];
            KAccountInfo.name = StringIsEmpty(request.response.data[@"NickName"]) ?  @"用户" :request.response.data[@"NickName"];
            KAccountInfo.photo = request.response.data[@"HeadImg"];
            KAccountInfo.phone = request.response.data[@"PhoneNumber"];
            [selfWeak ysTokenGetRequest:NO];
        }
        else
        {
            ProgressHidden(selfWeak.view);
            ToastShowBottom(@"登录失败");
        }
    } failure:^(NSError *error, BXHBaseRequest *request) {
        ProgressHidden(selfWeak.view);
        ToastShowBottom(NetWorkErrorTip);
    }];
}

- (void)thirdPartLoginReuqest:(NSString *)onlyId
{
    STThirdPartLoginRequest *request = [[STThirdPartLoginRequest alloc] init];
    request.thirdPartyOnlyId = onlyId;
    request.thirdPartyTypeId = [NSString stringWithFormat:@"%ld",self.loginType];
    
    BXHWeakObj(onlyId);
    BXHWeakObj(self);
    [request requestWithSuccess:^(BXHBaseRequest *request) {
        if ([request.response.code integerValue] == 200)
        {
            KAccountInfo.userId = [request.response.data[@"Id"] stringValue];
            KAccountInfo.name = StringIsEmpty(request.response.data[@"NickName"]) ?  @"用户" :request.response.data[@"NickName"];
            KAccountInfo.photo = request.response.data[@"HeadImg"];
            KAccountInfo.phone = request.response.data[@"PhoneNumber"];
            [selfWeak ysTokenGetRequest:NO];
        }
        else if ([request.response.code integerValue] == 10001)
        {
            ProgressHidden(selfWeak.view);
            LoginViewController *vc = [[LoginViewController alloc] init];
            vc.flag = 1;
            vc.onlyId = onlyIdWeak;
            vc.protcol = selfWeak;
            vc.nickName = selfWeak.nickName;
            vc.headerImage = selfWeak.headerImage;
            [selfWeak.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            ProgressHidden(selfWeak.view);
            ToastShowBottom(request.response.message);
        }
    } failure:^(NSError *error, BXHBaseRequest *request) {
        ProgressHidden(selfWeak.view);
        ToastShowBottom(NetWorkErrorTip);
    }];
}

- (void)thirdPartBindRequest
{
    STThirdPartBindRequest *request = [[STThirdPartBindRequest alloc] init];
    request.thirdPartyOnlyId = self.onlyId;
    request.thirdPartyTypeId = @"2";
    request.phoneNumber = self.phoneCell.inputTextFiled.text;
    request.captchadId = self.captchaId;
    request.captchadContent = self.passwordCell.inputTextFiled.text;
    request.HeadImg = self.headerImage;
    request.NickName = self.nickName;
    ProgressShow(self.view);
    BXHWeakObj(self);
    [request requestWithSuccess:^(BXHBaseRequest *request) {
        if ([request.response.code integerValue] == 200)
        {
            KAccountInfo.userId = [request.response.data[@"Id"] stringValue];
            KAccountInfo.name = StringIsEmpty(request.response.data[@"NickName"]) ?  @"用户" :request.response.data[@"NickName"];
            KAccountInfo.photo = request.response.data[@"HeadImg"];
            KAccountInfo.phone = request.response.data[@"PhoneNumber"];
            [selfWeak ysTokenGetRequest:YES];
        }
        else
        {

            ToastShowBottom(request.response.message);

            ProgressHidden(selfWeak.view);
        }
    } failure:^(NSError *error, BXHBaseRequest *request) {
        ProgressHidden(selfWeak.view);
        ToastShowBottom(NetWorkErrorTip);
    }];
}

- (void)wxUserInfoRequest:(NSString *)accessToken andOpenId:(NSString *)openId
{
    STWXUserInfoRequest *request = [[STWXUserInfoRequest alloc] init];
    request.access_token = accessToken;
    request.openid = openId;
    BXHBlockObj(openId);
    BXHWeakObj(self);
    [request requestWithSuccess:^(BXHBaseRequest *request) {
        selfWeak.nickName = request.response.responseObject[@"nickname"];
        selfWeak.headerImage = request.response.responseObject[@"headimgurl"];
        BXHStrongObj(selfWeak);
        [selfWeakStrong thirdPartLoginReuqest:openIdblock];
    
    } failure:^(NSError *error, BXHBaseRequest *request) {
        ProgressHidden(selfWeak.view);
        ToastShowBottom(NetWorkErrorTip);
    }];
}

- (void)aliUserInfoRequest:(NSString *)code andOpenId:(NSString *)opendId
{
    STAliUserInfoRequest *request = [[STAliUserInfoRequest alloc] init];
    request.code = code;
    BXHBlockObj(opendId);
    BXHWeakObj(self);
    ProgressShow(self.view);
    [request requestWithSuccess:^(BXHBaseRequest *request) {
        
        if ([request.response.code intValue] == 200)
        {

            selfWeak.nickName = request.response.responseObject[@"NickName"];
            selfWeak.headerImage = request.response.responseObject[@"HeadImg"];
            BXHStrongObj(selfWeak);
            [selfWeakStrong thirdPartLoginReuqest:opendIdblock];
        }
        else
        {
            ProgressHidden(selfWeak.view);
            ToastShowBottom(request.response.message);
        }
        
    } failure:^(NSError *error, BXHBaseRequest *request) {
        ProgressHidden(selfWeak.view);
        ToastShowBottom(NetWorkErrorTip);
    }];

}

- (void)ysTokenGetRequest:(BOOL)needBack
{
    if (!StringIsEmpty(KAccountInfo.jpushId))
    {
        STUpdatePushRequest *request = [[STUpdatePushRequest alloc] init];
        request.cUserId = KAccountInfo.userId;
        request.deviceSerial = KAccountInfo.jpushId;
        request.clientType = @"0";
        BXHWeakObj(self);
        [request requestWithSuccess:^(BXHBaseRequest *request) {
            ProgressHidden(selfWeak.view);
            if ([request.response.code intValue] == 200)
            {
                [selfWeak saveAndCancle:needBack];
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
    else
    {
        [self saveAndCancle:needBack];
    }
}

- (void)saveAndCancle:(BOOL)needBack
{
    [KAccountInfo saveToDisk];
    if (needBack)
    {
        [self.navigationController popViewControllerAnimated:YES];
        [self.protcol loginViewController:self loginSuccess:YES];
    }
    else
    {
        [self cancelViewController];
    }

}

#pragma mark - overwrite
- (void)dismissViewController:(void (^ __nullable)(BOOL finished))completion
{
    [UIView animateWithDuration:0.5 animations:^{
        //        self.view.transform = CGAffineTransformMakeScale(1.2, 1.2);
        //        self.view.alpha = 0;
    } completion:completion];
}

#pragma mark - public
- (void)show
{
    //    self.view.alpha = 1;
    self.ownWindow.hidden = NO;
    [self.ownWindow makeKeyAndVisible];
}

#pragma mark - private
- (void)cancelViewController
{
    self.passwordCell.inputTextFiled.text = @"";
    [self.protcol loginViewController:self loginSuccess:YES];
    [self dismissViewController:^(BOOL finished) {
        self.ownWindow.hidden = YES;
    }];
}

- (void)loginViewController:(LoginViewController *)viewController loginSuccess:(BOOL)success
{
    [self cancelViewController];
}

#pragma mark - tableViewDelegate dataSource
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
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return self.footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return self.phoneCell;
    }
    else
    {
        return self.passwordCell;
    }
}

#pragma mark - wxDelegate
- (void)managerDidRecvAuthResponse:(SendAuthResp *)response
{
    if (StringIsEmpty(response.code))
    {
        ToastShowBottom(@"微信登录失败");
        return;
    }
    
    STWXTokenGetRequest *request = [[STWXTokenGetRequest alloc] init];
    request.code = response.code;
    request.appid = @"wxedcc1ceedc97f4f3";
    request.secret = @"f4e0c4ba55f734494c584d9b15a0342f";
    request.grant_type = @"authorization_code";
    BXHWeakObj(self);
    ProgressShow(self.view);
    [request requestWithSuccess:^(BXHBaseRequest *request) {
        NSString *openid = request.response.responseObject[@"unionid"];
        NSString *access_token = request.response.responseObject[@"access_token"];
        BXHStrongObj(selfWeak);
        [selfWeakStrong wxUserInfoRequest:access_token andOpenId:openid];
    } failure:^(NSError *error, BXHBaseRequest *request) {
        ProgressHidden(selfWeak.view);
        ToastShowBottom(NetWorkErrorTip);
    }];
}

- (BOOL)shouldAutorotate
{
    return NO;
}


#pragma mark - get
- (UIWindow *)ownWindow
{
    if (!_ownWindow)
    {
        _ownWindow = [[UIWindow alloc] initWithFrame:DEF_SCREENBOUNDS];
        _ownWindow.hidden = YES;
        _ownWindow.rootViewController = self.navigationController;
    }
    return _ownWindow;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREENWIDTH, 0) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
    }
    return _tableView;
}

- (LoginBottomView *)bottomView
{
    if (!_bottomView)
    {
        _bottomView = [LoginBottomView viewFromXIB];
        [_bottomView.oneControl addTarget:self action:@selector(wxLoginAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.twoControl addTarget:self action:@selector(qqLoginAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.threeControl addTarget:self action:@selector(weiboLoginAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.fourControl addTarget:self action:@selector(aliPayLoginAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomView;
}

- (LoginAuthRightView *)authView
{
    if (!_authView)
    {
        _authView = [[LoginAuthRightView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        [_authView.authBtn addTarget:self action:@selector(authViewBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _authView;
}

- (LoginCell *)phoneCell
{
    if(!_phoneCell)
    {
        _phoneCell = [LoginCell viewFromXIB];
        _phoneCell.inputTextFiled.placeholder = @"请输入手机号码";
        _phoneCell.titleLabel.text = @"账号";
        _phoneCell.inputTextFiled.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _phoneCell;
}

- (LoginCell *)passwordCell
{
    if(!_passwordCell)
    {
        _passwordCell = [LoginCell viewFromXIB];
        _passwordCell.inputTextFiled.rightView = self.authView;
        _passwordCell.inputTextFiled.rightViewMode = UITextFieldViewModeAlways;
        _passwordCell.inputTextFiled.placeholder = @"请输入密码";
        _passwordCell.titleLabel.text = @"密码";
    }
    return _passwordCell;
}

- (LoginBtnFooterView *)footerView
{
    if (!_footerView)
    {
        _footerView = [[LoginBtnFooterView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREENWIDTH, 80)];
        [_footerView.loginBtn addTarget:self action:@selector(loginBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
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
