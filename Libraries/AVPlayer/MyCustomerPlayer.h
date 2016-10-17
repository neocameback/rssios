//
//  MyCustomerPlayer.h
//  TestAVPlayer
//
//  Created by GEM on 5/4/16.
//  Copyright © 2016 GEM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <GoogleCast/GoogleCast.h>

@class MyCustomerPlayer;
@protocol MyCustomerPlayerDelegate <NSObject>

@optional
-(void) myCustomPlayerFinishedPlayback:(MyCustomerPlayer *) view;
-(void) myCustomPlayer:(MyCustomerPlayer *) playerView didTapOnClose:(id) sender;
-(void) myCustomPlayer:(MyCustomerPlayer *) playerView didTapOnDownload:(id) sender;
-(void) myCustomPlayer:(MyCustomerPlayer *) playerView didTapOnClosedCaption:(id) sender;
-(void) myCustomPlayer:(MyCustomerPlayer *) playerView didTapOnCastButton:(id) sender;

-(void) myCustomPlayerprepareToPlay:(MyCustomerPlayer *) playerView;
-(void) myCustomPlayerReadyToPlay:(MyCustomerPlayer *) playerView;
-(void) myCustomPlayer:(MyCustomerPlayer *) playerView didFailWithError:(NSError *) error;

- (BOOL)continueAfterPlayButtonClicked;
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
    __weak IBOutlet UIButton *btClosedCaption;
    __weak IBOutlet GCKUICastButton *castButton;
    
    /// view over lay
    __weak IBOutlet UIView *viewOverlay;
    __weak IBOutlet UIView *viewHeader;
    __weak IBOutlet UIView *viewFooter;
    __weak IBOutlet UIActivityIndicatorView *loadingIndicator;
    __weak IBOutlet UILabel *lbPlayerRate;
    
    __weak IBOutlet UIButton *btPlay;
    
    __weak IBOutlet UILabel *lbElapsedTime;
    __weak IBOutlet UILabel *lbDuration;
    __weak IBOutlet UISlider *seekSlider;    
}
- (void)setURL:(NSURL *)URL;
- (void)setPlayerItem:(AVPlayerItem *)playerItem;
- (void)setAsset:(AVAsset *)asset;

- (void) hideDownloadButton:(BOOL) hidden;
- (void) hideCaptionButton:(BOOL) hidden;
- (void)setCastButtonHidden:(BOOL)hidden;

// Playback
- (void)play;
- (void)pause;
- (void)seekToTime:(float)time;
- (void)reset;

/**
 *  delegate
 */
@property (nonatomic, weak) id<MyCustomerPlayerDelegate> delegate;
-(AVPlayer *) player;
@end

