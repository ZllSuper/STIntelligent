//
//  AliPayManager.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/10/10.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APAuthV2Info.h"
#import <AlipaySDK/AlipaySDK.h>
#import "RSADataSigner.h"

@interface AliPayManager : NSObject

- (void)alipayAuthLogin:(CompletionBlock)complete;

@end
