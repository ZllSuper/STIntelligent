//
//  AddMaoYanPrepareViewController.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/6/5.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "AddMaoYanPrepareViewController.h"
#import "AddMaoYanViewController.h"

#import "AddMaoYanProgressView.h"

#import <SystemConfiguration/CaptiveNetwork.h>


@interface AddMaoYanPrepareViewController ()

@property (nonatomic, strong) AddMaoYanProgressView *progressView;

@property (nonatomic, strong) UIImageView *wifiImageView;

@property (nonatomic, strong) UIImageView *arrowImageView;

@property (nonatomic, strong) UIImageView *phoneImageView;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) UILabel *tipTwoLabel;

@property (nonatomic, strong) UIButton *bottomBtn;

@end

@implementation AddMaoYanPrepareViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"添加设备";
    self.view.backgroundColor = Color_White;
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.wifiImageView];
    [self.view addSubview:self.arrowImageView];
    [self.view addSubview:self.phoneImageView];
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.tipTwoLabel];
    [self.view addSubview:self.bottomBtn];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.mas_equalTo(self.view);
        make.height.mas_equalTo(80);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.progressView.mas_bottom).offset(100);
        make.size.mas_equalTo(CGSizeMake(77.5, 6.5));
    }];
    
    [self.wifiImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.arrowImageView.mas_left).offset(-20);
        make.centerY.mas_equalTo(self.arrowImageView);
        make.size.mas_equalTo(CGSizeMake(36, 28));
    }];
    
    [self.phoneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.arrowImageView.mas_right).offset(20);
        make.centerY.mas_equalTo(self.arrowImageView);
        make.size.mas_equalTo(CGSizeMake(58.5, 122.5));
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.arrowImageView.mas_bottom).offset(100);
    }];
    
    [self.tipTwoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.arrowImageView);
        make.top.mas_equalTo(self.arrowImageView.mas_bottom).offset(5);
    }];
    
    [self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(16);
        make.right.mas_equalTo(self.view).offset(-16);
        make.height.mas_equalTo(@44);
        make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(50);
    }];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action
- (void)nextStepAction:(UIButton *)sender
{
    NSString *ssid = [self fetchSSIDInfo];
    
    if (StringIsEmpty(ssid))
    {
        ToastShowBottom(@"确保手机连接WIFI");
        return;
    }
    
    AddMaoYanViewController *vc = [[AddMaoYanViewController alloc] initWithWiFiNameSSID:ssid];
    [self.navigationController pushViewController:vc animated:YES];
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
- (AddMaoYanProgressView *)progressView
{
    if (!_progressView)
    {
        _progressView = [[AddMaoYanProgressView alloc] initWithMark:1];
    }
    return _progressView;
}

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

- (UIImageView *)phoneImageView
{
    if (!_phoneImageView)
    {
        _phoneImageView = [[UIImageView alloc] init];
        _phoneImageView.image = ImageWithName(@"AddMaoYanPhone");
    }
    return _phoneImageView;
}

- (UILabel *)tipLabel
{
    if(!_tipLabel)
    {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = Font_sys_14;
        _tipLabel.textColor = Color_Text_DarkGray;
        _tipLabel.text = @"确保手机已连接到WIFI";
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

- (UIButton *)bottomBtn
{
    if (!_bottomBtn)
    {
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomBtn.backgroundColor = [UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.buttonColor];
        [_bottomBtn setTitle:@"准备就绪" forState:UIControlStateNormal];
        [_bottomBtn setTitleColor:Color_White forState:UIControlStateNormal];
        _bottomBtn.layer.cornerRadius = 4;
        _bottomBtn.clipsToBounds = YES;
        _bottomBtn.titleLabel.font = Font_sys_16;
        [_bottomBtn addTarget:self action:@selector(nextStepAction:) forControlEvents:UIControlEventTouchUpInside];
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
