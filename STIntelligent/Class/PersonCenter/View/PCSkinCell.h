//
//  PCSkinCell.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/6/20.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PCSkinModel.h"

@interface PCSkinCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *themeImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *themeSelectIcon;

@property (nonatomic, weak) PCSkinModel *weakModel;

@end
