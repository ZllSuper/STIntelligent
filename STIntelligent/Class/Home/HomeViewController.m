//
//  HomeViewController.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/8.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "HomeViewController.h"
#import "DeviceVideoViewController.h"
#import "CameraDeviceVedioViewController.h"

#import "AddMaoYanPrepareViewController.h"
#import "SweepCodeViewController.h"

#import "HomeDeviceView.h"
#import "EZOpenSDKHeader.h"

#import "STYSTokenGetRequest.h"

#import <EquesBusiness/YKBusinessFramework.h>
#import "CameraAddHelper.h"

@interface HomeViewController () <STThemeManagerProtcol, EquesBusinessHelperProtcol>

@property (nonatomic, strong) UIButton *imageBtn;

@property (nonatomic, strong) HomeDeviceView *deviceView;

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation HomeViewController

- (instancetype)initWithPageModel:(DeveicePageModel *)pageModel
{
    if (self = [super init])
    {
        _pageModel = pageModel;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"设备添加";
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.imageBtn];
    [self.view addSubview:self.deviceView];
    
    [self themeChange];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    [self.imageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.mas_equalTo(self.view);
        make.height.mas_equalTo(self.imageBtn.mas_width).multipliedBy(718.0 / 1080);
    }];
    
    [self.deviceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.imageBtn.mas_bottom).offset(20);
        make.height.mas_equalTo(self.deviceView.mas_width).offset(-32);
    }];
    
    [[STThemeManager shareInstance] addThemeChangeProtcol:self];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[EquesBusinessHelper shareInstance] addProtcol:self forMethod:MAOYAN_DEVICELIST_METHOD];
}


