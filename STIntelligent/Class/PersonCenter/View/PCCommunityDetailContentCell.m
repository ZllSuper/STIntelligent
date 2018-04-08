//
//  PCCommunityDetailContentCell.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/10.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "PCCommunityDetailContentCell.h"

@implementation PCCommunityDetailContentCell

+ (CGFloat)cellHeightWithContent:(NSString *)content
{
   CGSize size = [content size_With_Font:Font_sys_14 constrainedToSize:CGSizeMake(DEF_SCREENWIDTH - 32, MAXFLOAT)];
    return size.height + 20 + 5;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
