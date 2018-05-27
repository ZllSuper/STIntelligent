//
//  SystemMessageTableView.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/10.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "SystemMessageTableView.h"

@implementation SystemMessageTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style])
    {
        [self creatHeader];
        [self creatFooter];
        [self registerNib:[UINib nibWithNibName:[SystemMessageCell className] bundle:nil] forCellReuseIdentifier:[SystemMessageCell className]];
    }
    return self;
}

- (void)requestViewSource:(BOOL)refresh
{
    BXHWeakObj(self);
    SystemMessageListRequest *request = [[SystemMessageListRequest alloc] init];
    request.cUserId = KAccountInfo.userId;
    request.pageSize = _StrFormate(@"%d",10);
    request.pageStart = _StrFormate(@"%ld",self.page);
    [request requestWithSuccess:^(BXHBaseRequest *request) {
        [selfWeak endRefresh];
        if ([request.response.code integerValue] == 200)
        {
            if (refresh)
            {
                [selfWeak.soureAry removeAllObjects];
            }
            [selfWeak.soureAry addObjectsFromArray:[SystemMessageModel bxhObjectArrayWithKeyValuesArray:request.response.data]];
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

#pragma mark - overwrite
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.soureAry.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 5;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.1;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SystemMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:[SystemMessageCell className]];
    cell.typeLabel.textColor = [UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.barSelTextColor];
    SystemMessageModel *model = self.soureAry[indexPath.section];
    cell.timeLabel.text = model.Time;
    cell.messageLabel.text = model.Title;
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