- (void)themeChange
{
    self.imageView.image = ThemeImageWithName(@"HomeBack");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - request
- (void)cameraAccessTokenGet:(SheXiangTouModel *)cameraModel
{
    STYSTokenGetRequest *request = [[STYSTokenGetRequest alloc] init];
    request.communityUserId = KAccountInfo.userId;
    __block SheXiangTouModel *blockModel = cameraModel;
    BXHWeakObj(self);
    ProgressShow(self.view);
    [request requestWithSuccess:^(BXHBaseRequest *request) {
        ProgressHidden(selfWeak.view);
        if ([request.response.code integerValue] == 200)
        {
            KAccountInfo.cameraAccessToken = request.response.data[@"Token"];
            [selfWeak cameraDealWithModel:blockModel];
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
- (void)maoYanAction
{
//    _pageModel.maoYanModel.uid = @"e7f1bc6cb91140c3aa0d487d3b789c94";
//    _pageModel.maoYanModel.reqid = @"37463607661b4911b06df14d15f064ce_1";
//    _pageModel.maoYanModel.bid = @"e7f1bc6cb91140c3aa0d487d3b789c94";

    if (StringIsEmpty(_pageModel.maoYanModel.bid))
    {
        __block DeveicePageModel *blockModel = _pageModel;
        [[EquesBusinessHelper shareInstance] startAddWithPageModel:_pageModel maoYanModel:_pageModel.maoYanModel successCallBack:^(DeveicePageModel *pageModel, MaoYanModel *maoYanModel) {
            blockModel.maoYanModel.bid = maoYanModel.bid;
            blockModel.maoYanModel.reqid = maoYanModel.reqid;
            blockModel.maoYanModel.uid = maoYanModel.uid;
        }];
        AddMaoYanPrepareViewController *vc = [[AddMaoYanPrepareViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        ProgressShow(self.view);
        [YKBusinessFramework equesGetDeviceList];
    }
}

- (void)cameraAction:(STControl *)control
{
    if (StringIsEmpty(KAccountInfo.cameraAccessToken))
    {
        [self cameraAccessTokenGet:control.cameraModel];
    }
    else
    {
        [self cameraDealWithModel:control.cameraModel];
    }
}

#pragma mark - private
- (void)cameraDealWithModel:(SheXiangTouModel *)cameraModel
{
    if (!StringIsEmpty(cameraModel.deviceSerialNo))
    {
        [EZOpenSDK setAccessToken:KAccountInfo.cameraAccessToken];
        CameraDeviceVedioViewController *vc = [[CameraDeviceVedioViewController alloc] init];
        vc.cameraModel = cameraModel;
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:[[BaseNaviController alloc] initWithRootViewController:vc] animated:YES completion:nil];
    }
    else
    {
        if(KAccountInfo.cameraAccessToken)
        {
            __block SheXiangTouModel *blockCameraModel = cameraModel;
            [EZOpenSDK setAccessToken:KAccountInfo.cameraAccessToken];
            [[CameraAddHelper shareInstance] startAddWithPageModel:_pageModel andCameraModel:cameraModel successCallBack:^(SheXiangTouModel *cameraModel) {
                blockCameraModel.deviceSerialNo = cameraModel.deviceSerialNo;
                blockCameraModel.deviceModel = cameraModel.deviceModel;
                blockCameraModel.deviceVerifyCode = cameraModel.deviceVerifyCode;
                blockCameraModel.deviceVerifyCodeBySerial = cameraModel.deviceVerifyCodeBySerial;
            }];
            SweepCodeViewController *vc = [[SweepCodeViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            [EZOpenSDK openLoginPage:^(EZAccessToken *accessToken) {
                KAccountInfo.cameraAccessToken = accessToken.accessToken;
                [EZOpenSDK setAccessToken:accessToken.accessToken];
                [KAccountInfo saveToDisk];
            }];
        }
    }
}

#pragma mark - protcol
- (void)equesBusinessHelper:(EquesBusinessHelper *)helper messageDict:(NSDictionary *)messageDict
{
    ProgressHidden(self.view);
    NSArray *onlines = messageDict[@"onlines"];
    
    for (NSDictionary *source in onlines)
    {
        if ([source[@"bid"] isEqualToString:_pageModel.maoYanModel.bid])
        {
            _pageModel.maoYanModel.uid = source[@"uid"];
            break;
        }
    }
    
    if (!StringIsEmpty(_pageModel.maoYanModel.uid))
    {
        DeviceVideoViewController *vc = [[DeviceVideoViewController alloc] initWithMaoYanModel:_pageModel.maoYanModel];
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:[[BaseNaviController alloc] initWithRootViewController:vc] animated:YES completion:nil];
    }
    else
    {
        ToastShowBottom(@"设备不在线");
    }
}

#pragma mark - get
- (UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UIButton *)imageBtn
{
    if (!_imageBtn)
    {
        _imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _imageBtn.backgroundColor = Color_White;
        [_imageBtn setImage:ImageWithName(@"HomeAVPlayIcon") forState:UIControlStateNormal];
        [_imageBtn setBackgroundImage:ImageWithName(@"HomeTopBack") forState:UIControlStateNormal];
        _imageBtn.contentMode = UIViewContentModeScaleAspectFill;
        _imageBtn.clipsToBounds = YES;
        if (_pageModel.defaultImage)
        {
            [_imageBtn setBackgroundImage:[UIImage imageWithData:[[NSData alloc] initWithBase64EncodedString:_pageModel.defaultImage options:NSDataBase64DecodingIgnoreUnknownCharacters]] forState:UIControlStateNormal];
        }
    }
    return _imageBtn;
}

- (HomeDeviceView *)deviceView
{
    if (!_deviceView)
    {
        _deviceView = [[HomeDeviceView alloc] init];
        [_deviceView.maoYanBtn addTarget:self action:@selector(maoYanAction) forControlEvents:UIControlEventTouchUpInside];
        [_deviceView.spOneBtn addTarget:self action:@selector(cameraAction:) forControlEvents:UIControlEventTouchUpInside];
        [_deviceView.spTwoBtn addTarget:self action:@selector(cameraAction:) forControlEvents:UIControlEventTouchUpInside];
        [_deviceView.spThreeBtn addTarget:self action:@selector(cameraAction:) forControlEvents:UIControlEventTouchUpInside];
        [_deviceView.spFourBtn addTarget:self action:@selector(cameraAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _deviceView;
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
