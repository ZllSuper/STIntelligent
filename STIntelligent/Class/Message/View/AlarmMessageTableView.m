//
//  AlarmMessageTableView.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/10.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "AlarmMessageTableView.h"

@implementation AlarmMessageTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style])
    {
        [self creatHeader];
        [self registerNib:[UINib nibWithNibName:[AlarmMessageCell className] bundle:nil] forCellReuseIdentifier:[AlarmMessageCell className]];
    }
    return self;
}

- (void)requestViewSource:(BOOL)refresh
{
    BXHWeakObj(self);
    AlarmMessageListRequest *request = [[AlarmMessageListRequest alloc] init];
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
            [selfWeak.soureAry addObjectsFromArray:[AlarmMessageModel bxhObjectArrayWithKeyValuesArray:request.response.data]];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlarmMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:[AlarmMessageCell className]];
    cell.typeLabel.textColor = [UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.barSelTextColor];
    AlarmMessageModel *model = self.soureAry[indexPath.section];
    cell.timeLabel.text = model.time;
    cell.deviceLabel.text = @"设备：摄像头";
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
