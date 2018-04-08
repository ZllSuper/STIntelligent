//
//  AddCameraFailViewController.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/6/8.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "AddCameraFailViewController.h"
#import "CameraAddHelper.h"

@interface AddCameraFailViewController ()

@property (nonatomic, strong) UIImageView *cameraImageView;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) UILabel *tipTwoLabel;

@end

@implementation AddCameraFailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"添加设备";
    
    self.view.backgroundColor = Color_White;
    
    [self.view addSubview:self.cameraImageView];
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.tipTwoLabel];
    
    [self.cameraImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(220, 220));
        make.top.mas_equalTo(self.view).offset(30);
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
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        _tipTwoLabel.font = Font_sys_16;
        _tipTwoLabel.text = self.errorStr;
        _tipTwoLabel.numberOfLines = 2;
        _tipTwoLabel.textAlignment = NSTextAlignmentCenter;
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
