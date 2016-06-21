//
//  MyCustomerPlayer.m
//  TestAVPlayer
//
//  Created by GEM on 5/4/16.
//  Copyright © 2016 GEM. All rights reserved.
//

#import "MyCustomerPlayer.h"

#define kAnimationDuration  0.3
#define kDurationToHideContol 5


//static const float DefaultPlayableBufferLength = 2.0f;
//static const float DefaultVolumeFadeDuration = 1.0f;
static const float TimeObserverInterval = 0.01f;
/**
 *  define observer contexts
 */
static void *VideoPlayer_PlayerCurrentItemContext            = &VideoPlayer_PlayerCurrentItemContext;
static void *VideoPlayer_PlayerItemStatusContext             = &VideoPlayer_PlayerItemStatusContext;
static void *VideoPlayer_PlayerRateChangedContext            = &VideoPlayer_PlayerRateChangedContext;
static void *VideoPlayer_PlayerItemPlaybackLikelyToKeepUp    = &VideoPlayer_PlayerItemPlaybackLikelyToKeepUp;

@interface MyCustomerPlayer()
{
    BOOL isAnimationing;
    /**
     *  used this property to seek to correct time after change the source type of streaming video
     */
    CMTime shouldSeekToTime;
}
@property (nonatomic, strong) NSString *nibNameOrNil;
@end

@implementation MyCustomerPlayer

-(id) init
{
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    return self;
}

-(void) viewDidLoad
{
    [super viewDidLoad];
    
    [self setup];
}

#pragma mark Observer functions
- (void)setup
{
    UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onOverlayTapped:)];
    [tap setDelegate:self];
    [self.view setUserInteractionEnabled:YES];
    [self.view addGestureRecognizer:tap];
    
    _player = [[AVPlayer alloc] init];
    [self addPlayerObservers];
    [self addTimeObserver];
    
    _playerLayer = [[AVPlayerLayer alloc] init];
    [_playerLayer setPlayer:_player];
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;

    [self.view.layer insertSublayer:_playerLayer atIndex:0];
    
    /**
     *  add seek observer
     */
    [seekSlider addTarget:self action:@selector(sliderBeganTracking:) forControlEvents:UIControlEventTouchDown];
    [seekSlider addTarget:self action:@selector(sliderEndedTracking:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [seekSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [[UISlider appearance] setThumbImage:[UIImage imageNamed:@"ic_player_circle"]
                                forState:UIControlStateNormal];
    /**
     *  handle tap to show/ hide playback controls
     */
    [self showControlsAndHiddenControlsAfter:kDurationToHideContol];
    
    shouldSeekToTime = kCMTimeInvalid;
}

-(AVPlayer *) player
{
    return _player;
}
#pragma mark - Private API

- (void)reportUnableToCreatePlayerItem
{
    if ([self.delegate respondsToSelector:@selector(myCustomPlayer:didFailWithError:)])
    {
        NSError *error = [NSError errorWithDomain:@""
                                             code:0
                                         userInfo:@{NSLocalizedDescriptionKey : @"Unable to create AVPlayerItem."}];
        [self.delegate myCustomPlayer:self didFailWithError:error];
    }
}

- (void)resetPlayerItemIfNecessary
{
    if (_playerItem)
    {
        [self removePlayerItemObservers:_playerItem];
        
        [_player replaceCurrentItemWithPlayerItem:nil];
        
        _playerItem = nil;
    }
    
    playing = NO;
}

- (void)preparePlayerItem:(AVPlayerItem *)playerItem
{
    NSParameterAssert(playerItem);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(myCustomPlayerprepareToPlay:)]) {
        [self.delegate myCustomPlayerprepareToPlay:self];
    }
    
    _playerItem = playerItem;
    
    [self addPlayerItemObservers:playerItem];
    
    [_player replaceCurrentItemWithPlayerItem:playerItem];
}

#pragma mark - Player Observers

