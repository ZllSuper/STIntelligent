//
//  PCAccountInfoTableView.m
//  BoMuCai
//
//  Created by 步晓虎 on 2017/2/8.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "PCAccountInfoTableView.h"

@implementation PCAccountInfoTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style])
    {
        [self registerNib:[UINib nibWithNibName:[PCAccountLabelCell className] bundle:nil] forCellReuseIdentifier:[PCAccountLabelCell className]];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"PCAccountInfoList" ofType:@"plist"];
        self.soureAry = [NSArray arrayWithContentsOfFile:path];
        
        
    }
    return self;
}

#pragma mark - request
- (void)requestViewSource:(BOOL)refresh
{
//    __weak typeof(self) weakSelf = self;
//    PCAccountInfoRequest *request = [[PCAccountInfoRequest alloc] init];
//    request.userId = KAccountInfo.userId;
//    ProgressShow(self.superview);
//    [request requestWithSuccess:^(id result, BXHBaseRequest *request) {
//        ProgressHidden(weakSelf.superview);
//        if ([request.response.code isEqualToString:@"0000"])
//        {
//            [weakSelf.accountModel bxhObjectWithKeyValues:request.response.data];
//            [weakSelf.imageCell.headerImageView sd_setImageWithURL:[NSURL URLWithString:weakSelf.accountModel.photo] placeholderImage:ImagePlaceHolder];
//            [weakSelf reloadData];
//        }
//        else
//        {
//            ToastShowBottom(request.response.message);
//        }
//        [weakSelf endRefresh];
//    } failure:^(NSError *error, BXHBaseRequest *request) {
//        ProgressHidden(weakSelf.superview);
//        ToastShowBottom(NetWorkErrorTip);
//        [weakSelf endRefresh];
//    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.soureAry.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionAry = self.soureAry[section];
    return sectionAry.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.1;
    }
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sectionAry = self.soureAry[indexPath.section];
    NSDictionary *rowDict = sectionAry[indexPath.row];
    return [rowDict[@"height"] floatValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sectionAry = self.soureAry[indexPath.section];
    NSDictionary *rowDict = sectionAry[indexPath.row];
    
    if([rowDict[@"type"] isEqualToString:@"1"])
    {
        return self.imageCell;
    }
    else
    {
       PCAccountLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:[PCAccountLabelCell className]];
        cell.titleLabel.text = rowDict[@"title"];
        cell.sourceLabel.textColor = Color_Text_Gray;
        cell.sourceLabel.text = [KAccountInfo valueForKey:rowDict[@"key"]];
        return cell;
    }
}

#pragma mark - get
- (PCAccountImageCell *)imageCell
{
    if (!_imageCell)
    {
        _imageCell = [PCAccountImageCell viewFromXIB];
        if (!StringIsEmpty(KAccountInfo.photo))
        {
            [_imageCell.headerImageView bxh_imageWithUrlStr:KAccountInfo.photo placeholderImage:ImageWithName(@"PersonCenterHeaderDefault")];
        }
    }
    return _imageCell;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
