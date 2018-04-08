//
//  BXHLaunchViewController.m
//  GuoGangTong
//
//  Created by 步晓虎 on 2016/12/21.
//  Copyright © 2016年 woshishui. All rights reserved.
//

#import "BXHLaunchViewController.h"
#import "STTokenGetRequest.h"

#define MaxErrorCount 8

#define FirstOpenKey @"FirstOpenKey"

@interface BXHLaunchViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *launchImageView;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) UIWindow *ownWindow;

@property (nonatomic, assign) NSInteger errorCount;

@property (nonatomic, strong) UIScrollView *guidScrollView;

@property (nonatomic, assign) BOOL firstOpen;

@end

@implementation BXHLaunchViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.errorCount = 0;
    
    [self.view addSubview:self.launchImageView];
    
    [self.launchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsZero);
    }];
    
    [self.view addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-80);
    }];
    
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    __weak typeof(self) weakSelf = self;
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status <= 0)
        {
            weakSelf.tipLabel.hidden = NO;
        }
        else
        {
            BXHStrongObj(weakSelf);
            [weakSelfStrong tokenGet];
            if (weakSelf.firstOpen)
            {
                [weakSelfStrong loadScrollView];
            }
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

#pragma mark - request
- (void)tokenGet
{
    STTokenGetRequest *request = [[STTokenGetRequest alloc] init];
    request.staffId = @"100";
    ProgressShow(self.view);
    BXHWeakObj(self);
    [request requestWithSuccess:^(BXHBaseRequest *request) {
        ProgressHidden(selfWeak.view);
        if ([request.response.code integerValue] == 200)
        {
            [[NSUserDefaults standardUserDefaults] setObject:request.response.data[@"SignToken"] forKey:LocalTokenCacheKey];
            if (!selfWeak.firstOpen)
            {
                [selfWeak performSelector:@selector(cancelViewController) withObject:nil afterDelay:1.0];
            }
        }
        else
        {
            selfWeak.errorCount++;
            if(selfWeak.errorCount <= MaxErrorCount)
            {
                BXHStrongObj(selfWeak);
                [selfWeakStrong tokenGet];
            }
            else
            {
                //处理
            }
        }
        
    } failure:^(NSError *error, BXHBaseRequest *request) {
        ProgressHidden(selfWeak.view);
        ToastShowBottom(NetWorkErrorTip);
    }];
}

#pragma mark - private
- (void)hiddenSelf:(UITapGestureRecognizer *)tap
{
    CGPoint location = [tap locationInView:tap.view];
    BXHLog(@"location %f======%f",location.x,location.y);
    if ((location.y > (DEF_SCREENHEIGHT * 0.71)) && (location.y < (DEF_SCREENHEIGHT - DEF_SCREENHEIGHT * 0.17)))
    {
        [[NSUserDefaults standardUserDefaults] setObject:@NO forKey:FirstOpenKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self cancelViewController];
    }
}

- (void)dismissViewController:(void (^ __nullable)(BOOL finished))completion
{
    [UIView animateWithDuration:0.5 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1.2, 1.2);
        self.view.alpha = 0;
    } completion:completion];
}

- (void)show
{
    [self.ownWindow makeKeyAndVisible];
}

- (void)cancelViewController
{
    [self.delegate bxhLaunchViewControllerWillDismiss:self];
    [self dismissViewController:^(BOOL finished) {
        
        if (finished)
        {
            [self.delegate bxhLaunchViewControllerDidDismiss:self];
        }
        self.ownWindow.hidden = YES;
        self.ownWindow = nil;
    }];
}

