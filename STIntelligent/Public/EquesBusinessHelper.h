//
//  EquesBusinessHelper.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/6/2.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^MaoYanAddSuccessCallBack)(DeveicePageModel *pageModel, MaoYanModel *maoYanModel);

@class EquesBusinessHelper;
@protocol EquesBusinessHelperProtcol <NSObject>

- (void)equesBusinessHelper:(EquesBusinessHelper *)helper messageDict:(NSDictionary *)messageDict;

@end

@interface EquesBusinessHelper : NSObject

@property (nonatomic, strong, readonly) DeveicePageModel *addPageModel;

@property (nonatomic, strong, readonly) MaoYanModel *addMaoYanModel;

@property (nonatomic, copy) NSString *token;

+ (EquesBusinessHelper *)shareInstance;

- (void)startAddWithPageModel:(DeveicePageModel *)pageModel maoYanModel:(MaoYanModel *)maoYanModel successCallBack:(MaoYanAddSuccessCallBack)callBack;

- (void)equesLogin;

- (void)addProtcol:(id <EquesBusinessHelperProtcol>)protcol forMethod:(NSString *)method;

- (void)removeProtcolForMethod:(NSString *)method;

- (void)addEndWithSuccess:(BOOL)success;

@end
