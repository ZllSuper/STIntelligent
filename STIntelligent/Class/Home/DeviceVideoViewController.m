//
//  DeviceVideoViewController.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/18.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "DeviceVideoViewController.h"
#import "MaoYanDeviceSettingViewController.h"

#import "DeviceControlBtn.h"

#import <EquesBusiness/YKBusinessFramework.h>

@interface DeviceVideoViewController () <EquesBusinessHelperProtcol>

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIView *videoView;

@property (nonatomic, strong) DeviceControlBtn *oneBtn;

@property (nonatomic, strong) DeviceControlBtn *twoBtn;

@property (nonatomic, strong) DeviceControlBtn *threeBtn;

@property (nonatomic, strong) DeviceControlBtn *fourBtn;

@property (nonatomic, strong) UIButton *bottomBtn;

@property (nonatomic, strong) NSMutableArray *porConstraintAry;

@property (nonatomic, strong) NSMutableArray *landConstraintAry;

@property (nonatomic, assign) BOOL prePor;

@property (nonatomic, weak) MaoYanModel *maoYanModel;

@property (nonatomic, copy) NSString *sid;

@property (nonatomic, copy) NSString *lid;

@property (nonatomic, strong) NSLock *lock;

@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation DeviceVideoViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithMaoYanModel:(MaoYanModel *)maoYanModel
{
    if (self = [super init])
    {
        self.maoYanModel = maoYanModel;
    }
    return self;
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
    [self.view addSubview:self.bottomBtn];
    
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
    
    [self.porConstraintAry addObjectsFromArray:[self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(16);
        make.right.mas_equalTo(self.view).offset(-16);
        make.height.mas_equalTo(@44);
        make.bottom.mas_equalTo(self.view).offset(-30);
    }]];
    
    [[EquesBusinessHelper shareInstance] addProtcol:self forMethod:MAOYAN_LOCKLIST_METHOD];
    [[EquesBusinessHelper shareInstance] addProtcol:self forMethod:MAOYAN_OPENLOCKRESULT_METHOD];

    self.sid = [YKBusinessFramework equesOpenCall:self.maoYanModel.uid showView:self.videoView enableVideo:YES];
    [YKBusinessFramework equesGetLockListWithBid:self.maoYanModel.bid];
    
    [self startTimeCountUp];
    
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
        self.bottomBtn.backgroundColor = [UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.buttonColor];
        [self.bottomBtn setTitle:@"开门" forState:UIControlStateNormal];
        [self.bottomBtn setImage:ImageWithName(@"DeviceBottomIcon") forState:UIControlStateHighlighted];
        [self.bottomBtn setImage:ImageWithName(@"DeviceBottomIcon") forState:UIControlStateNormal];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self.landConstraintAry makeObjectsPerformSelector:@selector(uninstall)];
        [self.porConstraintAry makeObjectsPerformSelector:@selector(install)];
    }
    else
    {
        if (self.prePor)
        {
            [self.bottomBtn setBackgroundColor:Color_Clear];
            [self.bottomBtn setImage:ThemeImageWithName(@"VedioKeyIcon") forState:UIControlStateNormal];
            [self.bottomBtn setImage:ThemeImageWithName(@"VedioKeyIconHeightLight") forState:UIControlStateHighlighted];
            [self.bottomBtn setTitle:@"" forState:UIControlStateNormal];
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
                    make.centerX.mas_equalTo(self.view);
                    make.bottom.mas_equalTo(self.view).offset(-20);
                    make.size.mas_equalTo(CGSizeMake(40, 40));
                }]];
                
                [self.landConstraintAry addObjectsFromArray:[self.fourBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(self.view).offset(-20);
                    make.size.mas_equalTo(CGSizeMake(40, 40));
                    make.left.mas_equalTo(self.threeBtn.mas_right).offset(10);
                }]];
                
                [self.landConstraintAry addObjectsFromArray:[self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(self.view).offset(-20);
                    make.size.mas_equalTo(CGSizeMake(40, 40));
                    make.left.mas_equalTo(self.fourBtn.mas_right).offset(10);
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

#pragma mark - protcol
- (void)equesBusinessHelper:(EquesBusinessHelper *)helper messageDict:(NSDictionary *)messageDict
{
    NSString *method = messageDict[@"method"];
    if ([method isEqualToString:MAOYAN_LOCKLIST_METHOD])
    {
        NSArray *lockList = messageDict[@"locklist"];
        if (lockList.count > 0)
        {
            self.bottomBtn.enabled = YES;
            NSDictionary *dict = [lockList firstObject];
            self.lid = dict[@"lid"];
        }
    }
    else if ([method isEqualToString:MAOYAN_OPENLOCKRESULT_METHOD])
    {
        NSString *ret = messageDict[@"ret"];
        if ([ret integerValue] == 1)
        {
            ToastShowBottom(@"开锁成功");
        }
        else
        {
            ToastShowBottom(@"开锁失败");
        }
    }
}

#pragma mark - action
- (void)oneBtnAction
{
    if (StringIsEmpty(self.maoYanModel.bid)|| StringIsEmpty(self.sid))
    {
        return;
    }
    
    if (!self.lock)
    {
        self.lock = [[NSLock alloc] init];
    }
    
    [self.lock lock];
    
    //获取Documents文件夹目录
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [path objectAtIndex:0];
    //获取文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //指定新建文件夹路径
    NSString *imageDocPath = [documentPath stringByAppendingPathComponent:@"ImageFile"];
    if (![fileManager isExecutableFileAtPath:imageDocPath])
    {
        //创建ImageFile文件夹
        [fileManager createDirectoryAtPath:imageDocPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //返回保存图片的路径（图片保存在ImageFile文件夹下）
    NSString * imagePath = [imageDocPath stringByAppendingPathComponent:@"capture.jpg"];
    [YKBusinessFramework equesSnapCapture:5 fileurl:imagePath];
    UIImage *img = [UIImage imageWithContentsOfFile:imagePath];

    [self saveImageToPhoto:img];
}

- (void)twoBtnAction
{
    self.twoBtn.selected = !self.twoBtn.selected;
    [YKBusinessFramework equesAudioPlayEnable:self.twoBtn.selected];
}

- (void)threeBtnActionDown
{
    [YKBusinessFramework equesAudioRecordEnable:YES];
}

- (void)threeBtnActionCancel
{
    [YKBusinessFramework equesAudioRecordEnable:NO];
}

- (void)threeBtnActionUp
{
    [YKBusinessFramework equesAudioRecordEnable:NO];
}

- (void)fourBtnAction
{
    [YKBusinessFramework equesCloseCall:self.sid];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)bottomBtnAction
{
    if (!StringIsEmpty(self.lid))
    {
        __weak typeof(self) weakSelf = self;
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"开门密码" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入开门密码";
        }];
    
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        }]];
    
        [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [YKBusinessFramework equesOpenLockWithUid:self.maoYanModel.uid lid:weakSelf.lid password:[alertVC.textFields firstObject].text];
        }]];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}

