//
//  OpenDoorCircleMenu.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/19.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "OpenDoorCircleMenu.h"

@implementation CircleMenuItem


@end

@interface OpenDoorCircleMenu()

@property (nonatomic, assign) CGFloat radius;

@property (nonatomic, assign) CGSize itemSize;

@property (nonatomic, assign) CGFloat sideGap;

@property (nonatomic, assign) CGFloat midGap;

@property (nonatomic, strong) NSMutableArray *displayItems;

@end

@implementation OpenDoorCircleMenu

- (instancetype)initWithWithItemSize:(CGSize)size
{
    if (self = [super init])
    {
        self.backgroundColor = Color_Clear;
        self.itemSize = size;
        self.showsHorizontalScrollIndicator = NO;
        self.displayItems = [NSMutableArray arrayWithCapacity:3];
        self.delegate = self;
    }
    return self;
}

#pragma mark - action
- (void)itemAction:(CircleMenuItem *)item
{
    if (self.protcol)
    {
        [self.protcol circleMenu:self itemAction:item];
    }
}

- (void)setItems:(NSArray<CircleMenuItem *> *)items
{
    _items = items;
    [self removeAllSubviews];
    for (CircleMenuItem *inItem in self.items)
    {
        [self addSubview:inItem];
        [inItem addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)animateWithFrameSize:(CGSize)size
{
    self.size = size;
    [self layoutSubviewsWithContentOffset];
    self.contentOffset = CGPointMake(100, 0);
    [self setContentOffset:CGPointZero animated:YES];
}

- (void)layoutSubviewsWithContentOffset
{
    self.radius = self.width / 2 - self.itemSize.width / 2;
    self.sideGap =  self.width / 2 - (self.radius * cos(DEGREES_TO_RADIANS(30)));
    self.midGap = sin(DEGREES_TO_RADIANS(60)) * self.radius;
    [self.displayItems removeAllObjects];
    for (CircleMenuItem *inItem in self.items)
    {
        inItem.size = self.itemSize;
        NSInteger index = [self.items indexOfObject:inItem];
        inItem.centerX = index * self.midGap + self.sideGap;
        
        CGFloat circlePointX = inItem.centerX - self.contentOffset.x;
        if (circlePointX <= self.itemSize.width / 2 || circlePointX >= (self.radius * 2 + self.itemSize.width / 2))
        {
            inItem.centerY = self.height;
            inItem.alpha = 0;
        }
        else
        {
            inItem.alpha = 1;
            inItem.centerY = [self circlePointYGetWithPointX:circlePointX];
            [self.displayItems addObject:inItem];
        }
    }
    
    self.contentSize = CGSizeMake((self.items.count - 1) * self.midGap + self.sideGap * 2, self.height);
    
    [self setNeedsDisplay];
}

- (CGFloat)circlePointYGetWithPointX:(CGFloat)pointX
{
    CGPoint circlePoint = [self pointToOtherPoint:CGPointMake(self.width / 2, self.height)];
    CGFloat needQrt = self.radius * self.radius - (pointX - circlePoint.x) * (pointX - circlePoint.x);
    CGFloat qrt = sqrt(fabs(needQrt));
    CGFloat result = qrt + circlePoint.y;
    return self.height - result;
}


- (CGPoint)pointToOtherPoint:(CGPoint)currentPoint
{
    return CGPointMake(currentPoint.x, self.height - currentPoint.y);
}

- (CGFloat)angleWithPoint:(CGPoint)point circlePoint:(CGPoint)circlePoint
{
    CGFloat angle = fabs(atan((point.y-circlePoint.y)/(point.x-circlePoint.x)));

    if (point.x <= circlePoint.x)
    {
        //左半区
        if (point.y <= circlePoint.y)
        {
            //三象限
            return angle + M_PI;
            
        }
        else
        {
            //二象限
            return 0;
        }
    }
    else
    {
        //右半区
        if (point.y <= circlePoint.y)
        {
            //四象限
            return M_PI + M_PI_2 + (M_PI_2 - angle);
        }
        else
        {
            //一象限
            return 0;
        }

    }
}

- (CGPoint)endPointWithRadius:(CGFloat)radius  startPoint:(CGPoint)startPoint angle:(CGFloat)angle
{
    int index = angle / M_PI_2; //用户区分在第几象限内
    index = index % 3;
    float x = 0,y = 0;//用于保存_dotView的frame
    x = startPoint.x + cos(angle)*radius;
    y = startPoint.y + sin(angle)*radius;
    
    return CGPointMake(x, y);
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect
{
    CGFloat preAngle = M_PI;
    CGPoint circelPoint = CGPointMake(self.contentOffset.x + self.itemSize.width / 2 + self.radius, self.height);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.openDoorColor].CGColor);
    CGContextSetLineWidth(context, 1);
    
    
    for (int i = 0; i <= self.displayItems.count; i++)
    {

        if (i < self.displayItems.count)
        {
            CircleMenuItem *inItem = self.displayItems[i];
            CGFloat angle = [self angleWithPoint:inItem.center circlePoint:circelPoint];
            CGFloat endAngle = DEGREES_TO_RADIANS(RADIANS_TO_DEGREES(angle) - 12);
            if (preAngle < endAngle)
            {
                CGContextAddArc(context, circelPoint.x, circelPoint.y, self.radius, preAngle, endAngle, NO);
            }
            preAngle = DEGREES_TO_RADIANS(RADIANS_TO_DEGREES(angle) + 12);
            CGPoint endPoint = [self endPointWithRadius:self.radius startPoint:circelPoint angle:preAngle];
            CGContextMoveToPoint(context, endPoint.x, endPoint.y);
        }
        else
        {
            if (preAngle < M_PI * 2)
            {
                CGContextAddArc(context, circelPoint.x, circelPoint.y, self.radius, preAngle, M_PI * 2, NO);
            }
        }
        CGContextDrawPath(context, kCGPathStroke);
    }
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self layoutSubviewsWithContentOffset];
}



@end
