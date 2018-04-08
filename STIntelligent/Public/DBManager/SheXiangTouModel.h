//
//  SheXiangTouModel.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/6/1.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SheXiangTouModel : NSObject

//@property (nonatomic, copy) NSString *cameraId;

@property (nonatomic, copy) NSString *deviceSerialNo;  //设备序列号

@property (nonatomic, copy) NSString *deviceModel;     //设备类型字符串

@property (nonatomic, copy) NSString *deviceVerifyCode; //设备验证码

@property (nonatomic, copy) NSMutableDictionary *deviceVerifyCodeBySerial; //内存存储：设备验证码（Value）序列号（Key）字典

@property (nonatomic, copy) NSString *Name;

@property (nonatomic, copy) NSString *Icon;

@end
