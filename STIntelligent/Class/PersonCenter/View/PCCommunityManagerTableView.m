//
//  PCCommunityManagerTableView.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/10.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "PCCommunityManagerTableView.h"


@implementation PCCommunityManagerTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style])
    {
        self.tableFooterView = [UIView new];
        [self creatHeader];
        [self creatFooter];
        [self registerNib:[UINib nibWithNibName:[PCCommunityManagerCell className] bundle:nil] forCellReuseIdentifier:[PCCommunityManagerCell className]];
    }
    return self;
}

- (void)requestViewSource:(BOOL)refresh
{
    BXHWeakObj(self);
    PCCommunityListRequest *request = [[PCCommunityListRequest alloc] init];
    request.cUserId = KAccountInfo.userId;
    request.pageSize = _StrFormate(@"%d",ListPageSize);
    request.curPage = _StrFormate(@"%ld",self.page);
    [request requestWithSuccess:^(BXHBaseRequest *request) {
        [self endRefresh];
        if ([request.response.code integerValue] == 200)
        {
            
            selfWeak.soureAry = [PCCommunityListModel bxhObjectArrayWithKeyValuesArray:request.response.data];
            [selfWeak reloadData];
        }
        else
        {
            ToastShowBottom(request.response.message);
        }

    } failure:^(NSError *error, BXHBaseRequest *request) {
        ToastShowBottom(NetWorkErrorTip);

    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.soureAry.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PCCommunityManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:[PCCommunityManagerCell className]];
    cell.statueLabel.textColor = indexPath.section % 2 == 0 ? [UIColor getHexColorWithHexStr:@"#005DFB"] : [UIColor getHexColorWithHexStr:@"#DB003B"];
    cell.listWeakModel = self.soureAry[indexPath.section];
    return cell;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