- (void)addPlayerObservers
{
    [_player addObserver:self
              forKeyPath:NSStringFromSelector(@selector(currentItem))
                 options: NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                 context:VideoPlayer_PlayerCurrentItemContext];
    
    [_player addObserver:self
                  forKeyPath:NSStringFromSelector(@selector(rate))
                     options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                     context:VideoPlayer_PlayerRateChangedContext];
    
    [_player addObserver:self forKeyPath:@"currentItem.playbackLikelyToKeepUp" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:VideoPlayer_PlayerItemPlaybackLikelyToKeepUp];
}

- (void)removePlayerObservers
{
    @try
    {
        [_player removeObserver:self
                     forKeyPath:NSStringFromSelector(@selector(currentItem))
                        context:VideoPlayer_PlayerCurrentItemContext];
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception removing observer: %@", exception);
    }
    
    @try
    {
        [_player removeObserver:self
                         forKeyPath:NSStringFromSelector(@selector(rate))
                            context:VideoPlayer_PlayerRateChangedContext];
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception removing observer: %@", exception);
    }
    
    @try
    {
        [_player removeObserver:self
                     forKeyPath:@"currentItem.playbackLikelyToKeepUp"
                        context:VideoPlayer_PlayerItemPlaybackLikelyToKeepUp];
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception removing observer: %@", exception);
    }
}

#pragma mark - PlayerItem Observers

- (void)addPlayerItemObservers:(AVPlayerItem *)playerItem
{
    [playerItem addObserver:self
                 forKeyPath:NSStringFromSelector(@selector(status))
                    options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                    context:VideoPlayer_PlayerItemStatusContext];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerFinishedPlaying:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:playerItem];
}

- (void)removePlayerItemObservers:(AVPlayerItem *)playerItem
{
    [playerItem cancelPendingSeeks];
    
    @try
    {
        [playerItem removeObserver:self
                        forKeyPath:NSStringFromSelector(@selector(status))
                           context:VideoPlayer_PlayerItemStatusContext];
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception removing observer: %@", exception);
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
}

#pragma mark - Time Observer

- (void)addTimeObserver
{
    if (timeObserver || _player == nil)
    {
        return;
    }
    
    __weak typeof (self) weakSelf = self;
    timeObserver = [_player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(TimeObserverInterval, NSEC_PER_SEC) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        [weakSelf observerTime:time];
    }];
}

