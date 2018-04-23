//
//  AuthorizationHandler.m
//  WKTakePhoto
//
//  Created by liangliang.zhu liangliang.zhu@meta-insight.com on 2017/7/26.
//  Copyright © 2017年 meta-insight.com. All rights reserved.
//

#import "AuthorizationHandler.h"
#import "UIAlertView+Common.h"

@implementation AuthorizationHandler

+ (void)checkCameraAuthorization:(void(^)(BOOL success, AVAuthorizationStatus status))completionBlock
{
    if (completionBlock) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusNotDetermined) { //用户尚未选择客户端是否可以访问硬件
            NSLog(@"尚未选择相机权限");
            completionBlock (NO, status);
        }
        else if (status == AVAuthorizationStatusRestricted ||//此应用程序没有被授权访问的照片数据。可能是家长控制权限
                 status == AVAuthorizationStatusDenied)  //用户已经明确否认了这一照片数据的应用程序访问
        {
            NSLog(@"无相机权限");
            completionBlock (NO, status);

            //        // 无权限 引导去开启
            //        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            //        if ([[UIApplication sharedApplication]canOpenURL:url]) {
            //            [[UIApplication sharedApplication]openURL:url];
            //        }
        }
        else { //已经授权
            completionBlock (YES, status);
        }
    }
}

+ (void)checkPhotoLibraryAuthorization:(void(^)(BOOL success, PHAuthorizationStatus status))completionBlock
{
    if (completionBlock) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized){
                NSLog(@"用户允许当前应用访问相册");
                completionBlock (YES, status);
            }
            else {
                completionBlock (NO, status);
            }
        }];
    }
}

+ (void)checkLocationAuthorization:(void(^)(BOOL success, CLAuthorizationStatus status))completionBlock
{
    if (completionBlock) {
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        if (status == kCLAuthorizationStatusNotDetermined) { //用户尚未选择客户端是否可以访问硬件
            NSLog(@"尚未选择定位权限");
            completionBlock (NO, status);
        }
        else if (status == kCLAuthorizationStatusRestricted ||//此应用程序没有被授权访问的照片数据。可能是家长控制权限
                 status == kCLAuthorizationStatusDenied)  //用户已经明确否认了这一照片数据的应用程序访问
        {
            NSLog(@"无定位权限");
            completionBlock (NO, status);
            
            //        // 无权限 引导去开启
            //        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            //        if ([[UIApplication sharedApplication]canOpenURL:url]) {
            //            [[UIApplication sharedApplication]openURL:url];
            //        }
        }
        else { //已经授权
            completionBlock (YES, status);
        }
    }
}

+ (void)checkMicrophoneAuthorization:(void(^)(void))completionBlock
{
    if (completionBlock) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
        if (status == AVAuthorizationStatusNotDetermined) { //用户尚未选择客户端是否可以访问硬件
            NSLog(@"尚未选择麦克风权限");
            
            [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
                if (granted) {
                    // Microphone enabled code
                    completionBlock ();
                }
                else {
                    // Microphone disabled code
                    [UIAlertView alertWithTitle:NSLocalizedString(@"Sys-Alert-Title", nil) message:NSLocalizedString(@"Sys-MicrophoneAuth", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Sys-OKButton", nil) otherButtonTitles: nil];
                }
            }];
        }
        else if (status == AVAuthorizationStatusRestricted ||//家长控制权限
                 status == AVAuthorizationStatusDenied)  //已拒绝
        {
            NSLog(@"无麦克风权限");
            
            [UIAlertView alertWithTitle:NSLocalizedString(@"Sys-Alert-Title", nil) message:NSLocalizedString(@"Sys-MicrophoneAuth", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Sys-OKButton", nil) otherButtonTitles: nil];
            //        // 无权限 引导去开启
            //        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            //        if ([[UIApplication sharedApplication]canOpenURL:url]) {
            //            [[UIApplication sharedApplication]openURL:url];
            //        }
        }
        else { //已经授权
            completionBlock ();
        }
    }
}

@end
