//
//  PCCommunityListModel.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/7/6.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCCommunityListModel : NSObject

@property (nonatomic, copy) NSString *CommunityName;

@property (nonatomic, copy) NSString *CommunityAddress;

@property (nonatomic, copy) NSString *CommunityIntroduce;

@property (nonatomic, copy) NSNumber *ActivatedState; //1通过，2审核中，0未通过

@property (nonatomic, copy) NSString *ImgUrl;




- (NSString *)statueStr;

@end
