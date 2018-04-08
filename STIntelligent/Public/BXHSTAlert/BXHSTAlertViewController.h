//
//  BXHSTAlertViewController.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/6/13.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import <UIKit/UIKit.h>


@class BXHSTAlertViewController;
@protocol BXHSTAlertViewControllerProtcol <NSObject>

- (void)bxhAlertViewController:(BXHSTAlertViewController *)vc clickIndex:(NSInteger)index;

@end

@interface BXHSTAlertViewController : UIViewController

@property (nonatomic, readonly, strong) UIView *contentView;

@property (nonatomic, weak) id <BXHSTAlertViewControllerProtcol>protcol;

+ (BXHSTAlertViewController *)alertControllerWithContentView:(UIView *)contentView andSize:(CGSize)size;

- (void)actionBtnAction:(UIButton *)sender;

@end
