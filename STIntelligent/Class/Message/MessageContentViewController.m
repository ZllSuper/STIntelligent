//
//  MessageContentViewController.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/9/12.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "MessageContentViewController.h"
#import <WebKit/WebKit.h>

@interface MessageContentViewController ()

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, weak) SystemMessageModel *messageModel;

@end

@implementation MessageContentViewController

- (instancetype)initWithContentType:(MessageContentType)contentType andSystemModel:(SystemMessageModel *)messageModel
{
    if (self = [super init])
    {
        _contentType = contentType;
        self.messageModel = messageModel;
        if (contentType == MessageContentWebType)
        {
            [self.view addSubview:self.webView];
            [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(self.view);
            }];
        }
        else
        {
            [self.view addSubview:self.titleLabel];
            [self.view addSubview:self.contentLabel];
            
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.view).offset(16);
                make.top.mas_equalTo(self.view).offset(16);
            }];
            
            [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.view).offset(16);
                make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(16);
            }];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"系统消息";
    self.view.backgroundColor = Color_Gray_bg;
    if (_contentType == MessageContentWebType)
    {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.messageModel.Content]]];
    }
    else
    {
        self.titleLabel.text = self.messageModel.Title;
        self.contentLabel.text = self.messageModel.Content;
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - get
- (WKWebView *)webView
{
    if (!_webView)
    {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREENWIDTH, 0) configuration:config];
    }
    return _webView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = Font_sys_14;
        _titleLabel.textColor = [UIColor darkTextColor];
    }
    return _titleLabel;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel)
    {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = Font_sys_14;
        _contentLabel.textColor = Color_Text_LightGray;
    }
    return _contentLabel;
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