- (void)loadScrollView
{
    [self.view addSubview:self.guidScrollView];
    [self.view sendSubviewToBack:self.launchImageView];
    [self.guidScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.launchImageView.hidden = YES;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - get

- (UIImageView *)launchImageView
{
    if (!_launchImageView)
    {
        _launchImageView = [[UIImageView alloc] init];

    
        NSURL *imageUrl = [[NSUserDefaults standardUserDefaults] URLForKey:ImageStartLoadUrl];
        if (NO)
        {
//            [_launchImageView sd_setImageWithURL:imageUrl];
        }
        else
        {
            NSString *suffix = nil;
            
            if (DEF_SCREENHEIGHT == 480)
            { //4，4S
                suffix = @"LaunchImage-700";
            }
            else if (DEF_SCREENHEIGHT == 568)
            { //5, 5C, 5S, iPod
                suffix = @"LaunchImage-700-568h";
            }
            else if (DEF_SCREENHEIGHT == 667)
            { //6, 6S
                suffix = @"LaunchImage-800-667h";
            }
            else if (DEF_SCREENHEIGHT == 736)
            { // 6Plus, 6SPlus
                suffix = @"LaunchImage-800-Landscape-736h";
            }
            
            
            if (suffix.length > 0)
            {
                _launchImageView.image = ImageWithName(suffix);
            }
        }
    }
    return _launchImageView;
}

- (UILabel *)tipLabel
{
    if (!_tipLabel)
    {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = Font_sys_14;
        _tipLabel.textColor =  Color_MainText;
        _tipLabel.text = @"网络无法连接";
        _tipLabel.hidden = YES;
    }
    return _tipLabel;
}

- (UIWindow *)ownWindow
{
    if (!_ownWindow)
    {
        _ownWindow = [[UIWindow alloc] initWithFrame:DEF_SCREENBOUNDS];
        _ownWindow.windowLevel = UIWindowLevelStatusBar - 1;
        _ownWindow.hidden = YES;
        _ownWindow.rootViewController = self;
    }
    return _ownWindow;
}

- (UIScrollView *)guidScrollView
{
    if (!_guidScrollView)
    {
        _guidScrollView = [[UIScrollView alloc] init];
        _guidScrollView.pagingEnabled = YES;
        for (int i = 0; i < 3; i ++)
        {
            NSString *guidImage = @"GuidImage";
            if (DEF_SCREENHEIGHT == 480)
            { //4，4S
                guidImage = [NSString stringWithFormat:@"%@%d-%@",guidImage,i + 1,@"640*960"];
            }
            else if (DEF_SCREENHEIGHT == 568)
            { //5, 5C, 5S, iPod
                guidImage = [NSString stringWithFormat:@"%@%d-%@",guidImage,i + 1,@"640*1136"];
            }
            else if (DEF_SCREENHEIGHT == 667)
            { //6, 6S
                guidImage = [NSString stringWithFormat:@"%@%d-%@",guidImage,i + 1,@"750*1334"];
            }
            else if (DEF_SCREENHEIGHT == 736)
            { // 6Plus, 6SPlus
                guidImage = [NSString stringWithFormat:@"%@%d-%@",guidImage,i + 1,@"1242*2208"];
            }
            
            UIImageView *imageView = [[UIImageView alloc] initWithImage:ImageWithName(guidImage)];
            imageView.frame = CGRectMake(i * DEF_SCREENWIDTH, 0, DEF_SCREENWIDTH, DEF_SCREENHEIGHT);
            if (i == 2)
            {
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenSelf:)];
                imageView.userInteractionEnabled = YES;
                [imageView addGestureRecognizer:tap];
            }
            [_guidScrollView addSubview:imageView];
        }
        _guidScrollView.delegate = self;
        _guidScrollView.contentSize = CGSizeMake(DEF_SCREENWIDTH * 3, DEF_SCREENHEIGHT);
    }
    return _guidScrollView;
}

- (BOOL)firstOpen
{
    id object = [[NSUserDefaults standardUserDefaults] objectForKey:FirstOpenKey];
    if (object)
    {
        return [object boolValue];
    }
    return YES;
}

#pragma mark - rotate

- (BOOL)shouldAutorotate//是否支持旋转屏幕
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
