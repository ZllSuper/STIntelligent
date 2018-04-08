//
//  AddCameraStepTwoViewController.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/6/6.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "AddCameraStepTwoViewController.h"
#import "AddCameraStepThreeViewController.h"

#import "AddMaoYanWifiCell.h"

@interface AddCameraStepTwoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton *bottomBtn;

@property (nonatomic, copy) NSString *ssid;

@property (nonatomic, strong) AddMaoYanWifiCell *wifiCell;

@property (nonatomic, strong) AddMaoYanWifiCell *passwodCell;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIImageView *wifiImageView;

@property (nonatomic, strong) UIImageView *arrowImageView;

@property (nonatomic, strong) UIImageView *cameraImageView;

@property (nonatomic, strong) UILabel *tipOneLabel;

@property (nonatomic, strong) UILabel *tipTwoLabel;

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UIView *footerView;


@end

@implementation AddCameraStepTwoViewController

- (instancetype)initWithWiFiNameSSID:(NSString *)wifiName
{
    if (self = [super init])
    {
        self.ssid = wifiName;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"设备添加";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView registerAsDodgeViewForMLInputDodger];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.tableView unregisterAsDodgeViewForMLInputDodger];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action
- (void)nextStepAction:(UIButton *)sender
{
    [self.tableView endEditing:YES];
    if (StringIsEmpty(self.passwodCell.inputTextFiled.text))
    {
        ToastShowBottom(@"请输入WIFI密码");
        return;
    }
    AddCameraStepThreeViewController *vc = [[AddCameraStepThreeViewController alloc] init];
    vc.wifiName = self.ssid;
    vc.password = self.passwodCell.inputTextFiled.text;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - dataSource / delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return self.wifiCell;
    }
    else
    {
        return self.passwodCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark - get

- (AddMaoYanWifiCell *)wifiCell
{
    if (!_wifiCell)
    {
        _wifiCell = [AddMaoYanWifiCell viewFromXIB];
        _wifiCell.titleLabel.text = @"网络";
        _wifiCell.inputTextFiled.text = self.ssid;
        _wifiCell.inputTextFiled.enabled = NO;
    }
    return _wifiCell;
}

- (AddMaoYanWifiCell *)passwodCell
{
    if (!_passwodCell)
    {
        _passwodCell = [AddMaoYanWifiCell viewFromXIB];
        _passwodCell.titleLabel.text = @"密码";
        _passwodCell.inputTextFiled.placeholder = @"请输入密码";
    }
    return _passwodCell;
}

- (UIView *)headerView
{
    if (!_headerView)
    {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREENWIDTH, 240)];
        _headerView.backgroundColor = Color_White;
        [_headerView addSubview:self.tipOneLabel];
        [_headerView addSubview:self.tipTwoLabel];
        [_headerView addSubview:self.wifiImageView];
        [_headerView addSubview:self.arrowImageView];
        [_headerView addSubview:self.cameraImageView];
        
        [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_headerView);
            make.top.mas_equalTo(_headerView).offset(60);
            make.size.mas_equalTo(CGSizeMake(77.5, 6.5));
        }];

        [self.wifiImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.arrowImageView.mas_left).offset(-20);
            make.centerY.mas_equalTo(self.arrowImageView);
            make.size.mas_equalTo(CGSizeMake(36, 28));
        }];
        
        [self.cameraImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.arrowImageView.mas_right).offset(20);
            make.centerY.mas_equalTo(self.arrowImageView);
            make.size.mas_equalTo(CGSizeMake(84.5, 92.5));
        }];
        
        [self.tipOneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.arrowImageView.mas_bottom).offset(80);
            make.left.mas_equalTo(_headerView).offset(30);
            make.right.mas_equalTo(_headerView).offset(-30);
        }];
        
        [self.tipTwoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.arrowImageView.mas_bottom).offset(5);
            make.centerX.mas_equalTo(_headerView);
        }];
     
        
    }
    return _headerView;
}

- (UIView *)footerView
{
    if (!_footerView)
    {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREENWIDTH, 80)];
        [_footerView addSubview:self.bottomBtn];
        [self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_footerView).offset(16);
            make.right.mas_equalTo(_footerView).offset(-16);
            make.bottom.mas_equalTo(_footerView);
            make.height.mas_equalTo(@44);
        }];
    }
    return _footerView;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREENWIDTH, 0) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = self.footerView;
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
        [_bottomBtn setTitle:@"开始连接" forState:UIControlStateNormal];
        [_bottomBtn setTitleColor:Color_White forState:UIControlStateNormal];
        _bottomBtn.layer.cornerRadius = 4;
        _bottomBtn.clipsToBounds = YES;
        _bottomBtn.titleLabel.font = Font_sys_16;
        [_bottomBtn addTarget:self action:@selector(nextStepAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBtn;
}

- (UIImageView *)wifiImageView
{
    if (!_wifiImageView)
    {
        _wifiImageView = [[UIImageView alloc] init];
        _wifiImageView.image = ImageWithName(@"AddMaoYanWiFi");
    }
    return _wifiImageView;
}

- (UIImageView *)arrowImageView
{
    if (!_arrowImageView)
    {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = ImageWithName(@"AddMaoYanArrow");
    }
    return _arrowImageView;
}

- (UIImageView *)cameraImageView
{
    if (!_cameraImageView)
    {
        _cameraImageView = [[UIImageView alloc] init];
        _cameraImageView.image = ImageWithName(@"AddCameraSmallIcon");
    }
    return _cameraImageView;
}

- (UILabel *)tipOneLabel
{
    if(!_tipOneLabel)
    {
        _tipOneLabel = [[UILabel alloc] init];
        _tipOneLabel.font = Font_sys_14;
        _tipOneLabel.textColor = [UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.buttonColor];
        _tipOneLabel.text = @"如果你使用的双频路由器，请不要让摄像机连接5G频段的WI-FI。";
        _tipTwoLabel.numberOfLines = 2;
    }
    return _tipOneLabel;
}

- (UILabel *)tipTwoLabel
{
    if (!_tipTwoLabel)
    {
        _tipTwoLabel = [[UILabel alloc] init];
        _tipTwoLabel.font = Font_sys_12;
        _tipTwoLabel.textColor = [UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.buttonColor];
        _tipTwoLabel.text = @"连接wifi";
    }
    return _tipTwoLabel;
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
