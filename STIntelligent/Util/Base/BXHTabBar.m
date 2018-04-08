//
//  BXHTabBar.m
//  HangZhouSchool
//
//  Created by 步晓虎 on 16/6/1.
//  Copyright © 2016年 步晓虎. All rights reserved.
//

#import "BXHTabBar.h"

@interface BXHTabBarItem()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *backImageView0;

@property (nonatomic, strong) UIImageView *backImageView;

@property (nonatomic, strong) NSMutableDictionary *valueDict;

@end

#define SelectImageKey @"SelectImageKey"
#define UnSelectImageKey @"UnSelectImageKey"
//#define SelectTextColorKey @"SelectTextColorKey"
//#define UnSelectTextColorKey @"UnSelectTextColorKey"

#define MidItemCircleGap 60

//CGFloat angleBetweenPoints(CGPoint first, CGPoint second)
//{
//    CGFloat height = second.y - first.y;
//    CGFloat width = first.x - second.x;
//    CGFloat rads = atan(height/width);
//    return RADIANS_TO_DEGREES(rads);
//}
//
//CGFloat distanceBetweenPoints (CGPoint first, CGPoint second)
//{
//    CGFloat deltaX = second.x - first.x;
//    CGFloat deltaY = second.y - first.y;
//    return sqrt(deltaX*deltaX + deltaY*deltaY );
//};
//
//CGPoint circleRadiusWithThreePoint(CGPoint first, CGPoint second, CGPoint three)
//{
//    CGFloat a = 2 * (second.x - first.x);
//    CGFloat b = 2 * (second.y - first.y);
//    CGFloat c = second.x * second.x + second.y * second.y - first.x * first.x - first.y * first.y;
//    CGFloat d = 2 * (three.x - second.x);
//    CGFloat e = 2 * (three.y - second.y);
//    CGFloat f = three.x * three.x + three.y * three.y - second.x * second.x - second.y * second.y;
//    CGFloat x = (b * f - e * c) / (b * d - e * a);
//    CGFloat y = (d * c - a * f) / (b * d - e * a);
//    return CGPointMake(x, y);
//}

@implementation BXHTabBarItem

- (instancetype) initWithItemType:(BXHTabBarItemType)itemType
{
    if (self = [super init])
    {
        _itemType = itemType;
        
        if (itemType == BXHTabBarItemImageType)
        {
//            CGPoint circleStartPoint = CGPointMake(DEF_SCREENWIDTH / 2 - MidItemCircleGap / 2, 0);
//            CGPoint circleEndPoint = CGPointMake(DEF_SCREENWIDTH / 2 + MidItemCircleGap / 2, 0);
//            CGPoint center = circleRadiusWithThreePoint(circleStartPoint, circleEndPoint, CGPointMake(DEF_SCREENWIDTH / 2, TabBarHeight));
            
//            CGFloat radius = TabBarHeight - center.y - 10;
            
            [self addSubview:self.backImageView0];
            [self.backImageView0 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self);
                make.bottom.mas_equalTo(self).offset(-5);
            }];

            [self addSubview:self.backImageView];
            [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self);
                make.centerY.mas_equalTo(self.backImageView0);
            }];
            
//            [self addSubview:self.backImageView];
//            [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerX.mas_equalTo(self);
//                make.bottom.mas_equalTo(self).offset(-5);
//            }];
            
//            self.imageView.clipsToBounds = YES;
//            self.imageView.layer.cornerRadius = radius;
            [self addSubview:self.imageView];
            [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self);
//                make.size.mas_equalTo(CGSizeMake(radius * 2, radius * 2));
                make.centerY.mas_equalTo(self.backImageView);
            }];
        }
        else
        {
            [self addSubview:self.imageView];
            [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self);
                make.top.mas_equalTo(self).offset(7.5);
                make.size.mas_equalTo(CGSizeMake(20, 20));
            }];
            [self addSubview:self.titleLabel];
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self);
                make.right.mas_equalTo(self);
                make.bottom.mas_equalTo(self).offset(-3);
            }];
        }
        
        self.valueDict = [[NSMutableDictionary alloc] init];
        
        [[STThemeManager shareInstance] addThemeChangeProtcol:self];

    }
    return self;
}

#pragma mark - themeProtcol
- (void)themeChange
{
    self.imageView.image = ThemeImageWithName(self.valueDict[self.selected ? SelectImageKey : UnSelectImageKey]);
    self.titleLabel.textColor = [UIColor getHexColorWithHexStr:self.selected ? [STThemeManager shareInstance].themeColor.barSelTextColor1 : [STThemeManager shareInstance].themeColor.barNormalTextColor];
}

#pragma mark - set / get
- (void)setImageName:(NSString *)imageName forState:(BOOL)selected
{
    [self.valueDict setObject:imageName forKey:selected ? SelectImageKey : UnSelectImageKey];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    self.imageView.image = ThemeImageWithName(self.valueDict[selected ? SelectImageKey : UnSelectImageKey]);
    self.titleLabel.textColor = [UIColor getHexColorWithHexStr:self.selected ? [STThemeManager shareInstance].themeColor.barSelTextColor1 : [STThemeManager shareInstance].themeColor.barNormalTextColor];
}

- (void)setBackImage:(UIImage *)image backImage:(UIImage *)backImage
{
    self.backImageView.image = image;
    self.backImageView0.image = backImage!=nil ? backImage : image;
}

