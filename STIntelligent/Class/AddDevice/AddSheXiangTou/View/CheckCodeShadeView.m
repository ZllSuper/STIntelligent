//
//  CheckCodeShadeView.m
//  ECarCommerciaiTenant
//
//  Created by 步晓虎 on 15/1/30.
//  Copyright (c) 2015年 步晓虎. All rights reserved.
//

#import "CheckCodeShadeView.h"

@implementation CheckCodeShadeView

- (instancetype) initWithFrame:(CGRect)frame andShowRect:(CGRect)showRect
{
    if (self = [super initWithFrame:frame])
    {
        self.showRect = showRect;
    }
    return self;
}

-(void) drawRect:(CGRect)rect2
{
    [super drawRect:rect2];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = self.showRect;
    
    CGContextSetRGBFillColor(context,   0.0, 0.0, 0.0, 0.7);
    CGContextSetRGBStrokeColor(context, 0.6, 0.6, 0.6, 1.0);
    
    
    float w = self.bounds.size.width;
    float h = self.bounds.size.height;
    
    CGRect clips2[] =
    {
        CGRectMake(0, 0, w, rect.origin.y),
        CGRectMake(0, rect.origin.y,rect.origin.x, rect.size.height),
        CGRectMake(0, rect.origin.y + rect.size.height, w, h-(rect.origin.y+rect.size.height)),
        CGRectMake(rect.origin.x + rect.size.width, rect.origin.y, w-(rect.origin.x + rect.size.width), rect.size.height),
    };
    CGContextClipToRects(context, clips2, sizeof(clips2) / sizeof(clips2[0]));
    
    CGContextFillRect(context, self.bounds);
    CGContextStrokeRect(context, rect);
    UIGraphicsEndImageContext();
}

@end
