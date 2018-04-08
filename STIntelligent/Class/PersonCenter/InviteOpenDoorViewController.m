//
//  InviteOpenDoorViewController.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/11.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "InviteOpenDoorViewController.h"
#import "TemporaryHistoryViewController.h"
#import "ViceCardHistoryViewController.h"

@interface InviteOpenDoorViewController ()

@property (nonatomic, strong) UIButton *temporaryOpenDoor;

@property (nonatomic, strong) UIButton *viceCardOpenDoor;

@end

@implementation InviteOpenDoorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"邀请开门";
    
    [self.view addSubview:self.temporaryOpenDoor];
    [self.view addSubview:self.viceCardOpenDoor];
    
    [self.temporaryOpenDoor mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(self.view).multipliedBy(820 / 1080.0);
        make.height.mas_equalTo(self.temporaryOpenDoor.mas_width).multipliedBy(330 / 820.0);
        make.bottom.mas_equalTo(self.view.mas_centerY).offset(-40);
    }];
    
    [self.viceCardOpenDoor mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(self.view).multipliedBy(820 / 1080.0);
        make.height.mas_equalTo(self.temporaryOpenDoor.mas_width).multipliedBy(330 / 820.0);
        make.top.mas_equalTo(self.view.mas_centerY);
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
- (void)temporaryOpenDoorAction
{
    TemporaryHistoryViewController *vc = [[TemporaryHistoryViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viceCardOpenDoorAction
{
    ViceCardHistoryViewController *vc = [[ViceCardHistoryViewController  alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - get
- (UIButton *)temporaryOpenDoor
{
    if (!_temporaryOpenDoor)
    {
        _temporaryOpenDoor = [UIButton buttonWithType:UIButtonTypeCustom];
        [_temporaryOpenDoor setImage:ThemeImageWithName(@"PCInviteOpenDoorIcon") forState:UIControlStateNormal];
        [_temporaryOpenDoor setBackgroundImage:ImageWithColor(Color_White) forState:UIControlStateNormal];
        [_temporaryOpenDoor setTitle:@"   临时开门" forState:UIControlStateNormal];
        [_temporaryOpenDoor setTitleColor:[UIColor getHexColorWithHexStr:@"#2873FB"] forState:UIControlStateNormal];
        _temporaryOpenDoor.titleLabel.font = FontWithSize(20);
//        _temporaryOpenDoor.backgroundColor = Color_White;
        _temporaryOpenDoor.layer.cornerRadius = 6;
        _temporaryOpenDoor.clipsToBounds = YES;
        [_temporaryOpenDoor addTarget:self action:@selector(temporaryOpenDoorAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _temporaryOpenDoor;
}

- (UIButton *)viceCardOpenDoor
{
    if (!_viceCardOpenDoor)
    {
        _viceCardOpenDoor = [UIButton buttonWithType:UIButtonTypeCustom];
        [_viceCardOpenDoor setImage:ThemeImageWithName(@"PCViceCardIcon") forState:UIControlStateNormal];
        [_viceCardOpenDoor setBackgroundImage:ImageWithColor(Color_White) forState:UIControlStateNormal];
        [_viceCardOpenDoor setTitle:@"   副卡开门" forState:UIControlStateNormal];
        [_viceCardOpenDoor setTitleColor:[UIColor getHexColorWithHexStr:@"#DD4457"] forState:UIControlStateNormal];
        _viceCardOpenDoor.titleLabel.font = FontWithSize(20);
//        _viceCardOpenDoor.backgroundColor = Color_White;
        _viceCardOpenDoor.layer.cornerRadius = 6;
        _viceCardOpenDoor.clipsToBounds = YES;
        [_viceCardOpenDoor addTarget:self action:@selector(viceCardOpenDoorAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _viceCardOpenDoor;
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
