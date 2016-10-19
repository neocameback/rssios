//
//  AirPlayerViewController.m
//  MyRssReader
//
//  Created by GEM on 6/17/16.
//  Copyright © 2016 Huyns. All rights reserved.
//

#import "LocalPlayerViewController.h"
#import "DownloadManager.h"
#import "MyCustomerPlayer.h"
#import "ASBPlayerSubtitling.h"
#import "SubtitleSelectionViewController.h"
#import <GoogleCast/GoogleCast.h>

@interface LocalPlayerViewController () <MyCustomerPlayerDelegate, SubtitleSelectionViewControllerDelegate>
@property (strong, nonatomic) IBOutlet ASBPlayerSubtitling *subtitling;
@property (nonatomic, strong) MyCustomerPlayer *myPlayer;

@end

@implementation LocalPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self initVideoPlayer];
    
    NSString *path = [_downloadedFile getFilePath];
    [self.myPlayer setURL:[NSURL fileURLWithPath:path]];
    [self.myPlayer play];
    /**
     *  hide download button
     */
    [self.myPlayer hideDownloadButton:YES];
    [self loadSubtitle];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    /**
     *  pause the player when view is disappear
     */
    if (self.myPlayer) {
        [self.myPlayer pause];
    }
}

-(void)appWillResignActive:(NSNotification*)note
{
    /**
     *  pause the player when app resign active
     */
    if (self.myPlayer) {
        [self.myPlayer pause];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) initVideoPlayer
{
    self.myPlayer = [self videoPlayer];
    [self addChildViewController:self.myPlayer];
    [self.view addSubview:self.myPlayer.view];
    [self.view sendSubviewToBack:self.myPlayer.view];
    [self.myPlayer.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [self.myPlayer.view autoPinToTopLayoutGuideOfViewController:self withInset:0];
    [self.myPlayer didMoveToParentViewController:self];
    [self.myPlayer setDelegate:self];
}

-(void) loadSubtitle
{
    if (_downloadedFile.subtitlesSet.count > 0) {
        NSURL *subtitlesURL = [NSURL fileURLWithPath:[_downloadedFile.subtitlesSet.firstObject getFilePath]];
        _currentSubtitleURL = [_downloadedFile.subtitlesSet.firstObject getFilePath];
        NSError *error = nil;
        self.subtitling.player = [self.myPlayer player];
        [self.subtitling loadSubtitlesAtURL:subtitlesURL error:&error];
        self.subtitling.containerView.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
        
        [self.myPlayer hideCaptionButton:NO];
        viewSubtitle.hidden = NO;
    }else{
        [self.myPlayer hideCaptionButton:YES];
        viewSubtitle.hidden = YES;
    }
}

-(MyCustomerPlayer *) videoPlayer
{
    MyCustomerPlayer *videoPlayer = [[MyCustomerPlayer alloc] init];
    return videoPlayer;
}
#pragma mark MyCustomerPlayerDelegate
-(void) myCustomPlayerFinishedPlayback:(MyCustomerPlayer *) view;
{
    
}
-(void) myCustomPlayer:(MyCustomerPlayer *) playerView didTapOnClose:(id) sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) myCustomPlayer:(MyCustomerPlayer *)playerView didTapOnClosedCaption:(id)sender
{
    SubtitleSelectionViewController *viewcontroller = [[SubtitleSelectionViewController alloc] initWithNibName:NSStringFromClass([SubtitleSelectionViewController class]) bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewcontroller];
    [viewcontroller setDownloadedFile:_downloadedFile];
    [viewcontroller setCurrentNode:nil];
    [viewcontroller setCurrentSubtitleURL:_currentSubtitleURL];
    [viewcontroller setDelegate:self];
    [self presentViewController:nav animated:YES completion:nil];
}

-(void) myCustomPlayerprepareToPlay:(MyCustomerPlayer *) playerView
{
    
}
-(void) myCustomPlayerReadyToPlay:(MyCustomerPlayer *) playerView
{
    
}
-(void) myCustomPlayer:(MyCustomerPlayer *) playerView didFailWithError:(NSError *) error
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (BOOL)continueAfterPlayButtonClicked {
    BOOL hasConnectedCastSession =
    [GCKCastContext sharedInstance].sessionManager.hasConnectedCastSession;
    
    if (hasConnectedCastSession) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Chrome Cast" message:@"Cast your video to Chrome Cast" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Cast now" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self castMediaInfo:[Common mediaInformationFromFile:_downloadedFile]];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        return NO;
    } else {
        return YES;
    }
}

-(void) showAlertEnterFileName
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Download video" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Download", nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [[alert textFieldAtIndex:0] setPlaceholder:@"Put file name here."];
    [[alert textFieldAtIndex:0] setClearButtonMode:UITextFieldViewModeWhileEditing];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    [label setText:@"*"];
    [label setTextColor:[UIColor redColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    [[alert textFieldAtIndex:0] setRightViewMode:UITextFieldViewModeAlways];
    [[alert textFieldAtIndex:0] setRightView:label];
    [[alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeASCIICapable];
    [[alert textFieldAtIndex:0] setClearButtonMode:UITextFieldViewModeWhileEditing];
    [alert setTag:ALERT_ENTER_FILE_NAME];
    [alert show];
}

#pragma mark SubtitleSelectionViewControllerDelegate
-(void) subtitleSelectionViewController:(SubtitleSelectionViewController *)viewcontroller didSelectSubWithFileURL:(NSString *)url
{
    _currentSubtitleURL = url;
    if (!url) {
        [self.subtitling removeSubtitles];
        
        [self.myPlayer play];
    }else{
        NSError *error = nil;
        [self.subtitling loadSubtitlesAtURL:[NSURL fileURLWithPath:url] error:&error];
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }else{
            [self.myPlayer play];
        }
    }
}

-(void) subtitleSelectionViewController:(SubtitleSelectionViewController *)viewcontroller didSelectSubWithStringURL:(NSString *)url
{
    _currentSubtitleURL = url;
    if (!url) {
        [self.subtitling removeSubtitles];
        
        [self.myPlayer play];
    }else{
        NSError *error = nil;
        [self.subtitling loadSubtitlesAtURL:[NSURL URLWithString:url] error:&error];
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }else{
            [self.myPlayer play];
        }
    }
}

-(void) dealloc
{
    DLog(@"");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_myPlayer reset];
    _myPlayer = nil;
}
@end
