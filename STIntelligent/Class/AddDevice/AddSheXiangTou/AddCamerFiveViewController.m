//
//  AddCamerFiveViewController.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/6/7.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "AddCamerFiveViewController.h"
#import "AddCameraCompleteViewController.h"
#import "BXHAuthBtn.h"
#import "EZOpenSDKHeader.h"
#import "CameraAddRequest.h"
#import "CameraAddHelper.h"

@interface AddCamerFiveViewController ()

@property (nonatomic, strong) UIImageView *wifiImageView;

@property (nonatomic, strong) UIImageView *arrowImageView;

@property (nonatomic, strong) UIImageView *cameraImageView;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) UILabel *tipTwoLabel;

@property (nonatomic, strong) BXHAuthBtn *timeBtn;

@end

@implementation AddCamerFiveViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"添加设备";
    
    self.view.backgroundColor = Color_White;
    
    [self.view addSubview:self.wifiImageView];
    [self.view addSubview:self.arrowImageView];
    [self.view addSubview:self.cameraImageView];
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.tipTwoLabel];
    [self.view addSubview:self.timeBtn];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(80);
        make.size.mas_equalTo(CGSizeMake(77.5, 6.5));
    }];
    
    [self.wifiImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.arrowImageView.mas_left).offset(-20);
        make.centerY.mas_equalTo(self.arrowImageView);
        make.size.mas_equalTo(CGSizeMake(40, 40.5));
    }];
    
    [self.cameraImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.arrowImageView.mas_right).offset(20);
        make.centerY.mas_equalTo(self.arrowImageView);
        make.size.mas_equalTo(CGSizeMake(84.5, 92.5));
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.arrowImageView.mas_bottom).offset(100);
        make.left.mas_equalTo(self.view).offset(30);
        make.right.mas_equalTo(self.view).offset(-30);
    }];
    
    [self.tipTwoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.arrowImageView.mas_bottom).offset(5);
        make.centerX.mas_equalTo(self.view);
    }];
    
    [self.timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(30);
    }];
    
    [self.timeBtn startVerify:30];
    [self cameraAddDeviceRequest];
    
    // Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - request
- (void)cameraAddDeviceRequest
{
    CameraAddRequest *request = [[CameraAddRequest alloc] init];
    request.sceneId = [CameraAddHelper shareInstance].addPageModel.pageId;
    request.deviceSerial = [CameraAddHelper shareInstance].addCameraModel.deviceSerialNo;
    request.name = @"摄像头";
    request.vCode = [CameraAddHelper shareInstance].addCameraModel.deviceVerifyCode;
    request.imageId = @"1";
    BXHWeakObj(self);
    ProgressShow(self.view);
    [request requestWithSuccess:^(BXHBaseRequest *request) {
        ProgressHidden(selfWeak.view);
        if ([request.response.code integerValue] == 200)
        {
            AddCameraCompleteViewController *vc = [[AddCameraCompleteViewController alloc] init];
            [selfWeak.navigationController pushViewController:vc animated:YES];
            
            POST_NOTIFICATION(kRefreshHomePageNotification, nil);
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

#pragma mark - get
- (UIImageView *)wifiImageView
{
    if (!_wifiImageView)
    {
        _wifiImageView = [[UIImageView alloc] init];
        _wifiImageView.image = ImageWithName(@"AddCameraPersonAdd");
    }
    return _wifiImageView;
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

- (UIImageView *)cameraImageView
{
    if (!_cameraImageView)
    {
        _cameraImageView = [[UIImageView alloc] init];
        _cameraImageView.image = ImageWithName(@"AddCameraSmallIcon");
    }
    return _cameraImageView;
}

- (UILabel *)tipLabel
{
    if(!_tipLabel)
    {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = Font_sys_14;
        _tipLabel.textColor = Color_Text_DarkGray;
        _tipLabel.text = @"正在绑定设备到您的账户下";
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLabel;
}

- (UILabel *)tipTwoLabel
{
    if (!_tipTwoLabel)
    {
        _tipTwoLabel = [[UILabel alloc] init];
        _tipTwoLabel.font = Font_sys_12;
        _tipTwoLabel.textColor = [UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.buttonColor];
        _tipTwoLabel.text = @"绑定中";
    }
    return _tipTwoLabel;
}

- (BXHAuthBtn *)timeBtn
{
    if (!_timeBtn)
    {
        _timeBtn = [BXHAuthBtn buttonWithType:UIButtonTypeCustom];
        _timeBtn.layer.cornerRadius = 30;
        _timeBtn.layer.borderColor = [UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.buttonColor].CGColor;
        _timeBtn.layer.borderWidth = 1;
        _timeBtn.layer.masksToBounds = YES;
        [_timeBtn setTitleColor:[UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.buttonColor] forState:UIControlStateNormal];
        _timeBtn.titleLabel.font =  Font_sys_14;
    }
    return _timeBtn;
}


@end
