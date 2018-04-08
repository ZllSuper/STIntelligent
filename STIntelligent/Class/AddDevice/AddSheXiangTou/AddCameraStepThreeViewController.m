//
//  AddCameraStepThreeViewController.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/6/6.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "AddCameraStepThreeViewController.h"
#import "AddCameraStepFourViewController.h"

#import "EZOpenSDKHeader.h"

#import "BXHAuthBtn.h"

#import "CameraAddHelper.h"

// 设备bonjour搜索到的状态标示
typedef enum _DEVICE_STATE
{
    STATE_NONE = 0,          // 设备状态-无
    STATE_WIFI,              // wifi已连接
    STATE_LINE,              // 有线已连接
    STATE_PLAT,              // 平台已注册
    STATE_SUCC
} DEVICE_STATE;

@interface AddCameraStepThreeViewController ()

@property (nonatomic, strong) UIImageView *wifiImageView;

@property (nonatomic, strong) UIImageView *arrowImageView;

@property (nonatomic, strong) UIImageView *cameraImageView;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) UILabel *tipTwoLabel;

@property (nonatomic, strong) UIButton *bottomBtn;

@property (nonatomic, strong) BXHAuthBtn *timeBtn;

@property (nonatomic) DEVICE_STATE state;

@end

@implementation AddCameraStepThreeViewController

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
    [self.view addSubview:self.bottomBtn];
    [self.view addSubview:self.timeBtn];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(80);
        make.size.mas_equalTo(CGSizeMake(77.5, 6.5));
    }];
    
    [self.wifiImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.arrowImageView.mas_left).offset(-20);
        make.centerY.mas_equalTo(self.arrowImageView);
        make.size.mas_equalTo(CGSizeMake(36, 28));
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
    
    [self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(16);
        make.right.mas_equalTo(self.view).offset(-16);
        make.bottom.mas_equalTo(self.view).offset(-30);
        make.height.mas_equalTo(@44);
    }];
    
    __weak typeof(self) weakSelf = self;
    [EZOpenSDK startConfigWifi:self.wifiName password:self.password deviceSerial:[CameraAddHelper shareInstance].addCameraModel.deviceSerialNo deviceStatus:^(EZWifiConfigStatus status) {
        if (status == DEVICE_WIFI_CONNECTING)
        {
            weakSelf.state = STATE_NONE;
            [weakSelf.timeBtn stopCountDown];
            [weakSelf.timeBtn startVerify:60];
        }
        else if (status == DEVICE_WIFI_CONNECTED)
        {
            if(weakSelf.state != STATE_WIFI)
            {
                weakSelf.state = STATE_WIFI;
                [weakSelf.timeBtn stopCountDown];
                [weakSelf.timeBtn startVerify:60];
            }
        }
        else if (status == DEVICE_PLATFORM_REGISTED)
        {
            weakSelf.state = STATE_PLAT;
            [weakSelf.timeBtn stopCountDown];
            [weakSelf.timeBtn startVerify:30];
            
    
        }
        else if (status == DEVICE_ACCOUNT_BINDED)
        {
            weakSelf.state = STATE_SUCC;
        }

    }];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action
- (void)nextStepAction
{
    AddCameraStepFourViewController *vc = [[AddCameraStepFourViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - get
- (UIImageView *)wifiImageView
{
    if (!_wifiImageView)
    {
        _wifiImageView = [[UIImageView alloc] init];
        _wifiImageView.image = ImageWithName(@"AddMaoYanWiFi");
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
        _tipLabel.text = @"正在发送WIFI信息,请耐心等待直到听到配置成功的提示语音。";
        _tipLabel.numberOfLines = 2;
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
        _tipTwoLabel.text = @"连接wifi";
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

- (UIButton *)bottomBtn
{
    if (!_bottomBtn)
    {
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomBtn.backgroundColor = [UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.buttonColor];
        [_bottomBtn setTitle:@"我已经听到配置成功提示" forState:UIControlStateNormal];
        [_bottomBtn setTitleColor:Color_White forState:UIControlStateNormal];
        _bottomBtn.layer.cornerRadius = 4;
        _bottomBtn.clipsToBounds = YES;
        _bottomBtn.titleLabel.font = Font_sys_16;
        [_bottomBtn addTarget:self action:@selector(nextStepAction) forControlEvents:UIControlEventTouchUpInside];
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