- (void)removeTimeObserver
{
    if (timeObserver == nil)
    {
        return;
    }
    
    if (_player)
    {
        [_player removeTimeObserver:timeObserver];
    }
    
    timeObserver = nil;
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (context == VideoPlayer_PlayerCurrentItemContext) {
        
        AVPlayerItem *newPlayerItem = [change objectForKey:NSKeyValueChangeNewKey];
        AVPlayerItem *oldPlayerItem = [change objectForKey:NSKeyValueChangeOldKey];
        
        /* New player item null? */
        if (newPlayerItem == (id)[NSNull null])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self disableScrubber];
            });
        }
        else if (newPlayerItem != oldPlayerItem)/* Replacement of player currentItem has occurred */
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self syncPlayPauseButtons];
                [self enableScrubber];
            });
        }
        
    }
    else if (context == VideoPlayer_PlayerItemPlaybackLikelyToKeepUp) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_player.currentItem.isPlaybackLikelyToKeepUp) {
                NSLog(@"VideoPlayer_PlayerItemPlaybackLikelyToKeepUp");
                [loadingIndicator stopAnimating];
                /**
                 *  play button's alpha value is the same with view header
                 */
                btPlay.alpha = viewHeader.alpha;
                
            }else{
                [loadingIndicator startAnimating];
                btPlay.alpha = 0;
            }
            if ([self isPlaying]) {
                [self play];
            }
        });
    }
    else if (context == VideoPlayer_PlayerItemStatusContext){
        
        AVPlayerStatus newStatus = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        AVPlayerStatus oldStatus = [[change objectForKey:NSKeyValueChangeOldKey] integerValue];
        
        if (newStatus != oldStatus)
        {
            switch (_player.currentItem.status) {
                case AVPlayerItemStatusUnknown:
                    NSLog(@"AVPlayerItemStatusUnknown: %@",[[_player.currentItem error] localizedDescription]);
                    [self reportUnableToCreatePlayerItem];
                    break;
                case AVPlayerItemStatusFailed:
                    NSLog(@"AVPlayerItemStatusFailed: %@",[[_player.currentItem error] localizedDescription]);
                    [self reportUnableToCreatePlayerItem];
                    break;
                case AVPlayerItemStatusReadyToPlay:
                    if (self.delegate && [self.delegate respondsToSelector:@selector(myCustomPlayerReadyToPlay:)]) {
                        [self.delegate myCustomPlayerReadyToPlay:self];
                    }

                    /**
                     *  make AVPlayer player sound when device is muted
                     */
                    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                    
                    DLog(@"AVPlayerItemStatusReadyToPlay");
                    if (playing)
                    {
                        [self play];
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self enableScrubber];
                    });
                    
                    /**
                     *  seek to last time viewed after change the streaming's quality
                     *
                     */
                    if (_player.currentItem && CMTIME_IS_VALID([self getPlayingItemDuration]) && CMTIME_IS_VALID(shouldSeekToTime)) {
                        [_player seekToTime:shouldSeekToTime];
                    }
                    /**
                     *  set shouldSeekToTime to CMTimeInvalid after seek the current item to the last segment
                     */
                    shouldSeekToTime = kCMTimeInvalid;
                    
                    break;
            }
        }
        else if (newStatus == AVPlayerItemStatusReadyToPlay)
        {
            // When playback resumes after a buffering event, a new ReadyToPlay status is set [RH]
        }
    }
    /* AVPlayer "rate" property value observer. */
    else if (context == VideoPlayer_PlayerRateChangedContext)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self syncPlayPauseButtons];
        });
    }
    else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

-(NSURL *)urlOfCurrentlyPlayingInPlayer:(AVPlayer *)player{
    // get current asset
    AVAsset *currentPlayerAsset = player.currentItem.asset;
    // make sure the current asset is an AVURLAsset
    if (![currentPlayerAsset isKindOfClass:AVURLAsset.class]) return nil;
    // return the NSURL
    return [(AVURLAsset *)currentPlayerAsset URL];
}


-(void) onOverlayTapped:(UIGestureRecognizer *) tap
{
    CGFloat alpha = viewOverlay.alpha == 0 ? 1 : 0;
    if (alpha == 1) {
        [self showControlsAndHiddenControlsAfter:kDurationToHideContol];
    }else{
        [self hiddenControls];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UISlider class]]){
        return NO;
    }else{
        return YES;
    }
}

- (void)syncPlayPauseButtons
{
    if ([self isPlaying])
    {
        btPlay.selected = YES;
    }
    else
    {
        btPlay.selected = NO;
    }
}

- (BOOL)isPlaying
{
    return [_player rate] != 0.f;
}

-(void)showControls
{
    if (isAnimationing) {
        return;
    }
    isAnimationing = YES;
    [UIView animateWithDuration:kAnimationDuration animations:^{
        CGFloat alpha = 1;
        viewOverlay.alpha = alpha;
        viewHeader.alpha = alpha;
        viewFooter.alpha = alpha;
        if (loadingIndicator.isAnimating) {
            btPlay.alpha = 0;
        }else{
            btPlay.alpha = alpha;
        }
    } completion:^(BOOL finished) {
        isAnimationing = NO;
    }];
}

-(void)showControlsAndHiddenControlsAfter:(NSTimeInterval)time
{
    [self showControls];
    if(time != 0)
        [self performSelector:@selector(hiddenControls) withObject:nil afterDelay:time];
}

