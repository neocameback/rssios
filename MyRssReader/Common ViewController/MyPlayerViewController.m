//
//  MyPlayerViewController.m
//  MyRssReader
//
//  Created by GEM on 6/17/16.
//  Copyright © 2016 Huyns. All rights reserved.
//

#import "MyPlayerViewController.h"
#import "DownloadManager.h"
#import "MyCustomerPlayer.h"
#import "ASBPlayerSubtitling.h"
#import "SubtitleSelectionViewController.h"

@interface MyPlayerViewController () <MyCustomerPlayerDelegate, SubtitleSelectionViewControllerDelegate>
@property (strong, nonatomic) IBOutlet ASBPlayerSubtitling *subtitling;
@property (nonatomic, strong) MyCustomerPlayer *myPlayer;
@end

@implementation MyPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self initVideoPlayer];
    
    if (self.currentNode) {
        _downloadedFile = [File MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"url == %@ AND progress == 100", self.currentNode.nodeUrl] sortedBy:@"url" ascending:YES];
        if (_downloadedFile) {
            NSString *path = [_downloadedFile getFilePath];
            [self.myPlayer setURL:[NSURL fileURLWithPath:path]];
            [self.myPlayer play];
        }else{
            [self.myPlayer setURL:[NSURL URLWithString:self.currentNode.nodeUrl]];
            [self.myPlayer play];
        }
    }else{
        NSString *path = [_downloadedFile getFilePath];
        [self.myPlayer setURL:[NSURL fileURLWithPath:path]];
        [self.myPlayer play];
    }
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
    if (_downloadedFile) {
        [self.myPlayer hideDownloadButton:YES];
        
        if (_downloadedFile.subtitlesSet.count > 0) {
            /**
             *  add example subtitle
             */
            NSURL *subtitlesURL = [NSURL fileURLWithPath:[_downloadedFile.subtitlesSet.firstObject getFilePath]];
            NSError *error = nil;
            self.subtitling.player = [self.myPlayer player];
            [self.subtitling loadSubtitlesAtURL:subtitlesURL error:&error];
            self.subtitling.containerView.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
            
            [self.myPlayer hideCaptionButton:NO];
        }else{
            [self.myPlayer hideCaptionButton:YES];
        }
    }else{
        [self.myPlayer hideDownloadButton:NO];
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
-(void) myCustomPlayer:(MyCustomerPlayer *) playerView didTapOnDownload:(id) sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *enterNameAction = [UIAlertAction actionWithTitle:@"New name" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showAlertEnterFileName];
    }];
    UIAlertAction *defaultNameAction = [UIAlertAction actionWithTitle:@"Use default" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[DownloadManager shareManager] downloadNode:self.currentNode withName:nil fromView:self];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:enterNameAction];
    [alertController addAction:defaultNameAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void) myCustomPlayer:(MyCustomerPlayer *)playerView didTapOnClosedCaption:(id)sender
{
    SubtitleSelectionViewController *viewcontroller = [[SubtitleSelectionViewController alloc] initWithNibName:NSStringFromClass([SubtitleSelectionViewController class]) bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewcontroller];
    [viewcontroller setDownloadedFile:_downloadedFile];
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

#pragma mark uialertview delegate
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case ALERT_ENTER_FILE_NAME:
        {
            if (buttonIndex != alertView.cancelButtonIndex) {
                NSString *name = [alertView textFieldAtIndex:0].text;
                name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                if (!name || name.length == 0) {
                    ALERT_WITH_TITLE(@"", @"Name cannot be empty");
                }else{
                    [[DownloadManager shareManager] downloadNode:self.currentNode withName:name fromView:self];
                }
            }
        }
            break;
            
        case ALERT_NAME_EXIST:
        {
            if (buttonIndex != alertView.cancelButtonIndex) {
                [self showAlertEnterFileName];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark SubtitleSelectionViewControllerDelegate
-(void) subtitleSelectionViewController:(SubtitleSelectionViewController *)viewcontroller didSelectSubWithUrl:(NSString *)url
{
    if (!url) {
        [self.subtitling removeSubtitles];
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

-(void) dealloc
{
    DLog(@"");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_myPlayer reset];
    _myPlayer = nil;
}
@end
