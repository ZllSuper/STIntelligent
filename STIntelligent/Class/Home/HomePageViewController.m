//
//  HomePageViewController.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/8.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "HomePageViewController.h"

#import "HomePageControlView.h"
#import "HomePageView.h"
#import "CameraAddHelper.h"

#import "HomeTextFieldAlert.h"
#import "BXHSTAlertViewController.h"
#import "AddMaoYanPrepareViewController.h"
#import "SweepCodeViewController.h"
#import "DeviceVideoViewController.h"
#import "CameraDeviceVedioViewController.h"

#import "HomeSceneListRequest.h"
#import "HomeSceneEditNameRequest.h"
#import "HomeSceneAddRequest.h"
#import "STYSTokenGetRequest.h"

#import <EquesBusiness/YKBusinessFramework.h>
#import "EZOpenSDKHeader.h"

#import "HomeDelPageManager.h"

#import "SUPopupMenu.h"


@interface HomePageViewController () <STThemeManagerProtcol,BXHSTAlertViewControllerProtcol,EquesBusinessHelperProtcol,HomePageControlViewProtcol, HomePageViewDelegate, SUDropMenuDelegate>

@property (nonatomic, strong) UIButton *titleBtn;

@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic) NSInteger index;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSMutableArray *devicePage;

@property (nonatomic, strong) HomePageControlView *controlView;

@property (nonatomic, assign) BOOL addPage;

@property (nonatomic, weak) MaoYanModel *actionMaoYanModel;

@property (nonatomic, strong) SUPopupMenu *popupView;

@property (nonatomic, strong) NSMutableArray *sceneNameAry;

@end

@implementation HomePageViewController

- (instancetype) init
{
    if (self = [super init])
    {
        self.index = 0;
        
        self.devicePage = [NSMutableArray array];
        ADD_NOTIFICATIOM(@selector(sceneListRequest), kRefreshHomePageNotification, nil);
    }
    return self;
}

- (void)dealloc
{
    REMOVE_NOTIFICATION(kRefreshHomePageNotification, nil);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.titleView = self.titleBtn;
    self.view.backgroundColor = [UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.navBarBackColor];
    self.rightBtn = [self creatRightNavigationItemWithImage:ThemeImageWithName(@"HomeRightAdd") target:self action:@selector(rightBtnAction)];
    
    [self.view addSubview:self.controlView];
    [self.controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.height.mas_equalTo(DEF_SCREENHEIGHT - 64 - 49);
    }];

    [self.view addSubview:self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.view);
        make.height.mas_equalTo(@30);
        make.bottom.mas_equalTo(self.view).offset(-20);
    }];

    [[STThemeManager shareInstance] addThemeChangeProtcol:self];
    [[EquesBusinessHelper shareInstance] addProtcol:self forMethod:MAOYAN_DEVICELIST_METHOD];
    [[EquesBusinessHelper shareInstance] addProtcol:self forMethod:MAOYAN_LOGIN_METHOD];

    [self sceneListRequest];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
  
    HomePageView *pageView = (HomePageView *)[self.controlView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.controlView.currentItem inSection:0]];
    [pageView reload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - request
- (void)sceneListRequest
{
    HomeSceneListRequest *request = [[HomeSceneListRequest alloc] init];
    request.communityUserId = KAccountInfo.userId;
    BXHWeakObj(self);
    ProgressShow(self.view);
    [request requestWithSuccess:^(BXHBaseRequest *request) {
        if ([request.response.code integerValue] == 200)
        {
            if(StringIsEmpty([EquesBusinessHelper shareInstance].token))
            {
                [[EquesBusinessHelper shareInstance] equesLogin];
            }
            else
            {
                ProgressHidden(selfWeak.view);
            }
            
            [selfWeak.devicePage removeAllObjects];
            [selfWeak.devicePage addObjectsFromArray:[DeveicePageModel bxhObjectArrayWithKeyValuesArray:request.response.data]];
            
            [selfWeak creatHomeViewController];
            selfWeak.index = 0;
            [selfWeak.controlView reloadData];
        }
        else
        {
            ToastShowBottom(request.response.message);
        }
    } failure:^(NSError *error, BXHBaseRequest *request) {
        ProgressHidden(selfWeak.view);
        ToastShowBottom(NetWorkErrorTip);
    }];
}

- (void)sceneEditNameRequestWithName:(NSString *)name  completionBlock:(void(^)(BOOL success))completionBlock
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [name dataUsingEncoding:enc];
    int txtLen = (int)[da length];
    
    if (txtLen > 20) {
        ToastShowCenter(@"请输入10位汉字或者20位字母以内的场景名称");
        if (completionBlock) {
            completionBlock (NO);
        }
        return;
    }
    
    if([self.sceneNameAry containsObject:name])
    {
        ToastShowCenter(@"场景名称已存在");
        if (completionBlock) {
            completionBlock (NO);
        }
        return;
    }
    
    DeveicePageModel *model = self.devicePage[self.index];
    HomeSceneEditNameRequest *request = [[HomeSceneEditNameRequest alloc] init];
    request.sceneId = model.pageId;
    request.name = name;
    BXHWeakObj(self);
    BXHBlockObj(name);
    BXHBlockObj(model);
    ProgressShow(self.view);
    [request requestWithSuccess:^(BXHBaseRequest *request) {
        ProgressHidden(selfWeak.view);
        if ([request.response.code integerValue] == 200)
        {
            modelblock.Name = nameblock;
            [selfWeak.titleBtn setTitle:model.Name forState:UIControlStateNormal];
            
            if (completionBlock) {
                completionBlock (YES);
            }
        }
        else
        {
            ToastShowCenter(request.response.message);
            if (completionBlock) {
                completionBlock (NO);
            }
        }
    } failure:^(NSError *error, BXHBaseRequest *request) {
        ProgressHidden(selfWeak.view);
        ToastShowCenter(NetWorkErrorTip);
        if (completionBlock) {
            completionBlock (NO);
        }
    }];
}

