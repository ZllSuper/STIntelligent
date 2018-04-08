//
//  BXHPageControlView.m
//  CollectionView
//
//  Created by 步晓虎 on 2017/8/7.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "BXHPageControlView.h"

@interface BXHPageControlView () <BXHPageViewDelegate>

@property (nonatomic, strong) NSMutableArray *mPageViews;

@property (nonatomic, assign) CGFloat scale;

@property (nonatomic, assign) CGPoint startPoint;

@property (nonatomic, assign) CGFloat minRegion;

@end

@implementation BXHPageControlView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.mPageViews = [NSMutableArray arrayWithCapacity:1];
        self.pagingEnabled = YES;
        self.minRegion = 0;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
    }
    return self;
}

#pragma mark pulic
- (void)reloadPageViews:(NSArray<BXHPageView *> *)pageViews
{
    [self.mPageViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.mPageViews = [NSMutableArray arrayWithArray:pageViews];
    for (BXHPageView *pageView in self.mPageViews)
    {
        BXHPageView *tempPageView = [self reInitPageView:pageView];
        [self addSubview:tempPageView];
    }
    
    self.scale = 1;
    [self needLayoutSubViews];
}

- (void)removePageView:(BXHPageView *)pageView
{
    [self.mPageViews removeObject:pageView];
    [UIView animateWithDuration:0.2 animations:^{
        self.scale = 1;
        [self needLayoutSubViews];
    }];
}

- (void)addPageView:(BXHPageView *)pageView
{
    pageView = [self reInitPageView:pageView];
    [self.mPageViews addObject:pageView];
    [self addSubview:pageView];
    [self needLayoutSubViews];
    [self setContentOffset:CGPointMake((self.mPageViews.count - 1) * self.width, 0)  animated:YES];
}

#pragma mark - private
- (void)animateToScale:(CGFloat)scale
{
    [UIView animateWithDuration:0.2 animations:^{
        self.scale = scale;
    }];
}

- (void)needLayoutSubViews
{
    self.contentSize = CGSizeMake(self.frame.size.width * self.mPageViews.count, 0);
    for (BXHPageView *pageView in self.mPageViews)
    {
        NSUInteger index = [self.mPageViews indexOfObject:pageView];
        pageView.frame = CGRectMake(index * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    }
}

- (BXHPageView *)reInitPageView:(BXHPageView *)pageView
{
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureRecognizer:)];
//    pan.delegate = pageView;
//    pageView.deltDelegate = self;
//    [pageView addGestureRecognizer:pan];
    return pageView;
}

#pragma mark - handleAction

- (void)handlePanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer
{
    if (self.mPageViews.count <= 1)
    {
        return;
    }
    CGPoint velocity = [panGestureRecognizer velocityInView:self];
    BOOL v = fabs(velocity.y) >= fabs(velocity.x);
    BOOL up = velocity.y < 0;
    BOOL down = velocity.y >= 0;
    if (!v)
    {
         return;
    }
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        
        self.startPoint = [panGestureRecognizer locationInView:self];
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        CGPoint currentPoint = [panGestureRecognizer locationInView:self];
        
        if (up)
        {
            CGFloat tempScale = self.scale;
            CGFloat change = self.startPoint.y - currentPoint.y;
            tempScale += change / (self.frame.size.width * 0.3);
            
            if (tempScale >= 1)
            {
                tempScale = 1;
            }
            
            if (tempScale >= self.scale)
            {
                self.scale = tempScale;
            }

        }
        else if (down)
        {
            CGFloat tempScale = self.scale;
            CGFloat change = currentPoint.y - self.startPoint.y;
            tempScale = 1 - change / (self.frame.size.width * 0.3);
            if (tempScale <= 0.7)
            {
                tempScale = 0.7;
            }
            
            if (tempScale <= self.scale)
            {
                self.scale = tempScale;
            }

        }
        NSLog(@"\\\\\\\\\\\\\\\\\\\\\\\%f",self.scale);
        
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"===========================%f",self.scale);
        if (self.scale > 0.8)
        {
            [self animateToScale:1];
        }
        else
        {
            [self animateToScale:0.7];
        }
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateCancelled)
    {
        [self animateToScale:1];
    }
    else
    {
        NSLog(@"--------------------%ld",(long)panGestureRecognizer.state);
    }
}

#pragma mark - protcol
- (void)deltBtnActionPageView:(BXHPageView *)pageView
{
    if (self.deltDelegate)
    {
        [self.deltDelegate pageControlView:self deltWithPageView:pageView];
    }
}

#pragma mark - get
- (NSArray<BXHPageView *> *)pageViews
{
    return [NSArray arrayWithArray:self.mPageViews];
}

- (void)setScale:(CGFloat)scale
{
    NSLog(@"+++++++++++++++++++++++++++++++");
    _scale = scale;
    for (BXHPageView *pageView in self.pageViews)
    {
        pageView.scale = scale;
    }
}




@end
