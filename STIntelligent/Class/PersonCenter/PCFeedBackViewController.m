//
//  PCFeedBackViewController.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/12.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "PCFeedBackViewController.h"
#import "PCFeedBackTextView.h"

#import "PCFeedBackRequest.h"

@interface PCFeedBackViewController ()

@property (nonatomic, strong) PCFeedBackTextView *textView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *bottomBtn;

@end

@implementation PCFeedBackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"意见反馈";
    
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.bottomBtn];
    [self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(16);
        make.right.mas_equalTo(self.view).offset(-16);
        make.height.mas_equalTo(@44);
        make.bottom.mas_equalTo(self.view).offset(-20);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(16);
        make.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
        make.height.mas_equalTo(30);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.titleLabel.mas_bottom);
        make.height.mas_equalTo(120);
    }];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - request
- (void)feedBackRequest
{
    BXHWeakObj(self);
    ProgressShow(self.view);
    PCFeedBackRequest *request = [[PCFeedBackRequest alloc] init];
    request.cUserId = KAccountInfo.userId;
    request.text = self.textView.textView.text;
    [request requestWithSuccess:^(BXHBaseRequest *request) {
        ProgressHidden(selfWeak.view);
        if ([request.response.code integerValue] == 200)
        {
            ToastShowBottom(@"提交成功");
            [selfWeak.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            ToastShowBottom(request.response.message);
        }
    } failure:^(NSError *error, BXHBaseRequest *request) {
        ProgressHidden(selfWeak.view);
        ToastShowBottom(NetWorkErrorTip);
    }];
}

#pragma mark - action
- (void)submitAction
{
    [self.view endEditing:YES];
    if (StringIsEmpty(self.textView.textView.text))
    {
        ToastShowBottom(@"请输入意见反馈");
        return;
    }
    
    [self feedBackRequest];
}

#pragma mark - get
- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = Font_sys_14;
        _titleLabel.textColor = Color_Text_LightGray;
        _titleLabel.text = @"问题描述";
    }
    return _titleLabel;
}

- (PCFeedBackTextView *)textView
{
    if (!_textView)
    {
        _textView = [[PCFeedBackTextView alloc] init];
    }
    return _textView;
}

- (UIButton *)bottomBtn
{
    if (!_bottomBtn)
    {
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomBtn.backgroundColor = [UIColor getHexColorWithHexStr:[STThemeManager shareInstance].themeColor.buttonColor];
        [_bottomBtn setTitle:@"提交" forState:UIControlStateNormal];
        [_bottomBtn setTitleColor:Color_White forState:UIControlStateNormal];
        _bottomBtn.layer.cornerRadius = 4;
        _bottomBtn.clipsToBounds = YES;
        _bottomBtn.titleLabel.font = Font_sys_16;
        [_bottomBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
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
