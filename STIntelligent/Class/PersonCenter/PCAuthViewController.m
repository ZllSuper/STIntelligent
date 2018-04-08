//
//  PCAuthViewController.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/10.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "PCAuthViewController.h"

#import "ValuePickerView.h"

#import "PCAuthCell.h"

@interface PCAuthViewController () <UITableViewDelegate, UITableViewDataSource, PCAuthCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *bottomBtn;

@property (nonatomic, strong) NSArray *sourceAry;

@property (nonatomic, strong) ValuePickerView *pickerView;

@end

@implementation PCAuthViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"实名认证";
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"PCAuthSource" ofType:@"plist"];
    self.sourceAry = [PCAuthListModel bxhObjectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    
    [self.view addSubview:self.bottomBtn];
    [self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(16);
        make.right.mas_equalTo(self.view).offset(-16);
        make.height.mas_equalTo(@44);
        make.bottom.mas_equalTo(self.view).offset(-20);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.bottomBtn.mas_top).offset(-20);
    }];

    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action
- (void)authAction:(UIButton *)sender
{
    [self.tableView endEditing:YES];
}

#pragma mark - delegate datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sourceAry.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PCAuthCell *cell = [tableView dequeueReusableCellWithIdentifier:[PCAuthCell className]];
    PCAuthListModel *model = self.sourceAry[indexPath.row];
    cell.listModel = model;
    cell.delegate = self;
    if ([model.type integerValue] == 0)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

#pragma mark - celldelegate
- (BOOL)authCellTextFiledWillBegainEditing:(PCAuthCell *)authCell
{
    if ([authCell.listModel.type integerValue] == 0)
    {
        return YES;
    }
    else
    {
        [self.tableView endEditing:YES];
        [self.pickerView show];
        BXHWeakObj(authCell);
        [self.pickerView setValueDidSelect:^(NSInteger index) {
            NSString *result = [@[@"父母",@"爱人",@"兄妹",@"子女"] objectAtIndex:index];
            authCellWeak.inputTextFiled.text = result;
            authCellWeak.listModel.inputValue = result;
        }];

        return NO;
    }
}

- (void)authCellTextFileEndEdit:(PCAuthCell *)authCell
{
    authCell.listModel.inputValue = authCell.inputTextFiled.text;
}

#pragma mark - get
- (ValuePickerView *)pickerView
{
    if (!_pickerView)
    {
        _pickerView = [[ValuePickerView alloc] init];
        _pickerView.dataSource = @[@"父母",@"爱人",@"兄妹",@"子女"];
        _pickerView.pickerTitle = @"被邀请人关系";
    }
    return _pickerView;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:[PCAuthCell className] bundle:nil] forCellReuseIdentifier:[PCAuthCell className]];
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _tableView;
}

- (UIButton *)bottomBtn
{
    if (!_bottomBtn)
    {
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomBtn.backgroundColor = [UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.buttonColor];
        [_bottomBtn setTitle:@"发起认证" forState:UIControlStateNormal];
        [_bottomBtn setTitleColor:Color_White forState:UIControlStateNormal];
        _bottomBtn.layer.cornerRadius = 4;
        _bottomBtn.clipsToBounds = YES;
        _bottomBtn.titleLabel.font = Font_sys_16;
        [_bottomBtn addTarget:self action:@selector(authAction:) forControlEvents:UIControlEventTouchUpInside];
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
