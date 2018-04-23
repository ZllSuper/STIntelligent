//
//  AuthorizationHandler.h
//  WKTakePhoto
//
//  Created by liangliang.zhu liangliang.zhu@meta-insight.com on 2017/7/26.
//  Copyright © 2017年 meta-insight.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import<AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <CoreLocation/CLLocationManager.h>
#import <Photos/Photos.h>

/**
 用户权限检测工具类
 */
@interface AuthorizationHandler : NSObject

/**
 相机权限检测

 @param completionBlock 回调
 */
+ (void)checkCameraAuthorization:(void(^)(BOOL success, AVAuthorizationStatus status))completionBlock;

/**
 相册权限检测
 
 @param completionBlock 回调
 */
+ (void)checkPhotoLibraryAuthorization:(void(^)(BOOL success, PHAuthorizationStatus status))completionBlock;

/**
 定位权限检测
 
 @param completionBlock 回调
 */
+ (void)checkLocationAuthorization:(void(^)(BOOL success, CLAuthorizationStatus status))completionBlock;

/**
 话筒权限检测
 
 @param completionBlock 回调
 */
+ (void)checkMicrophoneAuthorization:(void(^)(void))completionBlock;

@end
