//
//  CameraDeviceVedioViewController.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/18.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "CameraDeviceVedioViewController.h"
#import "CarmeraDeviceSettingViewController.h"

#import "DeviceControlBtn.h"

#import "EZOpenSDKHeader.h"

@interface CameraDeviceVedioViewController () <EZPlayerDelegate>

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIView *videoView;

@property (nonatomic, strong) DeviceControlBtn *oneBtn;

@property (nonatomic, strong) DeviceControlBtn *twoBtn;

@property (nonatomic, strong) DeviceControlBtn *threeBtn;

@property (nonatomic, strong) DeviceControlBtn *fourBtn;

@property (nonatomic, strong) NSMutableArray *porConstraintAry;

@property (nonatomic, strong) NSMutableArray *landConstraintAry;

@property (nonatomic, assign) BOOL prePor;

@property (nonatomic, strong) EZDeviceInfo *deviceInfo;

@property (nonatomic, strong) EZPlayer *player;

@property (nonatomic, copy) NSString *filePath;

@property (nonatomic, strong) NSMutableData *fileData;

@property (nonatomic, assign) NSInteger seconds;

@end

@implementation CameraDeviceVedioViewController

- (void)dealloc
{
    [EZOpenSDK releasePlayer:self.player];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"实时视频";
    
    [self creatRightNavigationItemWithImage:ThemeImageWithName(@"VedioSetIcon") target:self action:@selector(rightBtnAction)];
    
    self.view.backgroundColor = [UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.controllerViewColor];
    
    self.porConstraintAry = [NSMutableArray array];
    self.landConstraintAry = [NSMutableArray array];
    self.prePor = YES;
    
    
    [self.view addSubview:self.timeLabel];
    [self.view addSubview:self.videoView];
    [self.view addSubview:self.oneBtn];
    [self.view addSubview:self.twoBtn];
    [self.view addSubview:self.threeBtn];
    [self.view addSubview:self.fourBtn];
    
    [self.porConstraintAry addObjectsFromArray:[self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(10);
        make.centerX.mas_equalTo(self.view);
        make.height.mas_equalTo(@15);
    }]];
    
    [self.porConstraintAry addObjectsFromArray:[self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(10);
        make.left.and.right.mas_equalTo(self.view);
        make.height.mas_equalTo(self.videoView.mas_width).multipliedBy(4/7.0);
    }]];
    
    [self.porConstraintAry addObjectsFromArray:[self.oneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.top.mas_equalTo(self.videoView.mas_bottom).offset(10);
        make.height.mas_equalTo(@80);
    }]];
    
    [self.porConstraintAry addObjectsFromArray:[self.twoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.oneBtn.mas_right);
        make.top.mas_equalTo(self.oneBtn);
        make.height.mas_equalTo(@80);
        make.width.mas_equalTo(self.oneBtn);
    }]];
    
    [self.porConstraintAry addObjectsFromArray:[self.threeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.twoBtn.mas_right);
        make.top.mas_equalTo(self.videoView.mas_bottom).offset(10);
        make.height.mas_equalTo(@80);
        make.width.mas_equalTo(self.twoBtn);
    }]];
    
    [self.porConstraintAry addObjectsFromArray:[self.fourBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.threeBtn.mas_right);
        make.top.mas_equalTo(self.videoView.mas_bottom).offset(10);
        make.height.mas_equalTo(@80);
        make.width.mas_equalTo(self.threeBtn);
        make.right.mas_equalTo(self.view);
    }]];
    
    [self requestDeviceDetail];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [(BaseNaviController *)self.navigationController setAutorotate:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    if (size.width < size.height)
    {
        self.prePor = YES;

        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self.landConstraintAry makeObjectsPerformSelector:@selector(uninstall)];
        [self.porConstraintAry makeObjectsPerformSelector:@selector(install)];
    }
    else
    {
        if (self.prePor)
        {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            [self.porConstraintAry makeObjectsPerformSelector:@selector(uninstall)];
            if (self.landConstraintAry.count > 0)
            {
                [self.landConstraintAry makeObjectsPerformSelector:@selector(install)];
            }
            else
            {
                [self.landConstraintAry addObjectsFromArray:[self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(self.view);
                }]];
                
                [self.landConstraintAry addObjectsFromArray:[self.threeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.view.mas_centerX);
                    make.bottom.mas_equalTo(self.view).offset(-20);
                    make.size.mas_equalTo(CGSizeMake(40, 40));
                }]];
                
                [self.landConstraintAry addObjectsFromArray:[self.fourBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(self.view).offset(-20);
                    make.size.mas_equalTo(CGSizeMake(40, 40));
                    make.left.mas_equalTo(self.threeBtn.mas_right).offset(10);
                }]];
                
                [self.landConstraintAry addObjectsFromArray:[self.twoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(self.view).offset(-20);
                    make.size.mas_equalTo(CGSizeMake(40, 40));
                    make.right.mas_equalTo(self.threeBtn.mas_left).offset(-10);
                }]];
                
                [self.landConstraintAry addObjectsFromArray:[self.oneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(self.view).offset(-20);
                    make.size.mas_equalTo(CGSizeMake(40, 40));
                    make.right.mas_equalTo(self.twoBtn.mas_left).offset(-10);
                }]];
            }
            self.prePor = NO;
        }
    }
}

