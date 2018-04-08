//
//  DevicePicListModel.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/19.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DevicePicListModel : NSObject

@property (nonatomic, copy) NSString *normalImage;

@property (nonatomic, copy) NSString *selImage;

@property (nonatomic, copy) NSString *serverKey;

@property (nonatomic, assign) BOOL sel;

@end