- (UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:10];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIImageView *)backImageView0
{
    if (!_backImageView0)
    {
        _backImageView0 = [[UIImageView alloc] init];
    }
    return _backImageView0;
}

- (UIImageView *)backImageView
{
    if (!_backImageView)
    {
        _backImageView = [[UIImageView alloc] init];
    }
    return _backImageView;
}

- (void)setTitleText:(NSString *)titleText
{
    _titleText = titleText;
    self.titleLabel.text = _titleText;
}

@end


@implementation BXHTabBar

- (instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = Color_Clear;
        [self themeChange];
//        [self.layer addSublayer:self.shapeLayer];
        
        [self addSubview:self.backgroundImageView0];
        [self.backgroundImageView0 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.bottom.mas_equalTo(self);
            make.height.mas_equalTo(self.backgroundImageView0.mas_width).multipliedBy(113.0/720);
        }];
        
        [self addSubview:self.backgroundImageView];
        [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.bottom.mas_equalTo(self);
//            make.height.mas_equalTo(self.backgroundImageView.mas_width).multipliedBy(88.0/720);
            make.height.mas_equalTo(@(TabBarHeight));
        }];
        
        [[STThemeManager shareInstance] addThemeChangeProtcol:self];
//        self.backgroundColor = [UIColor getHexColorWithHexStr:@"#f9f9f9"];
    }
    return self;
}


//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
//{
//    BOOL inside = CGPathContainsPoint(self.tabBarPath.CGPath, NULL, point, NO);
//    return inside;
//}
//
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    UIView *view = [super hitTest:point withEvent:event];
//    if ([view isEqual:self])
//    {
//        return self.items[2];
//    }
//    return view;
//}

- (void)themeChange
{
//    self.shapeLayer.fillColor = [UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.bottomBarBackColor].CGColor;
    self.backgroundImageView0.image = ThemeImageWithName(@"TabBarBackImg");
    self.backgroundImageView.image = ThemeImageWithName(@"TabBarBack");
}

- (void)setItems:(NSArray<BXHTabBarItem *> *)items
{
    CGFloat itemWidth = (DEF_SCREENWIDTH - ItemGap * (items.count + 1)) / items.count;
    for (BXHTabBarItem *item in items)
    {
        NSInteger index = [items indexOfObject:item];
        item.selected = index == 0;
        item.frame = CGRectMake(index * (itemWidth + ItemGap) + ItemGap, 0, itemWidth, TabBarHeight);
        [item addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:item];
    }
    _items = items;
}

- (void)setItemSelectAtIndex:(NSInteger)index
{
    BXHTabBarItem *item = self.items[index];
    [item sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)itemAction:(BXHTabBarItem *)item
{
    self.selectIndex = [self.items indexOfObject:item];
}

- (void)setSelectIndex:(NSInteger)selectIndex
{
    if (self.delelgate)
    {
       BOOL canSelect = [self.delelgate tabBar:self selectItemAtIndex:selectIndex];
        if (canSelect)
        {
            for (BXHTabBarItem *allItem in self.items)
            {
                allItem.selected = NO;
            }
            BXHTabBarItem *item = self.items[selectIndex];
            item.selected = YES;
            _selectIndex = selectIndex;

        }
    }
}

#pragma mark - get
- (UIImageView *)backgroundImageView0
{
    if (!_backgroundImageView0)
    {
        _backgroundImageView0 = [[UIImageView alloc] init];
    }
    return _backgroundImageView0;
}

- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView)
    {
        _backgroundImageView = [[UIImageView alloc] init];
    }
    return _backgroundImageView;
}

//
//- (UIBezierPath *)tabBarPath
//{
//    if (!_tabBarPath)
//    {
//        CGPoint circleStartPoint = CGPointMake(DEF_SCREENWIDTH / 2 - MidItemCircleGap / 2, 0);
//        CGPoint circleEndPoint = CGPointMake(DEF_SCREENWIDTH / 2 + MidItemCircleGap / 2, 0);
//        CGPoint center = circleRadiusWithThreePoint(circleStartPoint, circleEndPoint, CGPointMake(DEF_SCREENWIDTH / 2, TabBarHeight));
//        CGFloat angle = 90 - fabs(angleBetweenPoints(circleStartPoint, center));
//        CGFloat radius = TabBarHeight - center.y;
//        
//        _tabBarPath = [[UIBezierPath alloc] init];
//        [_tabBarPath moveToPoint:CGPointZero];
//        [_tabBarPath addLineToPoint:circleStartPoint];
//        [_tabBarPath addArcWithCenter:center radius:radius startAngle:DEGREES_TO_RADIANS(270 - angle) endAngle:DEGREES_TO_RADIANS(270 + angle) clockwise:YES];
//        [_tabBarPath addLineToPoint:CGPointMake(DEF_SCREENWIDTH, 0)];
//        [_tabBarPath addLineToPoint:CGPointMake(DEF_SCREENWIDTH, TabBarHeight)];
//        [_tabBarPath addLineToPoint:CGPointMake(0, TabBarHeight)];
//    }
//    return _tabBarPath;
//}
//
//- (CAShapeLayer *)shapeLayer
//{
//    if (!_shapeLayer)
//    {
//        _shapeLayer = [[CAShapeLayer alloc] init];
//        _shapeLayer.path = self.tabBarPath.CGPath;
//    }
//    return _shapeLayer;
//}

@end
