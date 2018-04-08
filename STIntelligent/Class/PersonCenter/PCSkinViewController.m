//
//  PCSkinViewController.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/6/20.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "PCSkinViewController.h"

#import "PCSkinCell.h"

#import "PCSkinModel.h"

@interface PCSkinViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, STThemeManagerProtcol>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *sourceAry;

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation PCSkinViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"皮肤中心";
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"PCSkinSource" ofType:@"plist"];
    self.sourceAry = [PCSkinModel bxhObjectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    
    for (PCSkinModel *model in self.sourceAry)
    {
        model.sel = [model.bundleName isEqualToString:[STThemeManager shareInstance].bundleName];
    }
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.collectionView];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    [[STThemeManager shareInstance] addThemeChangeProtcol:self];
    [self themeChange];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)themeChange
{
    self.imageView.image = ThemeImageWithName(@"HomeBack");
}

#pragma mark - delegate / datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.sourceAry.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PCSkinCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[PCSkinCell className] forIndexPath:indexPath];
    cell.weakModel = self.sourceAry[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    PCSkinModel *model = self.sourceAry[indexPath.item];
    
    [[STThemeManager shareInstance] changeBundleName:model.bundleName];
    
    for (PCSkinModel *model in self.sourceAry)
    {
        model.sel = [model.bundleName isEqualToString:[STThemeManager shareInstance].bundleName];
    }
    
    [collectionView reloadData];

    
//    if ([[STThemeManager shareInstance].bundleName isEqualToString:@"MainThemeBundle"])
//    {
//        [[STThemeManager shareInstance] changeBundleName:@"ThemeTechnologyBundle"];
//    }
//    else
//    {
//        [[STThemeManager shareInstance] changeBundleName:@"MainThemeBundle"];
//    }

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((DEF_SCREENWIDTH - 30) / 3, (DEF_SCREENWIDTH - 30) / 3 * (379 / 214.0) + 40);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

#pragma mark - get
- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREENWIDTH, 0) collectionViewLayout:[UICollectionViewFlowLayout new]];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerNib:[UINib nibWithNibName:[PCSkinCell className] bundle:nil] forCellWithReuseIdentifier:[PCSkinCell className]];
        _collectionView.backgroundColor = Color_Clear;
    }
    return _collectionView;
}

- (UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
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
