//
//  OpenDoorContentView.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/19.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "OpenDoorContentView.h"
#import "ODCommunityListRequest.h"
#import "ODOpenDoorRequest.h"

#import "ODCommunityModel.h"

@interface OpenDoorContentView() <CLLocationManagerDelegate>

@property (nonatomic, strong) NSArray *communities;

@property (nonatomic, weak) ODCommunityModel *selModel;

@property (nonatomic, strong) ODDoorModel *openModel;

@property (nonatomic, strong) CLLocation *updateLocation;

@end

@implementation OpenDoorContentView

- (void)dealloc
{
    self.locService.delegate = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
        
        [self addSubview:self.menu];
        [self.menu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(16);
            make.right.mas_equalTo(self).offset(-16);
            make.bottom.mas_equalTo(self);
            make.height.mas_equalTo(self.menu.mas_width).multipliedBy(0.5).offset(10);
        }];
        
        [self addSubview:self.titleButton];
        [self.titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(self).offset(20);
            make.height.mas_equalTo(@44);
            make.width.mas_equalTo(120);
        }];
        
        [self.titleButton addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.mas_equalTo(self.titleButton);
            make.right.mas_equalTo(self.titleButton).offset(-10);
        }];
        
        [self addSubview:self.animateImageView];
        [self.animateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.centerY.mas_equalTo(self).offset(-50);
            make.left.mas_equalTo(self);
            make.right.mas_equalTo(self);
            make.height.mas_equalTo(self.animateImageView.mas_width).multipliedBy(41.0 / 54);
        }];
        
        [self addSubview:self.openSuccLabel];
        [self.openSuccLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.animateImageView);
        }];
        
        [[STThemeManager shareInstance] addThemeChangeProtcol:self];
        [self themeChange];
        
    }
    return self;
}

- (void)themeChange
{
    [self.titleButton setTitleColor:[UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.navBarTextColor] forState:UIControlStateNormal];
}

- (void)communityInit
{
    self.titleLabel.text = self.selModel.comName;
//    [self.titleButton setTitle:self.selModel.comName forState:UIControlStateNormal];
    NSMutableArray *items = [NSMutableArray array];
    for (int i = 0; i < self.selModel.doorListAll.count; i ++)
    {
        ODDoorModel *doorModel = self.selModel.doorListAll[i];
        NSArray *nameAry = [doorModel.name componentsSeparatedByString:@"|"];
        NSString *name = [nameAry firstObject];
        if (!StringIsEmpty(doorModel.gName))
        {
            NSArray *gNameAry = [doorModel.gName componentsSeparatedByString:@"|"];
            name = _StrFormate(@"%@%@",name,gNameAry.firstObject);
        }
        OpenDoorMenuItem *item = [[OpenDoorMenuItem alloc] init];
        item.titleLabel.text = name;
        item.subTitleLabel.text = StringIsEmpty([nameAry lastObject]) ? @"门" : [nameAry lastObject];
        item.weakModel = doorModel;
        [items addObject:item];
    }

    self.menu.items = items;
    
    [self.menu animateWithFrameSize:CGSizeMake(DEF_SCREENWIDTH - 32, DEF_SCREENWIDTH * 0.5 + 10)];
}

- (void)locatonAuthReuqest
{
    BOOL enable = [CLLocationManager locationServicesEnabled];

    if (!enable)
    {
        ToastShowBottom(@"定位服务当前可能尚未打开，请设置打开！");
        return;
    }
    
    int status = [CLLocationManager authorizationStatus];
    
    //如果没有授权则请求用户授权
    if (status == kCLAuthorizationStatusNotDetermined)
    {
        [self.locService requestWhenInUseAuthorization];
    }
    else if(status == kCLAuthorizationStatusAuthorizedWhenInUse)
    {
    }
    else if (status == kCLAuthorizationStatusRestricted)
    {
        ToastShowBottom(@"定位功能不可用！");
        return;
    }
    else if (status == kCLAuthorizationStatusDenied)
    {
        ToastShowBottom(@"定位权限未开启，请前往隐私修改！");
        return;
    }
}

#pragma mark - public
- (void)showFromTabBarController
{
    self.locService.delegate = self;
    [self locatonAuthReuqest];
    self.frame = CGRectMake(0, 0, DEF_SCREENWIDTH, DEF_SCREENHEIGHT - 48);
    [MainAppDelegate.mainTabBarController.view insertSubview:self belowSubview:MainAppDelegate.mainTabBarController.tabBar];
    
    [self communityRequest];

}

#pragma mark - action
- (void)titleBtnAction
{
    [self.popupView presentWithAnchorPoint:CGPointMake(self.titleButton.centerX, self.titleButton.bottom)];
}

#pragma mark - request
- (void)communityRequest
{
    ODCommunityListRequest *request = [[ODCommunityListRequest alloc] init];
    request.cUserId = KAccountInfo.userId;
    BXHWeakObj(self);
    ProgressShow(self);
    [request requestWithSuccess:^(BXHBaseRequest *request) {
        ProgressHidden(selfWeak);
        if ([request.response.code integerValue] == 200)
        {
            selfWeak.communities = [ODCommunityModel bxhObjectArrayWithKeyValuesArray:request.response.data];
            if (selfWeak.communities.count > 0)
            {
                selfWeak.selModel = [selfWeak.communities firstObject];
            }

            [selfWeak communityInit];
        }
        else
        {
            ToastShowBottom(request.response.message);
        }
    } failure:^(NSError *error, BXHBaseRequest *request) {
        ProgressHidden(selfWeak);
        ToastShowBottom(NetWorkErrorTip);
    }];
}