- (void)sceneAddRequestWithName:(NSString *)name completionBlock:(void(^)(BOOL success))completionBlock
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [name dataUsingEncoding:enc];
    int txtLen = (int)[da length];

    if (txtLen > 20) {
        ToastShowCenter(@"请输入10位汉字或者20位字母以内的场景名称");
        if (completionBlock) {
            completionBlock (NO);
        }
        return;
    }
    
    if([self.sceneNameAry containsObject:name])
    {
        ToastShowCenter(@"场景名称已存在");
        if (completionBlock) {
            completionBlock (NO);
        }
        return;
    }
    
    HomeSceneAddRequest *request = [[HomeSceneAddRequest alloc] init];
    request.communityUserId = KAccountInfo.userId;
    request.sceneName = name;
    BXHWeakObj(self);
    ProgressShow(self.view);
    [request requestWithSuccess:^(BXHBaseRequest *request) {
        ProgressHidden(selfWeak.view);
        if ([request.response.code integerValue] == 200)
        {
            [selfWeak.devicePage removeAllObjects];
            [selfWeak.devicePage addObjectsFromArray:[DeveicePageModel bxhObjectArrayWithKeyValuesArray:request.response.data]];
            [selfWeak.controlView reloadData];
            NSInteger item = selfWeak.devicePage.count - selfWeak.index + selfWeak.controlView.currentItem - 1;
            [selfWeak.controlView setContentOffset:CGPointMake(item * selfWeak.controlView.width, 0) animated:YES];
            selfWeak.pageControl.numberOfPages = selfWeak.devicePage.count;
            selfWeak.index = selfWeak.devicePage.count - 1;
            
            if (selfWeak.devicePage.count < 2) {
                selfWeak.controlView.scrollEnabled = NO;
            }
            else {
                selfWeak.controlView.scrollEnabled = YES;
            }
            
            if (completionBlock) {
                completionBlock (YES);
            }
        }
        else
        {
            ToastShowCenter(request.response.message);
            if (completionBlock) {
                completionBlock (NO);
            }
        }
    } failure:^(NSError *error, BXHBaseRequest *request) {
        ProgressHidden(selfWeak.view);
        ToastShowCenter(NetWorkErrorTip);
        if (completionBlock) {
            completionBlock (NO);
        }
    }];

}