-(void)hiddenControls
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenControls) object:nil];
    
    if (isAnimationing) {
        return;
    }
    isAnimationing = YES;
    [UIView animateWithDuration:kAnimationDuration animations:^{
        [UIView animateWithDuration:kAnimationDuration animations:^{
            CGFloat alpha = 0;
            viewOverlay.alpha = alpha;
            viewHeader.alpha = alpha;
            viewFooter.alpha = alpha;
            btPlay.alpha = alpha;
        } completion:^(BOOL finished) {
            isAnimationing = NO;
        }];
    } completion:^(BOOL finished) {
        isAnimationing = NO;
    }];
}

-(void) playerFinishedPlaying:(NSNotification *) notification
{
    if (notification.object != _player.currentItem)
    {
        return;
    }
        
    [self syncPlayPauseButtons];
    playing = NO;
    seekToZeroBeforePlay = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(myCustomPlayerFinishedPlayback:)]) {
        [self.delegate myCustomPlayerFinishedPlayback:self];
    }
}

-(void) observerTime:(CMTime) elapsedTime {
    
    if (CMTIME_IS_VALID(shouldSeekToTime)) {
        /**
         *  dont update seek slider while change streaming's quality
         */
        return;
    }
    
    Float64 duration = CMTimeGetSeconds(_player.currentItem.duration);
    if (isfinite(duration)) {
        [self updateTimeLabel:elapsedTime duration:_player.currentItem.duration];
    }else{
        [self updateTimeLabel:elapsedTime duration:kCMTimeZero];
    }
}

-(void) updateTimeLabel:(CMTime) elapsedTime duration:(CMTime) duration
{
    if (CMTimeGetSeconds(duration) == CMTimeGetSeconds(kCMTimeZero)) {
        lbElapsedTime.text = [self getStringFromCMTime:elapsedTime];
        lbDuration.text = @"--:--";
        seekSlider.value = 0.0f;
        [self disableScrubber];
    }else{
        lbElapsedTime.text = [self getStringFromCMTime:elapsedTime];
        lbDuration.text = [self getStringFromCMTime:duration];
        seekSlider.value = CMTimeGetSeconds(elapsedTime)/ CMTimeGetSeconds(duration);        
        [self enableScrubber];
    }
}

-(NSString*)getStringFromCMTime:(CMTime)time
{
    Float64 currentSeconds = CMTimeGetSeconds(time);
    int mins = currentSeconds/60.0;
    int secs = fmodf(currentSeconds, 60.0);
    NSString *minsString = mins < 10 ? [NSString stringWithFormat:@"0%d", mins] : [NSString stringWithFormat:@"%d", mins];
    NSString *secsString = secs < 10 ? [NSString stringWithFormat:@"0%d", secs] : [NSString stringWithFormat:@"%d", secs];
    return [NSString stringWithFormat:@"%@:%@", minsString, secsString];
}

#pragma mark Seek

-(void)enableScrubber
{
    seekSlider.enabled = YES;
}

-(void)disableScrubber
{
    seekSlider.enabled = NO;
}

-(void) sliderBeganTracking:(UISlider *) slider {
    DLog(@"");
    [[_player currentItem] cancelPendingSeeks];
    [_player pause];
}

-(void) sliderValueChanged:(UISlider *) slider {
    CMTime seekTime = CMTimeMakeWithSeconds(slider.value * (double)_player.currentItem.duration.value/(double)_player.currentItem.duration.timescale, _player.currentTime.timescale);
    [self updateTimeLabel:seekTime duration:[self getPlayingItemDuration]];
}

-(void) sliderEndedTracking:(UISlider *) slider {
    DLog(@"");
    CMTime seekTime = CMTimeMakeWithSeconds(slider.value * (double)_player.currentItem.duration.value/(double)_player.currentItem.duration.timescale, _player.currentTime.timescale);
    
    [self updateTimeLabel:seekTime duration:_player.currentItem.duration];
    
    [self seekToTime:CMTimeGetSeconds(seekTime)];
}

-(CMTime) getPlayingItemDuration
{
    return _player.currentItem.duration;
}

