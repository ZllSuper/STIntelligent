//
//  AddMaoYanStepFourViewController.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/6/5.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "AddMaoYanStepFourViewController.h"
#import "AddMaoYanProgressView.h"

@interface AddMaoYanStepFourViewController ()

@property (nonatomic, strong) AddMaoYanProgressView *progressView;

@property (nonatomic, strong) UIImageView *okImageView;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) UIButton *bottomBtn;

@end

@implementation AddMaoYanStepFourViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"设备添加";
    
    self.view.backgroundColor = Color_White;
    
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.okImageView];
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.bottomBtn];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.mas_equalTo(self.view);
        make.height.mas_equalTo(80);
    }];
    
   [self.okImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.size.mas_equalTo(CGSizeMake(58.5, 58.5));
       make.centerX.mas_equalTo(self.view);
       make.top.mas_equalTo(self.progressView.mas_bottom).offset(120);
   }];
   
   [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.mas_equalTo(self.okImageView.mas_bottom).offset(30);
       make.centerX.mas_equalTo(self.view);
   }];
   
   [self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.mas_equalTo(self.view).offset(16);
       make.right.mas_equalTo(self.view).offset(-16);
       make.height.mas_equalTo(@44);
       make.bottom.mas_equalTo(self.view).offset(-20);
   }];
   
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] init]];
    
        // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action
- (void)nextStepAction
{
    [[EquesBusinessHelper shareInstance] addEndWithSuccess:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - get
- (AddMaoYanProgressView *)progressView
{
    if (!_progressView)
    {
        _progressView = [[AddMaoYanProgressView alloc] initWithMark:4];
    }
    return _progressView;
}

- (UIImageView *)okImageView
{
    if (!_okImageView)
    {
        _okImageView = [[UIImageView alloc] initWithImage:ImageWithName(@"AddMaoYanOk")];
    }
    return _okImageView;
}

- (UILabel *)tipLabel
{
    if (!_tipLabel)
    {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textColor = [UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.buttonColor];
        _tipLabel.font = Font_sys_16;
        _tipLabel.text = @"恭喜绑定设备成功";
    }
    return _tipLabel;
}

- (UIButton *)bottomBtn
{
    if (!_bottomBtn)
    {
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomBtn.backgroundColor = [UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.buttonColor];
        [_bottomBtn setTitle:@"完成" forState:UIControlStateNormal];
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
