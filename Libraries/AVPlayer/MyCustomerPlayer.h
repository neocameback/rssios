//
//  MyCustomerPlayer.h
//  TestAVPlayer
//
//  Created by GEM on 5/4/16.
//  Copyright © 2016 GEM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class MyCustomerPlayer;
@protocol MyCustomerPlayerDelegate <NSObject>

@optional
-(void) myCustomPlayerFinishedPlayback:(MyCustomerPlayer *) view;
-(void) myCustomPlayer:(MyCustomerPlayer *) playerView didTapOnClose:(id) sender;
-(void) myCustomPlayer:(MyCustomerPlayer *) playerView didTapOnDownload:(id) sender;


-(void) myCustomPlayerprepareToPlay:(MyCustomerPlayer *) playerView;
-(void) myCustomPlayerReadyToPlay:(MyCustomerPlayer *) playerView;
-(void) myCustomPlayer:(MyCustomerPlayer *) playerView didFailWithError:(NSError *) error;
@end

@interface MyCustomerPlayer : UIViewController <UIGestureRecognizerDelegate>
{
    AVPlayerLayer *_playerLayer;
    AVPlayer *_player;
    AVPlayerItem *_playerItem;
    
    id timeObserver;
    BOOL isSeeking;
    BOOL seekToZeroBeforePlay;
    BOOL playing;
    
    /// action buttons
    __weak IBOutlet UIButton *btClose;
    __weak IBOutlet UIButton *btDownload;
    
    /// view over lay
    __weak IBOutlet UIView *viewOverlay;
    __weak IBOutlet UIView *viewHeader;
    __weak IBOutlet UIView *viewFooter;
    __weak IBOutlet UIActivityIndicatorView *loadingIndicator;
    
    __weak IBOutlet UIButton *btPlay;
    
    __weak IBOutlet UILabel *lbElapsedTime;
    __weak IBOutlet UILabel *lbDuration;
    __weak IBOutlet UISlider *seekSlider;
    
}
- (void)setURL:(NSURL *)URL;
- (void)setPlayerItem:(AVPlayerItem *)playerItem;
- (void)setAsset:(AVAsset *)asset;

- (void) hideDownloadButton;
// Playback
- (void)play;
- (void)pause;
- (void)seekToTime:(float)time;
- (void)reset;

/**
 *  delegate
 */
@property (nonatomic, weak) id<MyCustomerPlayerDelegate> delegate;
@end