- (void)cameraAccessTokenGet:(SheXiangTouModel *)cameraModel pageModel:(DeveicePageModel *)pageModel
{
    STYSTokenGetRequest *request = [[STYSTokenGetRequest alloc] init];
    request.communityUserId = KAccountInfo.userId;
    __block SheXiangTouModel *blockModel = cameraModel;
    __block DeveicePageModel *blockPageModel = pageModel;
    BXHWeakObj(self);
    ProgressShow(self.view);
    [request requestWithSuccess:^(BXHBaseRequest *request) {
        ProgressHidden(selfWeak.view);
        if ([request.response.code integerValue] == 200)
        {
            KAccountInfo.cameraAccessToken = request.response.data[@"Token"];
            [selfWeak cameraDealWithModel:blockModel andPageModel:blockPageModel];
            [KAccountInfo saveToDisk];
        }
        else
        {
            ToastShowBottom(request.response.message);
        }
    } failure:^(NSError *error, BXHBaseRequest *request) {
        ProgressHidden(selfWeak.view);
        ToastShowBottom(NetWorkErrorTip);
    }];
}


#pragma mark - private
- (NSInteger)cameraIndex:(DeveicePageModel *)pageModel cameraModel:(SheXiangTouModel *)cameraModel
{
    if ([pageModel.cameraOne isEqual:cameraModel])
    {
         return 2;
    }
    else if ([pageModel.cameraTwo isEqual:cameraModel])
    {
        return 3;
    }
    else if ([pageModel.cameraThree isEqual:cameraModel])
    {
        return 4;
    }
    else if ([pageModel.cameraFour isEqual:cameraModel])
    {
        return 5;
    }
    return 0;
}

- (void)creatHomeViewController
{
    [self.controlView setContentOffset:CGPointMake(5000 * DEF_SCREENWIDTH, 0) animated:YES];
    self.controlView.sourceAry = self.devicePage;
    self.pageControl.numberOfPages = self.devicePage.count;
    self.pageControl.currentPage = 0;
    
    if (self.devicePage.count < 2) {
        self.controlView.scrollEnabled = NO;
    }
    else {
        self.controlView.scrollEnabled = YES;
    }
}