#pragma mark - request
- (void)requestDeviceDetail
{
    __weak typeof(self) weakSelf = self;
    ProgressShow(self.view);
    [EZOpenSDK getDeviceInfo:self.cameraModel.deviceSerialNo completion:^(EZDeviceInfo *deviceInfo, NSError *error) {
        ProgressHidden(weakSelf.view);
        if (error)
        {
            ToastShowBottom(@"播放错误");
        }
        else
        {
            weakSelf.deviceInfo = deviceInfo;
            [weakSelf  creatPlayer];
        }
    }];

}

- (void)creatPlayer
{
    EZCameraInfo *cameraInfo = [self.deviceInfo.cameraInfo firstObject];
    self.player = [EZOpenSDK createPlayerWithDeviceSerial:cameraInfo.deviceSerial cameraNo:cameraInfo.cameraNo];
    if (self.deviceInfo.isEncrypt)
    {
        [self.player setPlayVerifyCode:self.cameraModel.deviceVerifyCode];
    }

    self.player.delegate = self;
    [self.player setPlayerView:self.videoView];
    [self.player startRealPlay];
}

#pragma mark - action
- (void)oneBtnAction
{
    UIImage *image = [self.player capturePicture:100];
    [self saveImageToPhotosAlbum:image];
}

- (void)twoBtnAction
{
    self.twoBtn.selected = !self.twoBtn.selected;
    if (self.twoBtn.selected)
    {
        [self.player closeSound];
    }
    else
    {
        [self.player openSound];
    }
}

- (void)threeBtnAction
{
    if(self.threeBtn.selected)
    {
        [self.player stopLocalRecord];
        
        __weak __typeof(self) weakSelf = self;

        ProgressShow(self.view);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            // 处理耗时操作的代码块...
            [weakSelf.fileData writeToFile:_filePath atomically:YES];
            [weakSelf saveRecordToPhotosAlbum:weakSelf.filePath];
            dispatch_async(dispatch_get_main_queue(), ^{
                //回调或者说是通知主线程刷新，
                weakSelf.filePath = nil;
                ProgressHidden(weakSelf.view);
            });
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
           
        });
    }
    else
    {
        //开始本地录像
        NSString *path = @"/OpenSDK/EzvizLocalRecord";
        
        NSArray * docdirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * docdir = [docdirs objectAtIndex:0];
        
        NSString * configFilePath = [docdir stringByAppendingPathComponent:path];
        if(![[NSFileManager defaultManager] fileExistsAtPath:configFilePath])
        {
            NSError *error = nil;
            [[NSFileManager defaultManager] createDirectoryAtPath:configFilePath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:&error];
        }
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        dateformatter.dateFormat = @"yyyyMMddHHmmssSSS";
        self.filePath = [NSString stringWithFormat:@"%@/%@.mov",configFilePath,[dateformatter stringFromDate:[NSDate date]]];
        self.fileData = [NSMutableData new];
        
        __weak __typeof(self) weakSelf = self;
        ToastShowBottom(@"录制开始");
        [self.player startLocalRecord:^(NSData *data) {
            
            if (!data || !weakSelf.fileData)
            {
                return;
            }
            [weakSelf.fileData appendData:data];
        }];
    }
    self.threeBtn.selected = !self.threeBtn.selected;
}

- (void)fourBtnAction
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


