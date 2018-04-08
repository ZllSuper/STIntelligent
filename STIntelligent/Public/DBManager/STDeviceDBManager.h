//
//  STDeviceDBManager.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/6/1.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MaoYanModel.h"
#import "DeveicePageModel.h"
#import "SheXiangTouModel.h"

@interface STDeviceDBManager : NSObject

+ (STDeviceDBManager *)shareInstace;

- (BOOL)autoInsertUser:(AccountInfo *)accountInfo;

- (NSMutableArray <DeveicePageModel *>*)getDevicePages;

- (void)fillPageModelWithPageModel:(DeveicePageModel *)pageModel;

- (MaoYanModel *)fillMaoYanModelWithMaoYanModelID:(NSString *)maoYanId maoYanModel:(MaoYanModel *)maoYanModel;

- (SheXiangTouModel *)fillSheXiangTouWithSheXiangTou:(NSString *)sheXiangTouId sheXiangTouModel:(SheXiangTouModel *)sheXiangTouModel;

- (BOOL)insertOrUpdatePageModel:(DeveicePageModel *)pageModel;

- (BOOL)insertOrUpdateMaoYanModel:(MaoYanModel *)maoYanModel;

- (BOOL)insertOrUpdateSheXiangTouModel:(SheXiangTouModel *)sheXiangTouModel;


@end
