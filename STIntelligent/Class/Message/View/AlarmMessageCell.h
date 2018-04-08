//
//  AlarmMessageCell.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/10.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlarmMessageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;

@end
