//
//  PersonCenterHeaderView.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/10.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonCenterHeaderBottomView.h"

@interface PersonCenterHeaderView : UIView 

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIImageView *headerBackView;

@property (nonatomic, strong) UIImageView *headerImageView;

@property (nonatomic, strong) UIImageView *backImageView;

@property (nonatomic, strong) PersonCenterHeaderBottomView *bottomView;

@end