- (void)cameraDealWithModel:(SheXiangTouModel *)cameraModel andPageModel:(DeveicePageModel *)pageModel
{
    if (!StringIsEmpty(cameraModel.deviceSerialNo))
    {
        pageModel.defaultIndex = (int)[self cameraIndex:pageModel cameraModel:cameraModel];
        [EZOpenSDK setAccessToken:KAccountInfo.cameraAccessToken];
        CameraDeviceVedioViewController *vc = [[CameraDeviceVedioViewController alloc] init];
        vc.cameraModel = cameraModel;
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:[[BaseNaviController alloc] initWithRootViewController:vc] animated:YES completion:nil];
    }
    else
    {
        if(KAccountInfo.cameraAccessToken)
        {
            __block SheXiangTouModel *blockCameraModel = cameraModel;
            [EZOpenSDK setAccessToken:KAccountInfo.cameraAccessToken];
            [[CameraAddHelper shareInstance] startAddWithPageModel:pageModel andCameraModel:cameraModel successCallBack:^(SheXiangTouModel *cameraModel) {
                blockCameraModel.deviceSerialNo = cameraModel.deviceSerialNo;
                blockCameraModel.deviceModel = cameraModel.deviceModel;
                blockCameraModel.deviceVerifyCode = cameraModel.deviceVerifyCode;
                blockCameraModel.deviceVerifyCodeBySerial = cameraModel.deviceVerifyCodeBySerial;
            }];
            SweepCodeViewController *vc = [[SweepCodeViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            [EZOpenSDK openLoginPage:^(EZAccessToken *accessToken) {
                KAccountInfo.cameraAccessToken = accessToken.accessToken;
                [EZOpenSDK setAccessToken:accessToken.accessToken];
                [KAccountInfo saveToDisk];
            }];
        }
    }
}

- (void)pageAddAction
{
    if (self.devicePage.count >= 10)
    {
        ToastShowBottom(@"场景最多添加为10个");
        return;
    }
    
    NSString *placeholderName = @"我的场景";
    for (int i = 1; i < 10; i++)
    {
        if([self.sceneNameAry containsObject:placeholderName])
        {
            placeholderName = _StrFormate(@"%@%d",@"我的场景",i);
        }
        else
        {
            break;
        }
    }
    
    self.addPage = YES;
    HomeTextFieldAlert *content = [HomeTextFieldAlert viewFromXIB];
    content.inputTextFiled.text = placeholderName;
    content.titleLabel.text = @"新建场景";
    BXHSTAlertViewController *vc = [BXHSTAlertViewController alertControllerWithContentView:content andSize:CGSizeMake(DEF_SCREENWIDTH - 40, 180)];
    [content.sureBtn addTarget:vc action:@selector(actionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    vc.protcol = self;
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

#pragma mark - action
- (void)rightBtnAction
{
    [self.popupView presentWithAnchorPoint:CGPointMake(DEF_SCREENWIDTH - 30, 60)];
}

- (void)titleBtnAction
{
    self.addPage = NO;
    DeveicePageModel *model = self.devicePage[self.index];
    HomeTextFieldAlert *content = [HomeTextFieldAlert viewFromXIB];
    content.inputTextFiled.text = model.Name;
    BXHSTAlertViewController *vc = [BXHSTAlertViewController alertControllerWithContentView:content andSize:CGSizeMake(DEF_SCREENWIDTH - 40, 180)];
    [content.sureBtn addTarget:vc action:@selector(actionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    vc.protcol = self;
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

- (void)deletePageRequestAction:(DeveicePageModel *)pageModel;
{
    ProgressShow(self.view);
    BXHWeakObj(self);
    [[HomeDelPageManager shareInstance] delPageStartWithPageModel:pageModel successCallBack:^{
        ProgressHidden(selfWeak.view);
        [selfWeak.devicePage removeObject:pageModel];
        [selfWeak.controlView reloadData];
        selfWeak.pageControl.numberOfPages = selfWeak.devicePage.count;
        selfWeak.index = selfWeak.pageControl.currentPage;
        
        if (selfWeak.devicePage.count < 2) {
            selfWeak.controlView.scrollEnabled = NO;
        }
        else {
            selfWeak.controlView.scrollEnabled = YES;
        }
    }];
}

#pragma mark - protcol
- (void)equesBusinessHelper:(EquesBusinessHelper *)helper messageDict:(NSDictionary *)messageDict
{
    ProgressHidden(self.view);
    
    NSString *method = messageDict[@"method"];
    if ([method isEqualToString:MAOYAN_DEVICELIST_METHOD])
    {
        NSArray *onlines = messageDict[@"onlines"];
        
        for (NSDictionary *source in onlines)
        {
            if ([source[@"bid"] isEqualToString:self.actionMaoYanModel.bid])
            {
                self.actionMaoYanModel.uid = source[@"uid"];
                break;
            }
        }
        
        if (!StringIsEmpty(self.actionMaoYanModel.uid))
        {
            DeveicePageModel *pageModel = self.devicePage[self.index];
            pageModel.defaultIndex = 1;
            DeviceVideoViewController *vc = [[DeviceVideoViewController alloc] initWithMaoYanModel:self.actionMaoYanModel];
            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:[[BaseNaviController alloc] initWithRootViewController:vc] animated:YES completion:nil];
        }
        else
        {
            ToastShowBottom(@"设备不在线");
        }
    }
}


#pragma mark - AlertProtcol
- (void)bxhAlertViewController:(BXHSTAlertViewController *)vc clickIndex:(NSInteger)index
{
    if (self.addPage)
    {
        [self sceneAddRequestWithName:[(HomeTextFieldAlert *)vc.contentView inputTextFiled].text completionBlock:^(BOOL success) {
            if (success) {
                [vc dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }
    else
    {
        [self sceneEditNameRequestWithName:[(HomeTextFieldAlert *)vc.contentView inputTextFiled].text completionBlock:^(BOOL success) {
            if (success) {
                [vc dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }
    
}

#pragma mark - popViewDelegate
- (void)dropMenuDidTappedAtIndex:(NSInteger)index
{
    if (index == 0)
    {
        [self pageAddAction];
    }
    else if (index == 1)
    {
        [self titleBtnAction];
    }
    else
    {
        __weak typeof(self) weakSelf = self;
        __block DeveicePageModel *blockPageModel = self.devicePage[self.index];
        
        NSString *result = @"该场景中包含有设备，确定是否删除？";
        if (StringIsEmpty(blockPageModel.maoYanModel.bid))
        {
            if (StringIsEmpty(blockPageModel.cameraOne.deviceSerialNo))
            {
                if (StringIsEmpty(blockPageModel.cameraTwo.deviceSerialNo))
                {
                    if (StringIsEmpty(blockPageModel.cameraThree.deviceSerialNo))
                    {
                        if (StringIsEmpty(blockPageModel.cameraFour.deviceSerialNo))
                        {
                            result = @"确认删除场景吗？";
                        }

                    }

                }

            }
 
        }
        

        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"删除设备" message:result preferredStyle:UIAlertControllerStyleAlert];
        
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        
        [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf deletePageRequestAction:blockPageModel];
        }]];
        [self presentViewController:alertVC animated:YES completion:nil];

    }
}

#pragma mark - themeProtcol
- (void)themeChange
{
    [self.rightBtn setImage:ThemeImageWithName(@"HomeRightAdd") forState:UIControlStateNormal];
    [self.titleBtn setTitleColor:[UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.navBarTextColor] forState:UIControlStateNormal];
    self.view.backgroundColor = [UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.navBarBackColor];
}

- (void)pageView:(HomePageView *)pageView cameraAction:(SheXiangTouModel *)cameraModel
{
    if (StringIsEmpty(KAccountInfo.cameraAccessToken))
    {
        [self cameraAccessTokenGet:cameraModel pageModel:pageView.pageModel];
    }
    else
    {
        [self cameraDealWithModel:cameraModel andPageModel:pageView.pageModel];
    }
}

- (void)pageView:(HomePageView *)pageView maoYanAction:(MaoYanModel *)maoYanModel
{
    if (StringIsEmpty(pageView.pageModel.maoYanModel.bid))
    {
        __block DeveicePageModel *blockModel = pageView.pageModel;
        [[EquesBusinessHelper shareInstance] startAddWithPageModel:pageView.pageModel maoYanModel:maoYanModel successCallBack:^(DeveicePageModel *pageModel, MaoYanModel *maoYanModel) {
            blockModel.maoYanModel.bid = maoYanModel.bid;
            blockModel.maoYanModel.reqid = maoYanModel.reqid;
            blockModel.maoYanModel.uid = maoYanModel.uid;
            
        }];
        AddMaoYanPrepareViewController *vc = [[AddMaoYanPrepareViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        ProgressShowCanCancel(self.view);
        self.actionMaoYanModel = maoYanModel;
        [YKBusinessFramework equesGetDeviceList];
    }
}

- (void)pageViewTopDefaultAction:(HomePageView *)pageView
{
    switch (pageView.pageModel.defaultIndex)
    {
        case 1:
        {
            [self pageView:pageView maoYanAction:pageView.pageModel.maoYanModel];
        }
            break;
        case 2:
        {
            [self pageView:pageView cameraAction:pageView.pageModel.cameraOne];
        }
            break;
        case 3:
        {
            [self pageView:pageView cameraAction:pageView.pageModel.cameraTwo];
        }
            break;
        case 4:
        {
            [self pageView:pageView cameraAction:pageView.pageModel.cameraThree];
        }
            break;
        case 5:
        {
            [self pageView:pageView cameraAction:pageView.pageModel.cameraFour];
        }
            break;
   
        default:
        {
            if (!StringIsEmpty(pageView.pageModel.maoYanModel.bid))
            {
                pageView.pageModel.defaultIndex = 1;
                [self pageViewTopDefaultAction:pageView];
            }
            else if (!StringIsEmpty(pageView.pageModel.cameraOne.deviceSerialNo))
            {
                pageView.pageModel.defaultIndex = 2;
                [self pageViewTopDefaultAction:pageView];
            }
            else if (!StringIsEmpty(pageView.pageModel.cameraTwo.deviceSerialNo))
            {
                pageView.pageModel.defaultIndex = 3;
                [self pageViewTopDefaultAction:pageView];
            }
            else if (!StringIsEmpty(pageView.pageModel.cameraThree.deviceSerialNo))
            {
                pageView.pageModel.defaultIndex = 4;
                [self pageViewTopDefaultAction:pageView];
            }
            else if (!StringIsEmpty(pageView.pageModel.cameraFour.deviceSerialNo))
            {
                pageView.pageModel.defaultIndex = 5;
                [self pageViewTopDefaultAction:pageView];

            }
            else
            {
                pageView.pageModel.defaultIndex = 1;
                [self pageViewTopDefaultAction:pageView];
            }

            
            
//            if (pageView.imageBtn.isPlay)
//            {
//                [pageView.imageBtn stopPlay];
//            }
//            else
//            {
//                [pageView.imageBtn circlePlay];
//            }
        }
            break;
    }
    
}

//UIScrollViewDelegate方法
- (void)pageControlView:(HomePageControlView *)controlView scrollAtIndex:(NSInteger)index
{
    self.index = index;
}


#pragma mark - get
- (SUPopupMenu *)popupView
{
    _popupView = [[SUPopupMenu alloc] initWithTitles:@[@"新建场景",@"编辑当前场景",@"删除当前场景"] icons: nil menuItemSize:CGSizeMake(110, 40)];
    _popupView.delegate = self;
    return _popupView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl)
    {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.layer.zPosition = 1;
        _pageControl.userInteractionEnabled = NO;
    }
    return _pageControl;
}

- (UIButton *)titleBtn
{
    if (!_titleBtn)
    {
        _titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleBtn.frame = CGRectMake(0, 0, 150, 40);
        _titleBtn.titleLabel.font = Font_sys_17;
        [_titleBtn setTitleColor:[UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.navBarTextColor] forState:UIControlStateNormal];
//        [_titleBtn addTarget:self action:@selector(titleBtnAction) forControlEvents:UIControlEventTouchUpInside];

    }
    return _titleBtn;
}

- (HomePageControlView *)controlView
{
    if (!_controlView)
    {
        _controlView = [[HomePageControlView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREENWIDTH, DEF_SCREENHEIGHT - 64 - 49)];
        _controlView.protcol = self;
    }
    return _controlView;
}

#pragma mark - set
- (void)setIndex:(NSInteger)index
{
    _index = index;
    if (!self.devicePage.count)
    {
        [self.titleBtn setTitle:@"没有场景" forState:UIControlStateNormal];
        self.pageControl.currentPage = self.index;
        return;
    }
    DeveicePageModel *model = self.devicePage[index];
    if (StringIsEmpty(model.Name))
    {
        [self.titleBtn setTitle:@"我的设备" forState:UIControlStateNormal];
    }
    else
    {
        [self.titleBtn setTitle:model.Name forState:UIControlStateNormal];
    }
    self.pageControl.currentPage = self.index;
}

- (NSMutableArray *)sceneNameAry
{
    _sceneNameAry = [NSMutableArray arrayWithCapacity:self.devicePage.count];
    for (DeveicePageModel *pageModel in self.devicePage)
    {
        [_sceneNameAry addObject:pageModel.Name];
    }
    return _sceneNameAry;
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
