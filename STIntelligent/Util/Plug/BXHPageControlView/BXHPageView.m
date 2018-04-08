//
//  BXHPageView.m
//  CollectionView
//
//  Created by 步晓虎 on 2017/8/7.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "BXHPageView.h"

@interface BXHPageView ()

@property (nonatomic, strong) UIView *enableView;

@property (nonatomic, strong) UIButton *delBtn;

@end

@implementation BXHPageView

- (instancetype)init
{
    if (self = [super init])
    {
        self.clipsToBounds = NO;
        
        [super addSubview:self.enableView];
        [super addSubview:self.delBtn];
        
        [self.enableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        [self.delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).offset(15);
            make.top.mas_equalTo(self).offset(-15);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        
        self.scale = 1;
    }
    return self;
}

- (void)addSubview:(UIView *)view
{
    [self insertSubview:view belowSubview:self.enableView];
}

#pragma mark - action
- (void)delBtnAction:(UIButton *)sender
{
    if (self.deltDelegate)
    {
        [self.deltDelegate deltBtnActionPageView:self];
    }
}

#pragma mark - delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]
        && [otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIScrollViewPanGestureRecognizer")])
    {
        return YES;
    }
    else
    {
        return  NO;
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGPoint buttonPoint = [self convertPoint:point toView:self.delBtn];
    
    // 需要注意这里的调用者是_button，因为这里的point是buttonPoint也就是绿色Button中的点
    if ([self.delBtn pointInside:buttonPoint withEvent:event])
    {
        return YES;
    }
    
    return [super pointInside:point withEvent:event];
}


#pragma mark - get
- (UIView *)enableView
{
    if (!_enableView)
    {
        _enableView = [[UIView alloc] init];
        _enableView.backgroundColor = [UIColor clearColor];
    }
    return _enableView;
}

- (UIButton *)delBtn
{
    if (!_delBtn)
    {
        _delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_delBtn setBackgroundImage:ImageWithName(@"PageViewDelete") forState:UIControlStateNormal];
        [_delBtn addTarget:self action:@selector(delBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _delBtn;
}

- (void)setScale:(CGFloat)scale
{
    _scale = scale;
    
    self.transform = CGAffineTransformMakeScale(scale, scale);
    self.delBtn.alpha = (1 - scale) * 10 / 3;
    self.enableView.hidden = _scale >= 1;

}

@end
