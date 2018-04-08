//
//  PCAuthCell.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/10.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "PCAuthCell.h"

@implementation PCAuthCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.inputTextFiled.delegate = self;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return [self.delegate authCellTextFiledWillBegainEditing:self];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self.delegate authCellTextFileEndEdit:self];
    return YES;
}

- (void)setListModel:(PCAuthListModel *)listModel
{
    _listModel = listModel;
    self.titleLabel.text = listModel.title;
    self.inputTextFiled.placeholder = listModel.placeholder;
    self.inputTextFiled.text = listModel.inputValue;
}

@end
