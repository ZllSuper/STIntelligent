//
//  AboutUsViewController.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/8/15.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "AboutUsViewController.h"
#import "DeviceSettingRightCell.h"

@interface AboutUsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UILabel *headerLabel;

@property (nonatomic, strong) NSArray *sourceAry;

@property (nonatomic, strong) UILabel *bottomLabel;

@end

@implementation AboutUsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"关于我们";
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"PCAboutUsSource" ofType:@"plist"];
    self.sourceAry = [NSArray arrayWithContentsOfFile:path];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomLabel];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).offset(-5);
        make.left.and.right.mas_equalTo(self.view);
    }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - deleagte datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sourceAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DeviceSettingRightCell *cell = [tableView dequeueReusableCellWithIdentifier:[DeviceSettingRightCell className]];
    NSDictionary *dict = self.sourceAry[indexPath.row];
    cell.titleLabel.text = dict[@"leftTitle"];
    cell.rightLabel.text = dict[@"rightTitle"];
    cell.rightLabel.textColor = indexPath.row == 3 ? [UIColor darkTextColor] : [UIColor lightGrayColor];
    return cell;
}

#pragma mark - get
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREENWIDTH, 0) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.headerLabel;
        [_tableView registerNib:[UINib nibWithNibName:[DeviceSettingRightCell className] bundle:nil] forCellReuseIdentifier:[DeviceSettingRightCell className]];
    }
    return _tableView;
}

- (UILabel *)headerLabel
{
    if (!_headerLabel)
    {
        _headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREENWIDTH, 100)];
        _headerLabel.backgroundColor = Color_White;
        _headerLabel.textAlignment = NSTextAlignmentCenter;
        _headerLabel.text = @"二兔开门 真的很神";
        _headerLabel.font = FontWithSize(28);
        _headerLabel.textColor = [UIColor colorWithRed:0.29 green:0.37 blue:0.41 alpha:1.00];
    }
    return _headerLabel;
}

- (UILabel *)bottomLabel
{
    if (!_bottomLabel)
    {
        _bottomLabel = [[UILabel alloc] init];
        _bottomLabel.text = @"Powered by@Airtu Co.,Ltd";
        _bottomLabel.textColor = [UIColor lightGrayColor];
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _bottomLabel;
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
