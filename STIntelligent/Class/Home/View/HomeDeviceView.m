//
//  HomeDeviceView.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/8.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "HomeDeviceView.h"

@implementation HomeDeviceView

- (instancetype)init
{
    if (self = [super init])
    {
    
        [self addSubview:self.backImageView];
        [self addSubview:self.maoYanBtn];
        [self addSubview:self.spOneBtn];
        [self addSubview:self.spTwoBtn];
        [self addSubview:self.spThreeBtn];
        [self addSubview:self.spFourBtn];
        
        [self.maoYanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(60, 80));
        }];
        
        CGFloat radius = (DEF_SCREENWIDTH - 32) / 2;
        CGPoint circleCenter = CGPointMake(radius, 0);
        CGFloat longLen = radius - 20;
        
        [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(-30);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(self.backImageView.mas_width).multipliedBy(409 / 634.0);
        }];
        
        CGPoint oneBtnCenter = [self endPointWithRadius:longLen startPoint:circleCenter angle:DEGREES_TO_RADIANS(150)];
        [self.spOneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self).offset(oneBtnCenter.x - circleCenter.x);
            make.centerY.mas_equalTo(self.mas_top).offset(fabs(oneBtnCenter.y));
            make.size.mas_equalTo(CGSizeMake(40, 60));
        }];
        
        CGPoint twoBtnCenter = [self endPointWithRadius:longLen startPoint:circleCenter angle:DEGREES_TO_RADIANS(115)];
        [self.spTwoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self).offset(twoBtnCenter.x - circleCenter.x);
            make.centerY.mas_equalTo(self.mas_top).offset(twoBtnCenter.y);            make.size.mas_equalTo(CGSizeMake(40, 60));
        }];

        CGPoint threeBtnCenter = [self endPointWithRadius:longLen startPoint:circleCenter angle:DEGREES_TO_RADIANS(65)];
        [self.spThreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self).offset(threeBtnCenter.x - circleCenter.x);
            make.centerY.mas_equalTo(self.mas_top).offset(threeBtnCenter.y);            make.size.mas_equalTo(CGSizeMake(40, 60));
        }];

        CGPoint fourBtnCenter = [self endPointWithRadius:longLen startPoint:circleCenter angle:DEGREES_TO_RADIANS(30)];
        [self.spFourBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self).offset(fourBtnCenter.x - circleCenter.x);
            make.centerY.mas_equalTo(self.mas_top).offset(fourBtnCenter.y);
            make.size.mas_equalTo(CGSizeMake(40, 60));
        }];

        [[STThemeManager shareInstance] addThemeChangeProtcol:self];
        
    }
    return self;
}