-(void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _playerLayer.frame = self.view.bounds;    
}

#pragma mark - Public API

- (void)setURL:(NSURL *)URL
{
    if (URL == nil)
    {
        return;
    }
    
    [self resetPlayerItemIfNecessary];
    
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:URL];
    if (!playerItem)
    {
        [self reportUnableToCreatePlayerItem];
        
        return;
    }
    
    [self preparePlayerItem:playerItem];
}

- (void)setPlayerItem:(AVPlayerItem *)playerItem
{
    if (playerItem == nil)
    {
        return;
    }
    
    [self resetPlayerItemIfNecessary];
    
    [self preparePlayerItem:playerItem];
}

- (void)setAsset:(AVAsset *)asset
{
    if (asset == nil)
    {
        return;
    }
    
    [self resetPlayerItemIfNecessary];
    
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithAsset:asset automaticallyLoadedAssetKeys:@[NSStringFromSelector(@selector(tracks))]];
    if (!playerItem)
    {
        [self reportUnableToCreatePlayerItem];
        
        return;
    }
    
    [self preparePlayerItem:playerItem];
}

- (void) hideDownloadButton:(BOOL) hidden
{
    [btDownload setHidden:hidden];
}

-(void) hideCaptionButton:(BOOL) hidden
{
    [btClosedCaption setHidden:hidden];
}

#pragma mark - Playback

- (void)play
{
    if (_player.currentItem == nil)
    {
        return;
    }
    
    playing = YES;
    
    if ([_player.currentItem status] == AVPlayerItemStatusReadyToPlay)
    {
        if (seekToZeroBeforePlay)
        {
            [self restart];
            seekToZeroBeforePlay = NO;
        }
        else
        {
            [_player play];
        }
    }
}

- (void)pause
{
    playing = NO;
    
    [_player pause];
}

- (void)seekToTime:(float)time
{
    DLog(@"");
    if (isSeeking)
    {
        return;
    }
    
    if (_player)
    {
        CMTime cmTime = CMTimeMakeWithSeconds(time, _player.currentTime.timescale);
        
        if (CMTIME_IS_INVALID(cmTime) || _player.currentItem.status != AVPlayerStatusReadyToPlay)
        {
            shouldSeekToTime = cmTime;
            return;
        }
        
        isSeeking = YES;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [_player seekToTime:cmTime completionHandler:^(BOOL finished) {
                
                if (playing) {
                    [self play];
                }
                seekToZeroBeforePlay = NO;
                isSeeking = NO;
                
                DLog(@"Seek completed");
            }];
        });
    }
}

- (void)reset
{
    [self pause];
    [self resetPlayerItemIfNecessary];
}

- (void)restart
{
    [_player seekToTime:kCMTimeZero toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
        
        if (finished)
        {
            seekToZeroBeforePlay = NO;
            
            if (playing)
            {
                [self play];
            }
        }
        
    }];
}

#pragma mark IBAction

- (IBAction)onPlay:(id)sender {
    BOOL isPlaying = [self isPlaying];
    if (isPlaying) {
        [self pause];
    }else{
        [self play];
    }
    
    [self showControlsAndHiddenControlsAfter:kDurationToHideContol];
}
- (IBAction)onClose:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(myCustomPlayer:didTapOnClose:)]) {
        [self.delegate myCustomPlayer:self didTapOnClose:sender];
    }
}
- (IBAction)onDowload:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(myCustomPlayer:didTapOnDownload:)]) {
        [self.delegate myCustomPlayer:self didTapOnDownload:sender];
    }
}

- (IBAction)onShowCaption:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(myCustomPlayer:didTapOnClosedCaption:)]) {
        [self.delegate myCustomPlayer:self didTapOnClosedCaption:sender];
    }
}

#pragma mark dealloc
-(void) dealloc
{
    DLog(@"");
    [self resetPlayerItemIfNecessary];
    [self removePlayerObservers];
    [self removeTimeObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end