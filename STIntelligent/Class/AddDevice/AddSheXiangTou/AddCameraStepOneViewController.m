//
//  AddCameraStepOneViewController.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/6/6.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "AddCameraStepOneViewController.h"
#import "AddCameraStepTwoViewController.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "EZOpenSDKHeader.h"

#import "AddCameraCompleteViewController.h"

#import "CameraAddHelper.h"

#import "CameraAddRequest.h"

@interface AddCameraStepOneViewController ()

@property (nonatomic, strong) UIImageView *cameraImageView;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) UIButton *bottomBtn;

@property (nonatomic, strong) UILabel *tipTwoLabel;

@property (nonatomic, strong) UIButton *voiceBtn;

@property (nonatomic, assign) VCType type;

@end

@implementation AddCameraStepOneViewController

- (instancetype)initWithVCType:(VCType)type
{
    if (self = [super init])
    {
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"添加设备";
    
    self.view.backgroundColor = Color_White;
    
    [self.view addSubview:self.cameraImageView];
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.tipTwoLabel];
    [self.view addSubview:self.voiceBtn];
    [self.view addSubview:self.bottomBtn];
    
    [self.cameraImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(DEF_SCREENWIDTH/3, DEF_SCREENWIDTH/3));
        make.centerY.mas_equalTo(self.view).offset(-80);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.cameraImageView.mas_bottom).offset(20);
    }];
    
    [self.tipTwoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(20);
        make.right.mas_equalTo(self.view).offset(-20);
        make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(30);
    }];
    
    [self.voiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-30);
        make.size.mas_equalTo(CGSizeMake(160, 30));
    }];
    
    [self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(16);
        make.right.mas_equalTo(self.view).offset(-16);
        make.height.mas_equalTo(@44);
        make.bottom.mas_equalTo(self.voiceBtn.mas_top).offset(-15);
    }];
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

#pragma mark - action
- (void)nextStepAction
{
    if (self.type == VCTypeWife)
    {
        NSString *ssid = [self fetchSSIDInfo];
        if (StringIsEmpty(ssid))
        {
            ToastShowBottom(@"确保手机连接WIFI");
            return;
        }
        
        AddCameraStepTwoViewController *vc = [[AddCameraStepTwoViewController alloc] initWithWiFiNameSSID:ssid];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
    
        [self cameraAddDeviceRequest];

    }
}

- (void)voiceBtnAction
{
    
}

#pragma mark - private

- (id)fetchSSIDInfo
{
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    NSDictionary *info = nil;
    NSString *ssid = nil;
    for (NSString *ifnam in ifs)
    {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count])
        {
            if ([info objectForKey:@"SSID"]) {
                ssid = [info objectForKey:@"SSID"];
            }
            break;
        }
    }
    return ssid;
}


#pragma mark - get
- (UIImageView *)cameraImageView
{
    if (!_cameraImageView)
    {
        _cameraImageView = [[UIImageView alloc] initWithImage:ImageWithName(@"AddCameraCameraIcon")];
    }
    return _cameraImageView;
}

- (UILabel *)tipLabel
{
    if (!_tipLabel)
    {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.hidden = self.type == VCTypeWife;
        _tipLabel.font = Font_sys_14;
        _tipLabel.text = [NSString stringWithFormat:@"设备号：%@",[CameraAddHelper shareInstance].addCameraModel.deviceSerialNo];
    }
    return _tipLabel;
}

- (UILabel *)tipTwoLabel
{
    if (!_tipTwoLabel)
    {
        _tipTwoLabel = [[UILabel alloc] init];
        _tipTwoLabel.hidden = self.type == VCTypeAdd;
        _tipTwoLabel.font = Font_sys_16;
        _tipTwoLabel.text = @"请将设备插上点后等待大约30秒，直到听到“请用客户端配置WI-FI”";
        _tipTwoLabel.numberOfLines = 2;
        _tipTwoLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipTwoLabel;
}

- (UIButton *)bottomBtn
{
    if (!_bottomBtn)
    {
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomBtn.backgroundColor = [UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.buttonColor];
        if (self.type == VCTypeWife)
        {
            [_bottomBtn setTitle:@"连接网络" forState:UIControlStateNormal];
        }
        else
        {
            [_bottomBtn setTitle:@"添加" forState:UIControlStateNormal];
        }
        [_bottomBtn setTitleColor:Color_White forState:UIControlStateNormal];
        _bottomBtn.layer.cornerRadius = 4;
        _bottomBtn.clipsToBounds = YES;
        _bottomBtn.titleLabel.font = Font_sys_16;
        [_bottomBtn addTarget:self action:@selector(nextStepAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBtn;
}

- (UIButton *)voiceBtn
{
    if (!_voiceBtn)
    {
        _voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _voiceBtn.hidden = self.type == VCTypeAdd;
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"没有听到语音提示？"];
        NSRange strRange = {0,[str length]};
        [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
        [str addAttribute:NSFontAttributeName value:Font_sys_14 range:NSMakeRange(0, str.length)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor getHexColorWithHexStr:@"#5081FB"] range:NSMakeRange(0, str.length)];
        [_voiceBtn setAttributedTitle:str forState:UIControlStateNormal];
    }
    return _voiceBtn;
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
