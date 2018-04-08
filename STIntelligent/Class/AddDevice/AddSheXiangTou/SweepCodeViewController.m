//
//  SweepCodeViewController.m
//  ECarCommerciaiTenant
//
//  Created by 步晓虎 on 15/1/30.
//  Copyright (c) 2015年 步晓虎. All rights reserved.
//

#import "SweepCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "CheckCodeShadeView.h"
#import "AddCameraStepOneViewController.h"
#import "AddCameraFailViewController.h"
#import "EZOpenSDKHeader.h"
#import "CameraAddHelper.h"

@interface SweepCodeViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession *session;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic, strong) UIImageView *lineView;

@property (nonatomic, assign) CGPoint firstPoint;

@property (nonatomic, strong) UIButton *torcBtn;

@property (nonatomic, strong) UILabel *torcLabe;

@end

@implementation SweepCodeViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"扫描设备";
    
    [self readQRcode];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self lineViewAnimate];
    if (!self.session.running)
    {
        [self.session startRunning];
    }
}

#pragma mark - 读取二维码
- (void)readQRcode
{
    // 1. 摄像头设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 2. 设置输入
    // 因为模拟器是没有摄像头的，因此在此最好做一个判断
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (error)
    {
        NSLog(@"没有摄像头-%@", error.localizedDescription);
        return;
    }
    // 3. 设置输出(Metadata元数据)
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    output.rectOfInterest =  CGRectMake (( 134 )/ DEF_SCREENHEIGHT ,(( DEF_SCREENWIDTH - 220 )/ 2 )/ DEF_SCREENWIDTH , 220 / DEF_SCREENHEIGHT , 220 / DEF_SCREENWIDTH);
    // 3.1 设置输出的代理
    // 说明：使用主线程队列，相应比较同步，使用其他队列，相应不同步，容易让用户产生不好的体验
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //    [output setMetadataObjectsDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
    // 4. 拍摄会话
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    // 添加session的输入和输出
    [session addInput:input];
    [session addOutput:output];
    // 4.1 设置输出的格式
    // 提示：一定要先设置会话的输出为output之后，再指定输出的元数据类型！
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    // 5. 设置预览图层（用来让用户能够看到扫描情况）
    AVCaptureVideoPreviewLayer *preview = [AVCaptureVideoPreviewLayer layerWithSession:session];
    // 5.1 设置preview图层的属性
    [preview setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    // 5.2 设置preview图层的大小
    [preview setFrame:self.view.bounds];
    // 5.3 将图层添加到视图的图层
    [self.view.layer insertSublayer:preview atIndex:0];
    self.previewLayer = preview;
    // 5.4 添加图片
    [self creatPreviewLayerSubView];
    // 6. 启动会话
    [session startRunning];
    
    self.session = session;
}

- (void)creatPreviewLayerSubView
{
    UIImageView *kuangView = [[UIImageView alloc] init];
    kuangView.image = [UIImage imageNamed:@"CheckCodeCheckArea"];
    kuangView.frame = CGRectMake((DEF_SCREENWIDTH - kuangView.image.size.width) / 2, 100, kuangView.image.size.width, kuangView.image.size.height);
    CheckCodeShadeView *shadeView = [[CheckCodeShadeView alloc] initWithFrame:self.view.bounds andShowRect:kuangView.frame];
    shadeView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:shadeView];
    [self.view addSubview:kuangView];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(kuangView.frame) + 100, DEF_SCREENWIDTH, 20)];
    tipLabel.textColor = [UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.buttonColor];
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.font = Font_sys_14;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.text = @"请扫描设备机身或说明书上的二维码进行设备添加";
    [self.view addSubview:tipLabel];
    
    self.lineView = [[UIImageView alloc] init];
    self.lineView.image = [UIImage imageNamed:@"CheckCodeCheckLine"];
    self.lineView.frame = CGRectMake(kuangView.left + 1, kuangView.top + 2, self.lineView.image.size.width, self.lineView.image.size.height);
    self.firstPoint = CGPointMake(218, self.lineView.top);
    [self.view addSubview:self.lineView];
    
}

- (void)lineViewAnimate
{
    self.lineView.hidden = NO;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    animation.repeatCount = 1000000;
    animation.duration = 2.0;
    animation.removedOnCompletion = YES;
    animation.toValue = [NSNumber numberWithFloat:self.firstPoint.x];
    [self.lineView.layer addAnimation:animation forKey:@"animate"];
}

