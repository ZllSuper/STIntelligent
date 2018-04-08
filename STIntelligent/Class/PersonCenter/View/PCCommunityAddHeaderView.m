//
//  PCCommunityAddHeaderView.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/10.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "PCCommunityAddHeaderView.h"

@implementation PCCommunityAddHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self addSubview:self.headerImageView];
        [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(self);
            make.top.mas_equalTo(self).offset(8);
            make.bottom.mas_equalTo(self).offset(-8);
        }];
    }
    return self;
}

#pragma mark - get
- (UIImageView *)headerImageView
{
    if (!_headerImageView)
    {
        _headerImageView = [[UIImageView alloc] init];
    }
    return _headerImageView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
