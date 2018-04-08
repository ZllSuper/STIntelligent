//
//  PCSkinCell.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/6/20.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "PCSkinCell.h"

@implementation PCSkinCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setWeakModel:(PCSkinModel *)weakModel
{
    _weakModel = weakModel;
    self.themeImageView.image = ImageWithName(weakModel.themeImage);
    self.titleLabel.text = weakModel.title;
    self.themeSelectIcon.hidden = !weakModel.sel;
}

@end
