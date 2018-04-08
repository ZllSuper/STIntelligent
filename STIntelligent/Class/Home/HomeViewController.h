//
//  HomeViewController.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/8.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController

@property (nonatomic, readonly, weak) DeveicePageModel *pageModel;

- (instancetype)initWithPageModel:(DeveicePageModel *)pageModel;

@end
