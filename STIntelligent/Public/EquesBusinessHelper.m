//
//  EquesBusinessHelper.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/6/2.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "EquesBusinessHelper.h"
#import <EquesBusiness/YKBusinessFramework.h>

@interface EquesBusinessHelper ()

@property (nonatomic, strong) NSMapTable *protocols;

@property (nonatomic, copy) MaoYanAddSuccessCallBack callBack;

@end

@implementation EquesBusinessHelper

+ (EquesBusinessHelper *)shareInstance
{
    static dispatch_once_t onceToken;
    static EquesBusinessHelper *helper = nil;
    dispatch_once(&onceToken, ^{
        helper = [[EquesBusinessHelper alloc] init];
    });
    return helper;
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.protocols =[NSMapTable
                          mapTableWithKeyOptions:NSMapTableCopyIn
                          valueOptions:NSMapTableWeakMemory];;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMessageResult:) name:equesOnMessageResultNotification object:nil];
    }
    return self;
}

- (void)startAddWithPageModel:(DeveicePageModel *)pageModel maoYanModel:(MaoYanModel *)maoYanModel successCallBack:(MaoYanAddSuccessCallBack)callBack
{
    self.callBack = callBack;
    
    _addPageModel = [[DeveicePageModel alloc] init];
    _addPageModel.pageId = pageModel.pageId;
    
    _addMaoYanModel = [[MaoYanModel alloc] init];
}

#pragma mark - notificationCall
- (void)onMessageResult:(NSNotification *)notification
{

   NSDictionary *messageResult = [notification object];
   
    NSString *method = messageResult[@"method"];
    if ([method isEqualToString:MAOYAN_LOGIN_METHOD])
    {
        self.token = messageResult[@"token"];
    }
    else if ([method isEqualToString:MAOYAN_BIND_RETURN_METHOD])
    {
        self.addMaoYanModel.reqid = messageResult[@"reqid"];
        self.addMaoYanModel.bid = messageResult[@"bid"];
    }
    else if ([method isEqualToString:MAOYAN_DEVICEADD_METHOD])
    {
        NSNumber *code = messageResult[@"code"];
        if ([code integerValue] == 4000)
        {
            NSArray *onlines = messageResult[@"onlines"];
            NSDictionary *dict = [onlines firstObject];
            NSString *uid = dict[@"uid"];
            if (!StringIsEmpty(uid))
            {
                self.addMaoYanModel.uid = uid;
            }
 
        }
    }
    else if ([method isEqualToString:@"devst"])
    {
        if (StringIsEmpty(self.addMaoYanModel.bid))
        {
            self.addMaoYanModel.bid = messageResult[@"bid"];
        }
    }

    id <EquesBusinessHelperProtcol> protcol = [self.protocols objectForKey:method];
    if (protcol)
    {
       [protcol equesBusinessHelper:self messageDict:messageResult];
    }
}

- (void)equesLogin
{
    [YKBusinessFramework equesSdkLoginWithUrl:MAOYAN_SERVERADDRESS username:[NSString stringWithFormat:@"%@%@",MAOYAN_USERNAME,KAccountInfo.userId] appKey:MAOYAN_APPKEY];
}

- (void)addEndWithSuccess:(BOOL)success
{
    if (success)
    {
        self.callBack(_addPageModel, _addMaoYanModel);
    }
    _addMaoYanModel = nil;
    _addPageModel = nil;
}

- (void)addProtcol:(id<EquesBusinessHelperProtcol>)protcol forMethod:(NSString *)method
{
    [self.protocols setObject:protcol forKey:method];
}

- (void)removeProtcolForMethod:(NSString *)method
{
    [self.protocols removeObjectForKey:method];
}


@end
