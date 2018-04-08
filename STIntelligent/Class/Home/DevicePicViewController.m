//
//  DevicePicViewController.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/19.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "DevicePicViewController.h"

#import "DeviceSettingPicCell.h"
#import "DevicePicListModel.h"

#import "HomeUpdateIconRequest.h"

@interface DevicePicViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIButton *bottomBtn;

@property (nonatomic, strong) NSArray *sourceAry;

@property (nonatomic, weak) MaoYanModel *maoYanModel;

@property (nonatomic, weak) SheXiangTouModel *cameraModel;

@end

@implementation DevicePicViewController

- (instancetype)initWithDeviceType:(DevicePicType)picType devicModel:(id)deviceModel
{
    if (self = [super init])
    {
        self.picType = picType;
        if (self.picType == DeviceCameraPicType)
        {
            self.cameraModel = deviceModel;
        }
        else
        {
            self.maoYanModel = deviceModel;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadSource];
    
    self.title = @"设备管理";
    [self.view addSubview:self.bottomBtn];
    [self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(16);
        make.right.mas_equalTo(self.view).offset(-16);
        make.height.mas_equalTo(@44);
        make.bottom.mas_equalTo(self.view).offset(-20);
    }];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.bottomBtn.mas_top).offset(-20);
    }];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - request
- (void)updateDeviceIconToSearver:(NSString *)icon
{
    HomeUpdateIconRequest *request = [[HomeUpdateIconRequest alloc] init];
    request.deviceSerial = self.cameraModel ? self.cameraModel.deviceSerialNo : self.maoYanModel.bid;
    request.icon = icon;
    BXHBlockObj(icon);
    BXHWeakObj(self);
    ProgressShow(self.view);
    [request requestWithSuccess:^(BXHBaseRequest *request) {
        ProgressHidden(selfWeak.view);
        if ([request.response.code integerValue] == 200)
        {
            if (selfWeak.picType == DeviceCameraPicType)
            {
                selfWeak.cameraModel.Icon = iconblock;
            }
            else
            {
                selfWeak.maoYanModel.Icon = iconblock;
            }
            [selfWeak.navigationController popViewControllerAnimated:YES];
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
- (void)loadSource
{
    NSString *path = [[NSBundle mainBundle] pathForResource:self.picType == DeviceMaoYanPicType ? @"MaoYanPicSource" : @"CameraPicSource" ofType:@"plist"];
    self.sourceAry = [DevicePicListModel bxhObjectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    
    for (DevicePicListModel *model in self.sourceAry)
    {
        if (self.picType == DeviceCameraPicType)
        {
            if ([self.cameraModel.Icon isEqualToString:model.serverKey])
            {
                model.sel = YES;
                break;
            }
        }
        else
        {
            if ([self.maoYanModel.Icon isEqualToString:model.serverKey])
            {
                model.sel = YES;
                break;
            }
        }
        
    }
}
#pragma mark - action
- (void)updateAction
{
    NSString *updateIcon = @"";
    
    for (DevicePicListModel *inModel in self.sourceAry)
    {
        if (inModel.sel)
         {
             updateIcon = inModel.serverKey;
             break;
        }
    }
    
    if (!StringIsEmpty(updateIcon))
    {
        [self updateDeviceIconToSearver:updateIcon];
    }

}

#pragma mark - collectDelegate dataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.sourceAry.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DevicePicListModel *model = self.sourceAry[indexPath.item];
    DeviceSettingPicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[DeviceSettingPicCell className] forIndexPath:indexPath];
    cell.deviceIcon.image = model.sel ? ImageWithName(model.selImage) : ImageWithName(model.normalImage);
    cell.selIcon.hidden = !model.sel;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    DevicePicListModel *model = self.sourceAry[indexPath.item];
    for (DevicePicListModel *inModel in self.sourceAry)
    {
        inModel.sel = [model isEqual:inModel];
    }
    [collectionView reloadData];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.picType == DeviceCameraPicType)
    {
        return CGSizeMake((DEF_SCREENWIDTH - 3) / 4, 80);
    }
    else
    {
        return CGSizeMake((DEF_SCREENWIDTH - 2) / 3, 80);
    }
}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//    return [ActivityHeaderView sizeForHeader];
//}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}


#pragma mark - get
- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = Color_Clear;
        [_collectionView registerNib:[UINib nibWithNibName:[DeviceSettingPicCell className] bundle:nil] forCellWithReuseIdentifier:[DeviceSettingPicCell className]];
    }
    return _collectionView;
}

- (UIButton *)bottomBtn
{
    if (!_bottomBtn)
    {
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomBtn.backgroundColor = [UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.buttonColor];
        [_bottomBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_bottomBtn setTitleColor:Color_White forState:UIControlStateNormal];
        _bottomBtn.layer.cornerRadius = 4;
        _bottomBtn.clipsToBounds = YES;
        _bottomBtn.titleLabel.font = Font_sys_16;
        [_bottomBtn addTarget:self action:@selector(updateAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBtn;
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
