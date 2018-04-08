//
//  MessageContentViewController.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/9/12.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SystemMessageModel.h"

typedef NS_ENUM(NSInteger,MessageContentType)
{
    MessageContentTextType,
    MessageContentWebType
};

@interface MessageContentViewController : UIViewController

@property (nonatomic, readonly) MessageContentType contentType;

- (instancetype)initWithContentType:(MessageContentType)contentType andSystemModel:(SystemMessageModel *)messageModel;

@end