- (void)doorOpenRequest:(ODDoorModel *)doorModel location:(CLLocation *)location
{
    self.openSuccLabel.hidden = YES;
    [self.openSuccLabel.layer removeAnimationForKey:@"animationGroup"];

    ODOpenDoorRequest *request = [[ODOpenDoorRequest alloc] init];
    request.cUserId = KAccountInfo.userId;
    request.doorId = [doorModel.did stringValue];
    request.locationX = _StrFormate(@"%f", location.coordinate.latitude);
    request.locationY = _StrFormate(@"%f", location.coordinate.longitude);
    BXHWeakObj(self);
    ProgressShow(self);
    [request requestWithSuccess:^(BXHBaseRequest *request) {
        ProgressHidden(selfWeak);
        selfWeak.updateLocation = nil;
        if ([request.response.code integerValue] == 200)
        {
            selfWeak.animateImageView.hidden = NO;
            [selfWeak.animateImageView startAnimating];
            selfWeak.openSuccLabel.hidden = NO;

            //透明度变化
            CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            opacityAnimation.fromValue = [NSNumber numberWithFloat:0.0];
            opacityAnimation.toValue = [NSNumber numberWithFloat:1.0];
            opacityAnimation.duration = 1.5f;

            //缩放动画
            CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            scaleAnimation.fromValue = [NSNumber numberWithFloat:0.0];
            scaleAnimation.toValue = [NSNumber numberWithFloat:1.0];
            scaleAnimation.duration = 2.0f;
            scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            
            CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
            animationGroup.duration = 2.0f;
            animationGroup.fillMode=kCAFillModeForwards;
            animationGroup.removedOnCompletion = NO;
            [animationGroup setAnimations:[NSArray arrayWithObjects:opacityAnimation, scaleAnimation, nil]];
            
            [selfWeak.openSuccLabel.layer addAnimation:animationGroup forKey:@"animationGroup"];
            
            [selfWeak performSelector:@selector(animateDone) withObject:nil afterDelay:1.4];
        }
        else
        {
            ProgressHidden(selfWeak);
            ToastShowBottom(request.response.message);
            selfWeak.updateLocation = nil;
        }
    } failure:^(NSError *error, BXHBaseRequest *request) {
        ProgressHidden(selfWeak);
        ToastShowBottom(NetWorkErrorTip);
        selfWeak.updateLocation = nil;
    }];
}

- (void)animateDone
{
    [self.animateImageView stopAnimating];
    self.animateImageView.hidden = YES;
}

#pragma mark - popViewDelegate
- (void)dropMenuDidTappedAtIndex:(NSInteger)index
{
    self.selModel = self.communities[index];
    [self communityInit];
}

#pragma mark - circleViewProtcol
- (void)circleMenu:(OpenDoorCircleMenu *)menu itemAction:(CircleMenuItem *)item
{
    self.openModel = [(OpenDoorMenuItem *)item weakModel];
    if([self.openModel.isOnline boolValue])
    {
        [self.locService startUpdatingLocation];
    }
    else
    {
        ToastShowBottom(@"对不起，当前门不在线");
    }
}

#pragma mark - locationDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    [self.locService stopUpdatingLocation];
    if (self.updateLocation)
    {
        return;
    }
    CLLocation *location = [locations lastObject];
    self.updateLocation = location;
    [self doorOpenRequest:self.openModel location:location];
}


#pragma mark - get
- (OpenDoorCircleMenu *)menu
{
    if (!_menu)
    {
        _menu = [[OpenDoorCircleMenu alloc] initWithWithItemSize:CGSizeMake(60, 60)];
        _menu.protcol = self;
    }
    return _menu;
}

- (UIButton *)titleButton
{
    if (!_titleButton)
    {
        _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_titleButton setImage:ImageWithName(@"OpenDoorDownArrow") forState:UIControlStateNormal];
        [_titleButton setImage:ImageWithName(@"OpenDoorUpArrow") forState:UIControlStateSelected];
        _titleButton.titleLabel.font = Font_sys_17;
        _titleButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        _titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, 110, 0, 0);
        [_titleButton addTarget:self action:@selector(titleBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _titleButton;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = Font_sys_17;
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (SUPopupMenu *)popupView
{
    NSMutableArray *strs = [NSMutableArray array];
    for (ODCommunityModel *listModel in self.communities)
    {
        [strs addObject:listModel.comName];
    }
    _popupView = [[SUPopupMenu alloc] initWithTitles:strs icons: nil menuItemSize:CGSizeMake(110, 30)];
    _popupView.delegate = self;
    return _popupView;
}

- (CLLocationManager *)locService
{
    if (!_locService)
    {
        _locService = [[CLLocationManager alloc]init];
        _locService.delegate = self;
        _locService.distanceFilter = 10.0f;
    }
    return _locService;
}

- (UIImageView *)animateImageView
{
    if (!_animateImageView)
    {
        NSMutableArray *images = [NSMutableArray array];
        for (int i = 0; i <9; i++)
        {
            NSString *path = PathForResource(_StrFormate(@"open_door_%d",i), @"png");
            [images addObject:[UIImage imageWithContentsOfFile:path]];
        }
        _animateImageView = [[UIImageView alloc] init];
        _animateImageView.animationImages = images;
        _animateImageView.hidden = YES;
        _animateImageView.animationDuration = 1.5;
    }
    return _animateImageView;
}

- (UILabel *)openSuccLabel
{
    if (!_openSuccLabel) {
        _openSuccLabel = [[UILabel alloc] init];
        _openSuccLabel.font = [UIFont boldSystemFontOfSize:30];
        _openSuccLabel.textColor = [UIColor whiteColor];
        _openSuccLabel.text = @"开门成功";
        _openSuccLabel.hidden = YES;
    }
    return _openSuccLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
