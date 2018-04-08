//
//  BXHSTAlertViewController.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/6/13.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "BXHSTAlertViewController.h"

@interface BXHSTAlertViewController ()

@property (nonatomic, strong) UIButton *backGroundView;

@property (nonatomic, assign) CGSize contentSize;

@end

@implementation BXHSTAlertViewController

+ (BXHSTAlertViewController *)alertControllerWithContentView:(UIView *)contentView andSize:(CGSize)size
{
    BXHSTAlertViewController *vc = [[self alloc] initWithContentView:contentView andSize:size];
    return vc;
}

- (instancetype)initWithContentView:(UIView *)contentView andSize:(CGSize)size
{
    if (self = [self init])
    {
        _contentView = contentView;
        self.contentSize = size;
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.backGroundView];
    [self.view addSubview:self.contentView];
    
    [self.backGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.contentSize);
        make.center.mas_equalTo(self.view);
    }];
    
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.contentView.shiftHeightAsDodgeViewForMLInputDodger = 60;
    [self.contentView registerAsDodgeViewForMLInputDodger];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.contentView unregisterAsDodgeViewForMLInputDodger];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action
- (void)actionBtnAction:(UIButton *)sender
{
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.protcol bxhAlertViewController:self clickIndex:sender.tag - 1];
}

- (void)backGroundAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - get

- (UIButton *)backGroundView
{
    if (!_backGroundView)
    {
        _backGroundView = [UIButton buttonWithType:UIButtonTypeCustom];
        _backGroundView.backgroundColor = [UIColor blackColor];
        _backGroundView.alpha = 0.3;
        [_backGroundView addTarget:self action:@selector(backGroundAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backGroundView;
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
