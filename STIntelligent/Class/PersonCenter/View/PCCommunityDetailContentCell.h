//
//  PCCommunityDetailContentCell.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/10.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCCommunityDetailContentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

+ (CGFloat)cellHeightWithContent:(NSString *)content;

@end
