//
//  AddMYStepTwoViewController.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/31.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "AddMYStepTwoViewController.h"
#import "AddMaoYanStepThreeViewController.h"
#import "AddMaoYanStepFourViewController.h"

#import "AddMaoYanProgressView.h"
#import "MaoYanAddRequest.h"

@interface AddMYStepTwoViewController ()<EquesBusinessHelperProtcol>

@property (nonatomic, strong) UIImageView *qrImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *bottomBtn;

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) MaoYanModel *tempModel;

@property (nonatomic, strong) AddMaoYanProgressView *progressView;


@end

@implementation AddMYStepTwoViewController

- (instancetype)initWithQRImage:(UIImage *)qrImage
{
    if (self = [super init])
    {
        self.qrImageView.image = qrImage;
        self.tempModel = [[MaoYanModel alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"设备添加";
    self.view.backgroundColor = Color_White;
    
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.qrImageView];
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.bottomBtn];

    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.mas_equalTo(self.view);
        make.height.mas_equalTo(80);
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(20);
        make.right.mas_equalTo(self.view).offset(-20);
        make.top.mas_equalTo(self.progressView.mas_bottom).offset(40);
    }];
    
    [self.qrImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(200, 200));
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(16);
        make.right.mas_equalTo(self.view).offset(-16);
        make.height.mas_equalTo(@44);
        make.bottom.mas_equalTo(self.view).offset(-30);
    }];

    [self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(16);
        make.right.mas_equalTo(self.view).offset(-16);
        make.height.mas_equalTo(@44);
        make.bottom.mas_equalTo(self.backBtn.mas_top).offset(-20);
    }];

    [[EquesBusinessHelper shareInstance] addProtcol:self forMethod:MAOYAN_DEVICEADD_METHOD];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
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

#pragma mark protcol
- (void)equesBusinessHelper:(EquesBusinessHelper *)helper messageDict:(NSDictionary *)messageDict
{
    NSNumber *code = messageDict[@"code"];

    if ([code integerValue] == 4407)
    {
        if (!StringIsEmpty([EquesBusinessHelper shareInstance].addMaoYanModel.bid))
        {
            [self maoYanAddRequestWithBack:NO];
        }
        else
        {
            ToastShowBottom(@"设备添加失败");
        }
    }
}

#pragma mark - action
- (void)nextStepAction
{
    AddMaoYanStepThreeViewController *vc = [[AddMaoYanStepThreeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)backBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - get
- (UIImageView *)qrImageView
{
    if (!_qrImageView)
    {
        _qrImageView = [[UIImageView alloc] init];
    }
    return _qrImageView;
}

- (AddMaoYanProgressView *)progressView
{
    if (!_progressView)
    {
        _progressView = [[AddMaoYanProgressView alloc] initWithMark:3];
    }
    return _progressView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = Font_sys_12;
        _titleLabel.textColor = Color_Text_DarkGray;
        _titleLabel.numberOfLines = 0;
        NSString *result = @"1、请在“系统设置”菜单下选择“扫描二维码”或者在门内主机预览界面按“扫描二维码”图标进入扫描界面。\n2、用门外子机扫描二维码。\n3、听到“滴”声后点击下一步。";
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:result];
        //创建NSMutableParagraphStyle实例
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
        //设置行距
        [style setLineSpacing:5.0f];
        [style setLineBreakMode:NSLineBreakByCharWrapping];
        [attStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, result.length)];
        _titleLabel.attributedText = attStr;
    }
    return _titleLabel;
}

- (UIButton *)backBtn
{
    if (!_backBtn)
    {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.backgroundColor = Color_Text_Gray;
        [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [_backBtn setTitleColor:Color_White forState:UIControlStateNormal];
        _backBtn.layer.cornerRadius = 4;
        _backBtn.clipsToBounds = YES;
        _backBtn.titleLabel.font = Font_sys_16;
        [_backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIButton *)bottomBtn
{
    if (!_bottomBtn)
    {
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomBtn.backgroundColor = [UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.buttonColor];
        [_bottomBtn setTitle:@"下一步" forState:UIControlStateNormal];
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