#pragma mark - 输出代理方法
// 此方法是在识别到QRCode，并且完成转换
// 如果QRCode的内容越大，转换需要的时间就越长
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSLog(@"%@", metadataObjects);
    
    if (metadataObjects.count > 0)
    {
        [self.lineView.layer removeAllAnimations];
        self.lineView.hidden = YES;
        // 会频繁的扫描，调用代理方法
        // 1. 如果扫描完成，停止会话
        [self.session stopRunning];
        // 2. 删除预览图层
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        NSArray *arrString = [obj.stringValue componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        if (arrString.count > 2)
        {
            //超时以后查询一次设备信息
            [CameraAddHelper shareInstance].addCameraModel.deviceSerialNo = arrString[1];
            [CameraAddHelper shareInstance].addCameraModel.deviceVerifyCode = arrString[2];
            ProgressShow(self.view);
            __weak typeof(self) weakSelf = self;
            [EZOpenSDK probeDeviceInfo:[CameraAddHelper shareInstance].addCameraModel.deviceSerialNo
                            completion:^(EZProbeDeviceInfo *deviceInfo, NSError *error) {
                                ProgressHidden(weakSelf.view);
                                NSLog(@"deviceInfo = %@, error = %ld", deviceInfo, error.code);
                                if (error)
                                {
//                                    NSString *domain = @"";
//                                    if (error.code == EZ_HTTPS_DEVICE_ADDED_MYSELF)
//                                    {
//                                        domain = @"您已添加过此设备";
//                                    }
//                                    else if (error.code == 120020)
//                                    {
//                                        domain = @"此设备已被添加。如果此设备已被删除，请在2分钟后添加。";
//                                    }
//                                    else if (error.code == EZ_HTTPS_DEVICE_ONLINE_IS_ADDED ||
//                                             error.code == EZ_HTTPS_DEVICE_OFFLINE_IS_ADDED)
//                                    {
//                                         domain = @"此设备已被添加。如果此设备已被删除，请在2分钟后添加。";
//                                    }
//                                    else if (error.code == EZ_HTTPS_DEVICE_OFFLINE_NOT_ADDED ||
//                                             error.code == EZ_HTTPS_DEVICE_NOT_EXISTS)
//                                    {
//                                        AddCameraStepOneViewController *vc = [[AddCameraStepOneViewController alloc] initWithVCType:VCTypeWife];
//                                        [weakSelf.navigationController pushViewController:vc animated:YES];
//                                        return;
//                                    }
//                                    else
//                                    {
//                                        domain = @"未知错误";
//                                    }
//
//                                    AddCameraFailViewController *fail = [[AddCameraFailViewController alloc] init];
//                                    fail.errorStr = domain;
//                                    [weakSelf.navigationController pushViewController:fail animated:YES];
                                    
                                    switch (error.code) {
                                        case 102003:
                                            //设备不在线
                                        case EZ_HTTPS_DEVICE_OFFLINE:
                                            //设备不在线
                                        case EZ_HTTPS_DEVICE_NOT_EXISTS:
                                            //设备不存在
                                        case EZ_HTTPS_DEVICE_OFFLINE_NOT_ADDED:
                                            //设备不在线，未被用户添加
                                        {
                                            AddCameraStepOneViewController *vc = [[AddCameraStepOneViewController alloc] initWithVCType:VCTypeWife];
                                            [weakSelf.navigationController pushViewController:vc animated:YES];
                                            break;
                                        }
                                        case 102020:
                                        case 102030:
                                        {
                                            AddCameraFailViewController *fail = [[AddCameraFailViewController alloc] init];
                                            fail.errorStr = @"查询失败，平台不支持该型号添加";
                                            [weakSelf.navigationController pushViewController:fail animated:YES];
                                            break;
                                        }

                                        case EZ_HTTPS_DEVICE_NETWORK_ANOMALY:
                                            //网络异常
                                        case EZ_SDK_PARAM_ERROR:
                                            //接口参数错误
                                        {
                                            AddCameraFailViewController *fail = [[AddCameraFailViewController alloc] init];
                                            fail.errorStr = @"查询失败，网络不给力";
                                            [weakSelf.navigationController pushViewController:fail animated:YES];
                                            break;
                                        }
                                            
                                        case EZ_HTTPS_SERVER_ERROR:
                                            //服务器异常
                                        {
                                            AddCameraFailViewController *fail = [[AddCameraFailViewController alloc] init];
                                            fail.errorStr = @"查询失败，服务器忙";
                                            [weakSelf.navigationController pushViewController:fail animated:YES];
                                            break;
                                        }

                                        case 400902:
                                        {
                                            AddCameraFailViewController *fail = [[AddCameraFailViewController alloc] init];
                                            fail.errorStr = @"查询失败，Token过期，请重新登陆";
                                            [weakSelf.navigationController pushViewController:fail animated:YES];
                                            break;
                                        }
                                            
                                        case 120020:
                                            // 设备在线，已经被自己添加 (给出提示)
                                        case EZ_HTTPS_DEVICE_ONLINE_IS_ADDED:
                                            // 设备在线，已经被别的用户添加 (给出提示)
                                        case EZ_HTTPS_DEVICE_OFFLINE_IS_ADDED:
                                            // 设备不在线，已经被别的用户添加 (给出提示)
                                        case EZ_HTTPS_DEVICE_OFFLINE_IS_ADDED_MYSELF:
                                            // 设备不在线，已经被自己添加 (给出提示)
                                        {
                                            AddCameraFailViewController *fail = [[AddCameraFailViewController alloc] init];
                                            fail.errorStr = @"操作失败，此设备已被添加。\n如果此设备已被删除，请在2分钟后添加";
                                            [weakSelf.navigationController pushViewController:fail animated:YES];
                                            break;
                                        }
    
                                            
                                        default:
                                        {
                                            AddCameraFailViewController *fail = [[AddCameraFailViewController alloc] init];
                                            fail.errorStr = @"查询失败";
                                            [weakSelf.navigationController pushViewController:fail animated:YES];
                                            break;
                                        }
                                    }
                                }
                                else
                                {
                                    AddCameraStepOneViewController *vc = [[AddCameraStepOneViewController alloc] initWithVCType:VCTypeAdd];
                                    [weakSelf.navigationController pushViewController:vc animated:YES];
                                }
                            }];
        }
        else
        {
            //失败
        }
        
        NSLog(@"%@",obj.stringValue);
        // 提示：如果需要对url或者名片等信息进行扫描，可以在此进行扩展！
    }
    
}




@end
