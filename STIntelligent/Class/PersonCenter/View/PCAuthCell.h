//
//  PCAuthCell.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/10.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PCAuthListModel.h"

@class PCAuthCell;
@protocol PCAuthCellDelegate <NSObject>

- (BOOL)authCellTextFiledWillBegainEditing:(PCAuthCell *)authCell;

- (void)authCellTextFileEndEdit:(PCAuthCell *)authCell;

@end

@interface PCAuthCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UITextField *inputTextFiled;

@property (weak, nonatomic) PCAuthListModel *listModel;

@property (weak, nonatomic) id <PCAuthCellDelegate>delegate;

@end
