//
//  WealViewController.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/8/11.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "WealViewController.h"

#import <WebKit/WebKit.h>

@interface WealViewController ()

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation WealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"福利";
    
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://14109347-12.hd.faisco.cn/14109347/V1dflRdfUm23Mq0Gk_93ZA/zhuanpan.html?otherplayer=o1ueSjngA7d1i3VFD0yARbH85ArM&shareDeep=2&isOfficialLianjie=false&from=groupmessage&isappinstalled=0&fromImgMsg=false"]]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - webView
- (WKWebView *)webView
{
    if (!_webView)
     {
         WKWebViewConfiguration *conf = [[WKWebViewConfiguration alloc] init];
         _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREENWIDTH, 0) configuration:conf];
    }
    return _webView;
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