- (void)rightBtnAction
{
    CarmeraDeviceSettingViewController *vc = [[CarmeraDeviceSettingViewController alloc] init];
    vc.deviceInfo = self.deviceInfo;
    vc.weakModel = self.cameraModel;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - playerDelegate
- (void)player:(EZPlayer *)player didPlayFailed:(NSError *)error
{
    if (error.code == 34) {//34错误特殊操作
        [self.player stopRealPlay];
        [self.player startRealPlay];
        return;
    }
}

- (void)player:(EZPlayer *)player didReceivedMessage:(NSInteger)messageCode
{

}

- (void)player:(EZPlayer *)player didReceivedDataLength:(NSInteger)dataLength
{
    self.seconds ++;
    
    NSInteger hourUnit = 60 * 60;
    NSInteger mintUnit = 60;
    NSInteger hour = self.seconds / hourUnit;
    NSInteger hourSurplus = self.seconds % hourUnit;
    NSInteger mint = hourSurplus / mintUnit;
    NSInteger seconds = hourSurplus % mintUnit;
    self.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",hour,mint,seconds];
}

#pragma mark - Private Methods

- (void)saveImageToPhotosAlbum:(UIImage *)savedImage
{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)saveRecordToPhotosAlbum:(NSString *)path
{
    UISaveVideoAtPathToSavedPhotosAlbum(path, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), NULL);
}

// 指定回调方法
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = nil;
    if (!error) {
        message = @"已保存至手机相册";
    }
    else
    {
        message = [error description];
    }
    ToastShowBottom(message);
}


#pragma mark - get
- (UILabel *)timeLabel
{
    if (!_timeLabel)
    {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = Font_sys_14;
        _timeLabel.textColor = Color_White;
        _timeLabel.text = @"00:00:00";
    }
    return _timeLabel;
}

- (UIView *)videoView
{
    if (!_videoView)
    {
        _videoView = [[UIView alloc] init];
        _videoView.backgroundColor = Color_Gray_Line;
    }
    return _videoView;
}

- (DeviceControlBtn *)oneBtn
{
    if (!_oneBtn)
    {
        _oneBtn = [DeviceControlBtn buttonWithType:UIButtonTypeCustom];
        
        [_oneBtn setTitle:@"抓拍" forState:UIControlStateNormal];
        [_oneBtn setTitleColor:Color_White forState:UIControlStateNormal];
        [_oneBtn setImage:ThemeImageWithName(@"VedioPicCatch") forState:UIControlStateNormal];
        [_oneBtn setImage:ThemeImageWithName(@"VedioPicCatchHeightLight") forState:UIControlStateHighlighted];
        _oneBtn.titleLabel.font = Font_sys_12;
        [_oneBtn addTarget:self action:@selector(oneBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _oneBtn;
}

- (DeviceControlBtn *)twoBtn
{
    if (!_twoBtn)
    {
        _twoBtn = [DeviceControlBtn buttonWithType:UIButtonTypeCustom];
        [_twoBtn setTitle:@"静音" forState:UIControlStateNormal];
        [_twoBtn setTitleColor:Color_White forState:UIControlStateNormal];
        [_twoBtn setImage:ThemeImageWithName(@"VedioMicrophoneOff") forState:UIControlStateNormal];
        [_twoBtn setImage:ThemeImageWithName(@"VedioMicrophoneOn") forState:UIControlStateSelected];
        _twoBtn.titleLabel.font = Font_sys_12;
        [_twoBtn addTarget:self action:@selector(twoBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _twoBtn;
}

- (DeviceControlBtn *)threeBtn
{
    if (!_threeBtn)
    {
        _threeBtn = [DeviceControlBtn buttonWithType:UIButtonTypeCustom];
        [_threeBtn setTitle:@"录像" forState:UIControlStateNormal];
        [_threeBtn setTitleColor:Color_White forState:UIControlStateNormal];
        [_threeBtn setImage:ThemeImageWithName(@"VedioUnRecorde") forState:UIControlStateNormal];
        [_threeBtn setImage:ThemeImageWithName(@"VedioRecorde") forState:UIControlStateSelected];
        _threeBtn.titleLabel.font = Font_sys_12;
        [_threeBtn addTarget:self action:@selector(threeBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _threeBtn;
}

- (DeviceControlBtn *)fourBtn
{
    if (!_fourBtn)
    {
        _fourBtn = [DeviceControlBtn buttonWithType:UIButtonTypeCustom];
        [_fourBtn setTitle:@"挂断" forState:UIControlStateNormal];
        [_fourBtn setTitleColor:Color_White forState:UIControlStateNormal];
        [_fourBtn setImage:ThemeImageWithName(@"VedioEnd") forState:UIControlStateNormal];
        _fourBtn.titleLabel.font = Font_sys_12;
        [_fourBtn addTarget:self action:@selector(fourBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fourBtn;
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
