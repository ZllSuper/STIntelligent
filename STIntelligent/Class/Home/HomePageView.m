//
//  HomePageView.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/8/8.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "HomePageView.h"
#import "HomeDeviceView.h"

@interface HomePageView () <STThemeManagerProtcol>

@property (nonatomic, strong) HomeDeviceView *deviceView;

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation HomePageView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self addSubview:self.imageView];
        [self addSubview:self.imageBtn];
        [self addSubview:self.deviceView];
        
        [self  themeChange];
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        [self.imageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.left.and.right.mas_equalTo(self);
            make.height.mas_equalTo(self.imageBtn.mas_width).multipliedBy(718.0 / 1080);
        }];
        
        [self.deviceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(self);
            make.top.mas_equalTo(self.imageBtn.mas_bottom).offset(20);
            make.height.mas_equalTo(self.deviceView.mas_width).offset(-32);
        }];
        [[STThemeManager shareInstance] addThemeChangeProtcol:self];    }
    return self;
}

#pragma mark - protcol

- (void)themeChange
{
    self.imageView.image = ThemeImageWithName(@"HomeBack");
}

#pragma mark - public
- (void)reload
{
    [self.deviceView themeChange];
    [self.deviceView reloadName];
}

#pragma mark - action
- (void)maoYanAction
{
    if (self.delegate)
    {
        [self.delegate pageView:self maoYanAction:_pageModel.maoYanModel];
    }
}

- (void)cameraAction:(STControl *)control
{
    if (self.delegate)
    {
        [self.delegate pageView:self cameraAction:control.cameraModel];
    }
}

- (void)defaultAction
{
    if (self.delegate)
    {
         [self.delegate pageViewTopDefaultAction:self];
    }
}

#pragma mark - get
- (void)setPageModel:(DeveicePageModel *)pageModel
{
    _pageModel = pageModel;
    self.deviceView.pageModel = pageModel;
}

- (UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (BXHAvPlayerBtn *)imageBtn
{
    if (!_imageBtn)
    {
        _imageBtn = [BXHAvPlayerBtn buttonWithType:UIButtonTypeCustom];
        _imageBtn.backgroundColor = Color_White;
        [_imageBtn setImage:ImageWithName(@"HomeAVPlayIcon") forState:UIControlStateNormal];
        [_imageBtn setBackgroundImage:ImageWithName(@"HomeTopBack") forState:UIControlStateNormal];
        _imageBtn.contentMode = UIViewContentModeScaleAspectFill;
        _imageBtn.clipsToBounds = YES;
        [_imageBtn addTarget:self action:@selector(defaultAction) forControlEvents:UIControlEventTouchUpInside];
        if (_pageModel.defaultImage)
        {
            [_imageBtn setBackgroundImage:[UIImage imageWithData:[[NSData alloc] initWithBase64EncodedString:_pageModel.defaultImage options:NSDataBase64DecodingIgnoreUnknownCharacters]] forState:UIControlStateNormal];
        }
    }
    return _imageBtn;
}

- (HomeDeviceView *)deviceView
{
    if (!_deviceView)
    {
        _deviceView = [[HomeDeviceView alloc] init];
        [_deviceView.maoYanBtn addTarget:self action:@selector(maoYanAction) forControlEvents:UIControlEventTouchUpInside];
        [_deviceView.spOneBtn addTarget:self action:@selector(cameraAction:) forControlEvents:UIControlEventTouchUpInside];
        [_deviceView.spTwoBtn addTarget:self action:@selector(cameraAction:) forControlEvents:UIControlEventTouchUpInside];
        [_deviceView.spThreeBtn addTarget:self action:@selector(cameraAction:) forControlEvents:UIControlEventTouchUpInside];
        [_deviceView.spFourBtn addTarget:self action:@selector(cameraAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deviceView;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
