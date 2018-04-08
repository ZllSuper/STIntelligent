//
//  DeviceEditNameViewController.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/8/10.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "DeviceEditNameViewController.h"

#import "DeviceEditNameRequest.h"

@interface DeviceEditNameViewController ()

@property (nonatomic, strong) UITextField *textFiled;

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, weak) id weakModel;

@end

@implementation DeviceEditNameViewController

- (instancetype)initWithWeakModel:(id)weakModel andType:(DevicePicType)type
{
    if (self = [super init])
    {
        self.weakModel = weakModel;
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"修改名称";
    
    [self initRightNavigationItemWithTitle:@"确定" target:self action:@selector(rightBtnAction)];
    
    self.backView = [[UIView alloc] init];
    self.backView.backgroundColor = Color_White;
    [self.view addSubview:self.backView];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(8);
        make.height.mas_equalTo(44);
    }];
    
    [self.backView addSubview:self.textFiled];
    [self.textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.mas_equalTo(self.backView);
        make.left.mas_equalTo(self.backView).offset(16);
        make.right.mas_equalTo(self.backView).offset(-16);
    }];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.textFiled becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - request
- (void)updateUserNickName
{
    __weak typeof(self) weakSelf = self;
    DeviceEditNameRequest *infoRequest = [[DeviceEditNameRequest alloc] init];
    infoRequest.deviceSerial = self.type == DeviceCameraPicType ? [(SheXiangTouModel *)self.weakModel deviceSerialNo] : [(MaoYanModel *)self.weakModel bid];
    infoRequest.deviceName = self.textFiled.text;
    ProgressShow(self.view);
    [infoRequest requestWithSuccess:^(BXHBaseRequest *request) {
        ProgressHidden(weakSelf.view);
        if ([request.response.code integerValue] == 200)
        {
            if (self.type == DeviceCameraPicType)
            {
                [(SheXiangTouModel *)weakSelf.weakModel setName:weakSelf.textFiled.text];
            }
            else
            {
                [(MaoYanModel *)weakSelf.weakModel setName:weakSelf.textFiled.text];
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            ToastShowBottom(request.response.message);
        }
    } failure:^(NSError *error, BXHBaseRequest *request) {
        ProgressHidden(weakSelf.view);
        ToastShowBottom(NetWorkErrorTip);
    }];
}

#pragma mark - action
- (void)rightBtnAction
{
    [self.view endEditing:YES];
    if (StringIsEmpty(self.textFiled.text))
    {
        ToastShowBottom(@"请输入名称");
        return;
    }
    
    if ([self.textFiled.text getToInt] > 12)
    {
        ToastShowBottom(@"您最多输入6个汉字或者12个字母");
        return;
    }
    [self updateUserNickName];
}

#pragma mark - set / get
- (UITextField *)textFiled
{
    if (!_textFiled)
    {
        _textFiled = [[UITextField alloc] init];
        _textFiled.clearButtonMode = UITextFieldViewModeAlways;
        _textFiled.font = Font_sys_14;
        _textFiled.textColor = Color_MainText;
    }
    return _textFiled;
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
