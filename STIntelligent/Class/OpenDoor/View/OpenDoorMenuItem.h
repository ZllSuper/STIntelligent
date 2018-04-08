//
//  OpenDoorMenuItem.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/19.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "OpenDoorCircleMenu.h"
#import "ODDoorModel.h"

@interface OpenDoorMenuItem : CircleMenuItem <STThemeManagerProtcol>

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, weak) ODDoorModel *weakModel;

@end
