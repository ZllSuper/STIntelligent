//
//  AddMaoYanStepThreeViewController.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/6/2.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "AddMaoYanStepThreeViewController.h"

#import "AddMaoYanProgressView.h"

#import <EquesBusiness/YKBusinessFramework.h>

#import "AddMaoYanStepFourViewController.h"

#import "MaoYanAddRequest.h"

@interface AddMaoYanStepThreeViewController () <EquesBusinessHelperProtcol>

@property (nonatomic, strong) AddMaoYanProgressView *progressView;

@property (nonatomic, strong) UIImageView *wifiPhoneImageView;

@property (nonatomic, strong) UIImageView *signPhoneImageView;

@property (nonatomic, strong) UIImageView *arrowImageView;

@property (nonatomic, strong) UILabel *tipTwoLabel;

@property (nonatomic, strong) UILabel *tipOneLabel;

@end

@implementation AddMaoYanStepThreeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"添加设备";
    
    self.view.backgroundColor = Color_White;
    
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.arrowImageView];
    [self.view addSubview:self.wifiPhoneImageView];
    [self.view addSubview:self.signPhoneImageView];
    [self.view addSubview:self.tipOneLabel];
    [self.view addSubview:self.tipTwoLabel];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.mas_equalTo(self.view);
        make.height.mas_equalTo(80);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.progressView.mas_bottom).offset(100);
        make.size.mas_equalTo(CGSizeMake(77.5, 6.5));
    }];
    
    [self.wifiPhoneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.arrowImageView.mas_left).offset(-20);
        make.centerY.mas_equalTo(self.arrowImageView);
        make.size.mas_equalTo(CGSizeMake(54.5, 113.5));
    }];
    
    [self.signPhoneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.arrowImageView.mas_right).offset(20);
        make.centerY.mas_equalTo(self.arrowImageView);
        make.size.mas_equalTo(CGSizeMake(54.5, 113.5));
    }];
    
    [self.tipOneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(40);
        make.right.mas_equalTo(self.view).offset(-40);
        make.top.mas_equalTo(self.arrowImageView.mas_bottom).offset(180);
    }];
    
    [self.tipTwoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.arrowImageView);
        make.top.mas_equalTo(self.arrowImageView.mas_bottom).offset(5);
    }];
    
    if (!StringIsEmpty([EquesBusinessHelper shareInstance].addMaoYanModel.reqid))
    {
        [YKBusinessFramework equesAckAddResponse:[EquesBusinessHelper shareInstance].addMaoYanModel.reqid allow:allowAdd];
    }
    
    [[EquesBusinessHelper shareInstance] addProtcol:self forMethod:MAOYAN_BIND_RETURN_METHOD];
    [[EquesBusinessHelper shareInstance] addProtcol:self forMethod:MAOYAN_DEVICEADD_METHOD];



    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - request
- (void)maoYanAddRequestWithBack:(BOOL)back
{
    MaoYanAddRequest *request = [[MaoYanAddRequest alloc] init];
    request.sceneId = [EquesBusinessHelper shareInstance].addPageModel.pageId;
    request.deviceSerial = [EquesBusinessHelper shareInstance].addMaoYanModel.bid;
    request.name = @"猫眼";
    BXHBlockObj(back);
    BXHWeakObj(self);
    ProgressShow(self.view);
    [request requestWithSuccess:^(BXHBaseRequest *request) {
        ProgressHidden(selfWeak.view);
        if ([request.response.code integerValue] == 200)
        {
            if (backblock)
            {
                [selfWeak.navigationController popToRootViewControllerAnimated:YES];

            }
            else
            {
                AddMaoYanStepFourViewController *vc = [[AddMaoYanStepFourViewController alloc] init];
                [selfWeak.navigationController pushViewController:vc animated:YES];
            }
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

#pragma mark - protcol
- (void)equesBusinessHelper:(EquesBusinessHelper *)helper messageDict:(NSDictionary *)messageDict
{
    NSString *method = messageDict[@"method"];
    if ([method isEqualToString:MAOYAN_BIND_RETURN_METHOD])
    {
        [YKBusinessFramework equesAckAddResponse:[EquesBusinessHelper shareInstance].addMaoYanModel.reqid allow:allowAdd];
    }
    else if ([method isEqualToString:MAOYAN_DEVICEADD_METHOD])
    {
        NSInteger code = [messageDict[@"code"] integerValue];
        if(code == 4407)
        {
            [self maoYanAddRequestWithBack:NO];
        }
        else if (code == 4000)
        {
            [self maoYanAddRequestWithBack:NO];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
}

#pragma mark - get
- (AddMaoYanProgressView *)progressView
{
    if (!_progressView)
    {
        _progressView = [[AddMaoYanProgressView alloc] initWithMark:3];
    }
    return _progressView;
}

- (UIImageView *)wifiPhoneImageView
{
    if (!_wifiPhoneImageView)
    {
        _wifiPhoneImageView = [[UIImageView alloc] initWithImage:ImageWithName(@"AddMaoYanWifiPhone")];
    }
    return _wifiPhoneImageView;
}

- (UIImageView *)arrowImageView
{
    if (!_arrowImageView)
    {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = ImageWithName(@"AddMaoYanArrow");
    }
    return _arrowImageView;
}

- (UIImageView *)signPhoneImageView
{
    if (!_signPhoneImageView)
    {
        _signPhoneImageView = [[UIImageView alloc] initWithImage:ImageWithName(@"AddMaoYanSignPhone")];
    }
    return _signPhoneImageView;
}

- (UILabel *)tipOneLabel
{
    if(!_tipOneLabel)
    {
        _tipOneLabel = [[UILabel alloc] init];
        _tipOneLabel.font = Font_sys_16;
        _tipOneLabel.textAlignment = NSTextAlignmentCenter;
        _tipOneLabel.numberOfLines = 2;
        _tipOneLabel.textColor = Color_Text_DarkGray;
        _tipOneLabel.text = @"正在绑定设备，这可能需要一点时间请耐心等待。";
    }
    return _tipOneLabel;
}

- (UILabel *)tipTwoLabel
{
    if (!_tipTwoLabel)
    {
        _tipTwoLabel = [[UILabel alloc] init];
        _tipTwoLabel.font = Font_sys_12;
        _tipTwoLabel.textColor = [UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.buttonColor];
        _tipTwoLabel.text = @"正在绑定中";
    }
    return _tipTwoLabel;
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
