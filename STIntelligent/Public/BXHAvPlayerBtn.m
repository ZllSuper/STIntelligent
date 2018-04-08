//
//  BXHAvPlayerBtn.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/8/25.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "BXHAvPlayerBtn.h"

@interface BXHAvPlayerBtn ()

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@end

@implementation BXHAvPlayerBtn

- (void)dealloc
{
    [self removeNotification];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
      
        _isPlay = NO;
        [self.layer addSublayer:self.playerLayer];
        [self addNotification];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.playerLayer.frame = self.bounds;
}

-(void)addNotification
{
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

-(void)removeNotification
{
   [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)playbackFinished:(NSNotification *)notification
{
    
    [self.player seekToTime:CMTimeMake(0, 1)];
    [self.player play];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)circlePlay
{
    _isPlay = YES;
    self.playerLayer.hidden = NO;
    [self.player play];
}

- (void)stopPlay
{
    _isPlay = NO;
    [self.player pause];
    self.playerLayer.hidden = YES;
    
}

#pragma mark - lazyLoad

- (AVPlayer *)player
{
    if (!_player)
    {
        NSString *movPath = [[NSBundle mainBundle] pathForResource:@"STAVPlay" ofType:@"mp4"];
        
        // 通过文件 URL 来实例化 AVPlayerItem
        AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:movPath]];        _player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
        // 可以利用 AVPlayerItem 对这个视频的状态进行监控
        
    }
    return _player;
}

- (AVPlayerLayer *)playerLayer
{
    if (!_playerLayer)
    {
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;//视频填充模式
        self.playerLayer.hidden = YES;
        self.playerLayer.zPosition = 1;
    }
    return _playerLayer;
}


@end