- (void)setPageModel:(DeveicePageModel *)pageModel
{
    _pageModel = pageModel;
    self.spOneBtn.cameraModel = self.pageModel.cameraOne;
    self.spTwoBtn.cameraModel = self.pageModel.cameraTwo;
    self.spThreeBtn.cameraModel = self.pageModel.cameraThree;
    self.spFourBtn.cameraModel = self.pageModel.cameraFour;
    [self themeChange];
    [self reloadName];
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

- (void)themeChange
{
    self.maoYanBtn.titleLabel.textColor = [UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.homeTextColor1];
    self.spOneBtn.titleLabel.textColor = [UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.homeTextColor1];
    self.spTwoBtn.titleLabel.textColor = [UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.homeTextColor1];
    self.spThreeBtn.titleLabel.textColor = [UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.homeTextColor1];
    self.spFourBtn.titleLabel.textColor = [UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.homeTextColor1];
    
    self.maoYanBtn.imageView.image =  [self imageWithModel:_pageModel.maoYanModel andLabel:self.maoYanBtn.titleLabel];
    self.spOneBtn.imageView.image = [self imageWithModel:_pageModel.cameraOne andLabel:self.spOneBtn.titleLabel];
    self.spTwoBtn.imageView.image = [self imageWithModel:_pageModel.cameraTwo andLabel:self.spTwoBtn.titleLabel];
    self.spThreeBtn.imageView.image = [self imageWithModel:_pageModel.cameraThree andLabel:self.spThreeBtn.titleLabel];
    self.spFourBtn.imageView.image = [self imageWithModel:_pageModel.cameraFour andLabel:self.spFourBtn.titleLabel];
    self.backImageView.image = ThemeImageWithName(@"HomeCircleImage");
}

- (UIImage *)imageWithModel:(id)model andLabel:(UILabel *)label
{
    if ([model isKindOfClass:[MaoYanModel class]])
    {
        MaoYanModel *mYModel = model;
        if (StringIsEmpty(mYModel.bid))
        {
            label.alpha = 0.7;
            return ThemeImageWithName(@"HomeMaoYanUnAdd");
        }
        else
        {
            label.alpha = 1;
            UIImage *img = StringIsEmpty(mYModel.Icon) ?  ThemeImageWithName(@"HomeMaoYan") : ImageWithName(mYModel.Icon);
            if (img == nil) {
                img = ThemeImageWithName(@"HomeMaoYan");
            }
            
            return img;
        }
    }
    else
    {
        SheXiangTouModel *sxtModel = model;
        if (StringIsEmpty(sxtModel.deviceSerialNo))
        {
            label.alpha = 0.7;
            return ThemeImageWithName(@"HomeCameraUnAdd");
        }
        else
        {
            label.alpha = 1;
             UIImage *img = StringIsEmpty(sxtModel.Icon) ? ThemeImageWithName(@"HomeCamera") : ImageWithName(sxtModel.Icon);
            if (img == nil) {
                img = ThemeImageWithName(@"HomeCamera");
            }
            
            return img;
        }
    }
}

- (void)reloadName
{
    self.maoYanBtn.titleLabel.text = StringIsEmpty(self.pageModel.maoYanModel.Name)? @"猫眼" : self.pageModel.maoYanModel.Name;

    self.spOneBtn.titleLabel.text = StringIsEmpty(self.pageModel.cameraOne.Name)? @"摄像头" : self.pageModel.cameraOne.Name;
    

    self.spTwoBtn.titleLabel.text = StringIsEmpty(self.pageModel.cameraTwo.Name)? @"摄像头" : self.pageModel.cameraTwo.Name;
    

    self.spThreeBtn.titleLabel.text = StringIsEmpty(self.pageModel.cameraThree.Name)? @"摄像头" : self.pageModel.cameraThree.Name;
    
    self.spFourBtn.titleLabel.text = StringIsEmpty(self.pageModel.cameraFour.Name)? @"摄像头" : self.pageModel.cameraFour.Name;

}


#pragma mark - get
- (UIImageView *)backImageView
{
    if (!_backImageView)
    {
        _backImageView = [[UIImageView alloc] init];
    }
    return _backImageView;
}

- (STControl *)maoYanBtn
{
    if (!_maoYanBtn)
    {
        _maoYanBtn = [[STControl alloc] init];
        _maoYanBtn.titleLabel.font = Font_sys_17;
    }
    return _maoYanBtn;
}

- (STControl *)spOneBtn
{
    if (!_spOneBtn)
    {
        _spOneBtn = [[STControl alloc] init];
        _spOneBtn.titleLabel.font = Font_sys_12;
    }
    return _spOneBtn;
}

- (STControl *)spTwoBtn
{
    if (!_spTwoBtn)
    {
        _spTwoBtn = [[STControl alloc] init];
        _spTwoBtn.titleLabel.font = Font_sys_12;

    }
    return _spTwoBtn;
}

- (STControl *)spThreeBtn
{
    if (!_spThreeBtn)
    {
        _spThreeBtn = [[STControl alloc] init];
        _spThreeBtn.titleLabel.font = Font_sys_12;
    }
    return _spThreeBtn;
}

- (STControl *)spFourBtn
{
    if (!_spFourBtn)
    {
        _spFourBtn = [[STControl alloc] init];
        _spFourBtn.titleLabel.font = Font_sys_12;
    }
    return _spFourBtn;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
