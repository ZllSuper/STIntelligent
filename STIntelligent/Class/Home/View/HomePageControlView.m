//
//  HomePageControlView.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/9/12.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "HomePageControlView.h"
#import "HomePageView.h"

@implementation HomePageControlView
- (instancetype)initWithFrame:(CGRect)frame
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];

    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    if (self = [super initWithFrame:frame collectionViewLayout:flowLayout])
    {
        self.backgroundColor = Color_Clear;
        self.dataSource = self;
        self.delegate = self;
        [self registerClass:[HomePageView class] forCellWithReuseIdentifier:[HomePageView className]];
        self.showsHorizontalScrollIndicator = NO;
        self.pagingEnabled = YES;
    }
    return self;
}

- (void)setSourceAry:(NSArray *)sourceAry
{
    _sourceAry = sourceAry;
    [self reloadData];
}

#pragma mark - delegate / datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.sourceAry)
    {
        return 10000;
    }
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomePageView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[HomePageView className] forIndexPath:indexPath];
    NSInteger index = indexPath.item % self.sourceAry.count;
    cell.pageModel = self.sourceAry[index];
    cell.delegate = self.protcol;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sView
{
    self.currentItem = fabs(sView.contentOffset.x) / sView.frame.size.width;

    if (self.protcol)
    {
        [self.protcol pageControlView:self scrollAtIndex:self.currentItem % self.sourceAry.count];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
