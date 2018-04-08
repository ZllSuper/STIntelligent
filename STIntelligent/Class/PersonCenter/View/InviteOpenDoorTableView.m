//
//  InviteOpenDoorTableView.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/11.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "InviteOpenDoorTableView.h"

@implementation InviteOpenDoorTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style])
    {
        self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [self registerNib:[UINib nibWithNibName:[PCAuthCell className] bundle:nil] forCellReuseIdentifier:[PCAuthCell className]];
        [self registerClass:[OpenDoorFooterView class] forHeaderFooterViewReuseIdentifier:[OpenDoorFooterView className]];
        [self registerClass:[OpenDoorCommunityCell class] forCellReuseIdentifier:[OpenDoorCommunityCell className]];
    }
    return self;
}

#pragma mark - request
- (void)requestViewSource:(BOOL)refresh
{
    ODCommunityListRequest *request = [[ODCommunityListRequest alloc] init];
    request.cUserId = KAccountInfo.userId;
    BXHWeakObj(self);
    ProgressShow(self.superview);
    [request requestWithSuccess:^(BXHBaseRequest *request) {
        ProgressHidden(selfWeak.superview);
        if ([request.response.code integerValue] == 200)
        {
            selfWeak.soureAry = [ODCommunityModel bxhObjectArrayWithKeyValuesArray:request.response.data];
            [selfWeak reloadData];
        }
        else
        {
            ToastShowBottom(request.response.message);
        }
    } failure:^(NSError *error, BXHBaseRequest *request) {
        ProgressHidden(selfWeak.superview);
        ToastShowBottom(NetWorkErrorTip);
    }];
}

#pragma mark - overwrite
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.soureAry.count == 0)
    {
        return 2;
    }
    return self.soureAry.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.soureAry.count == 0)
    {
        if (section == 0)
        {
            return 2;
        }
        return 0;
    }
    else
    {
        if (section == 0)
        {
            return 2;
        }
        ODCommunityModel *model = self.soureAry[section - 1];
        return model.doorListAll.count;

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 8;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 40;
    }
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        return self.titleFooterView;
    }
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return [UIView new];
    }
    if (self.soureAry.count == 0)
    {
        OpenDoorFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[OpenDoorFooterView className]];
        footerView.contentView.backgroundColor = Color_White;
        footerView.titleLabel.font = Font_sys_14;
        footerView.titleLabel.text = @"您没有们可供邀请";
        footerView.titleLabel.textColor = [UIColor darkTextColor];
        return footerView;
    }
    else
    {
        ODCommunityModel *model = self.soureAry[section - 1];
        OpenDoorFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[OpenDoorFooterView className]];
        footerView.contentView.backgroundColor = Color_White;
        footerView.titleLabel.font = Font_sys_14;
        footerView.titleLabel.text = model.comName;
        footerView.titleLabel.textColor = [UIColor darkTextColor];
        return footerView;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            return self.nameCell;
        }
        else
        {
            return self.releationShipCell;
        }
    }
    else
    {
        ODCommunityModel *model = self.soureAry[indexPath.section - 1];
        ODDoorModel *doorModel = model.doorListAll[indexPath.row];
        OpenDoorCommunityCell *cell = [tableView dequeueReusableCellWithIdentifier:[OpenDoorCommunityCell className]];
        cell.protcol = self;
        cell.titleLabel.text = doorModel.name;
        cell.weakModel = doorModel;
        return cell;
    }
}

#pragma mark - cellDelegate
- (void)cell:(OpenDoorCommunityCell *)cell switchBtnAction:(LQXSwitch *)sender
{
    ODDoorModel *doorModel = (ODDoorModel *)cell.weakModel;
    doorModel.select = sender.on;
    if (self.inviteDelegate)
    {
        [self.inviteDelegate tableViewInviteDoorChange:self];
    }
}

#pragma mark - get
- (OpenDoorFooterView *)titleFooterView
{
    if (!_titleFooterView)
    {
        _titleFooterView = [[OpenDoorFooterView alloc] initWithReuseIdentifier:@"footerView"];
        _titleFooterView.titleLabel.text = @"请选择开门钥匙（可多选）";
        _titleFooterView.titleLabel.textColor = Color_Text_Gray;
        _titleFooterView.backgroundColor = Color_Clear;
        _titleFooterView.titleLabel.font = Font_sys_14;
    }
    return _titleFooterView;
}

- (PCAuthCell *)nameCell
{
    if (!_nameCell)
    {
        _nameCell = [PCAuthCell viewFromXIB];
        _nameCell.titleLabel.text = @"被邀请人姓名";
        _nameCell.inputTextFiled.placeholder = @"请输入被邀请人姓名";
    }
    return _nameCell;
}

- (PCAuthCell *)releationShipCell
{
    if (!_releationShipCell)
    {
        _releationShipCell = [PCAuthCell viewFromXIB];
        _releationShipCell.titleLabel.text = @"被邀请人关系";
        _releationShipCell.inputTextFiled.placeholder = @"请输入被邀请人关系";
        _releationShipCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return _releationShipCell;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
