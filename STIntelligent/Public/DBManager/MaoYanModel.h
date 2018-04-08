//
//  MaoYanModel.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/31.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MaoYanModel : NSObject

@property (nonatomic, copy) NSString *Name;

@property (nonatomic, copy) NSString *Icon;

@property (nonatomic, copy) NSString *reqid;

@property (nonatomic, copy) NSString *bid; //device 唯一标识符

@property (nonatomic, copy) NSString *uid; //deviceId;

@property (nonatomic, copy) NSString *wifi_config; //wife名

@property (nonatomic, copy) NSNumber *alarm_enable; //人体检测报警

@property (nonatomic, copy) NSNumber *db_light_enable; //门铃灯开关

@property (nonatomic, copy) NSString *sw_version; //软件版本



@end