- (void)rightBtnAction
{
    MaoYanDeviceSettingViewController *vc = [[MaoYanDeviceSettingViewController alloc] init];
    vc.weakModel = self.maoYanModel;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - private
- (void)startTimeCountUp
{
    __block NSInteger organlTime = 0;
    __weak typeof(self) weakSelf = self;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.timer, dispatch_walltime(nil, 0), NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.timer, ^{
        organlTime++;
            long hourUnit = 60 * 60;
            long mintUnit = 60;
            
            long hour = organlTime / hourUnit;
            long hourSurplus = organlTime % hourUnit;
            long mint = hourSurplus / mintUnit;
            long seconds = hourSurplus % mintUnit;
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",hour,mint,seconds];
            });

    });
    dispatch_resume(self.timer);
}

- (void)stopCountDown
{
    if (self.timer)
    {
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
}

- (void)saveImageToPhoto:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    [self.lock unlock];
    if(error == NULL)
    {
        ToastShowBottom(@"抓拍成功");
    }
    else
    {
        ToastShowBottom(@"抓拍失败");
    }
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
        [_threeBtn setTitle:@"讲话" forState:UIControlStateNormal];
        [_threeBtn setTitleColor:Color_White forState:UIControlStateNormal];
        [_threeBtn setImage:ThemeImageWithName(@"VedioMute") forState:UIControlStateNormal];
        [_threeBtn setImage:ThemeImageWithName(@"VedioUnMute") forState:UIControlStateHighlighted];
        _threeBtn.titleLabel.font = Font_sys_12;
        [_threeBtn addTarget:self action:@selector(threeBtnActionDown) forControlEvents:UIControlEventTouchDown];
        [_threeBtn addTarget:self action:@selector(threeBtnActionUp) forControlEvents:UIControlEventTouchUpInside];
        [_threeBtn addTarget:self action:@selector(threeBtnActionCancel) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchDragExit];
        
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

- (UIButton *)bottomBtn
{
    if (!_bottomBtn)
    {
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomBtn.backgroundColor = [UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.buttonColor];
        [_bottomBtn setTitle:@"开门" forState:UIControlStateNormal];
        [_bottomBtn setTitleColor:Color_White forState:UIControlStateNormal];
        _bottomBtn.layer.cornerRadius = 4;
        _bottomBtn.clipsToBounds = YES;
        _bottomBtn.enabled = NO;
        _bottomBtn.titleLabel.font = Font_sys_16;
        [_bottomBtn setImage:ImageWithName(@"DeviceBottomIcon") forState:UIControlStateNormal];
        [_bottomBtn addTarget:self action:@selector(bottomBtnAction) forControlEvents:UIControlEventTouchUpInside];
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
