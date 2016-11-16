//
//  AirPlayerViewController.m
//  MyRssReader
//
//  Created by GEM on 6/17/16.
//  Copyright © 2016 Huyns. All rights reserved.
//

#import "AirPlayerViewController.h"
#import "DownloadManager.h"
#import "MyCustomerPlayer.h"
#import "ASBPlayerSubtitling.h"
#import "SubtitleSelectionViewController.h"
#import <GoogleCast/GoogleCast.h>
#import "Toast.h"
#import "SubtitleModel.h"

@interface AirPlayerViewController () <MyCustomerPlayerDelegate,
                                SubtitleSelectionViewControllerDelegate>
@property (strong, nonatomic) IBOutlet ASBPlayerSubtitling *subtitling;
@property (nonatomic, strong) MyCustomerPlayer *myPlayer;

@property (nonatomic, strong) File *localFile; // play the downloaded file if have
@property (nonatomic, strong) NSMutableArray *subtitleModels; // list all of sutitle of the video
@property (nonatomic) NSInteger selectedSubtitleIndex;
@end

@implementation AirPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self initVideoPlayer];
    
    if (self.currentNode) {
        _localFile = [File MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"url == %@ AND progress == 100", self.currentNode.nodeUrl] sortedBy:@"url" ascending:YES];
        if (_localFile) {
            NSString *path = [_localFile getFilePath];
            [self.myPlayer setURL:[NSURL fileURLWithPath:path]];
            [self.myPlayer play];
        }else{
            [self.myPlayer setURL:[NSURL URLWithString:self.currentNode.nodeUrl]];
            [self.myPlayer play];
        }
        /**
         *  hide download button
         */
        if ([Common typeOfNode:self.currentNode.nodeType] == NODE_TYPE_MP4 && !_localFile) {
            [self.myPlayer hideDownloadButton:NO];
        }else{
            [self.myPlayer hideDownloadButton:YES];
        }
        
    }
    [self loadDefaultSubtitle];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.myPlayer.player.status == AVPlayerStatusReadyToPlay) {
        [self.myPlayer play];
    }
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

-(void) loadDefaultSubtitle
{
    _subtitleModels = [NSMutableArray array];
    if (_localFile) {
        for (Subtitle *subtitle in _localFile.subtitlesSet) {
            SubtitleModel *subModel = [[SubtitleModel alloc] initWithSubtitle:subtitle];
            [_subtitleModels addObject:subModel];
        }
        
    }else{
        for (MWFeedItemSubTitle *subtitle in _currentNode.subtitles) {
            SubtitleModel *subModel = [[SubtitleModel alloc] initWithMWFeedItemSubtitle:subtitle];
            [_subtitleModels addObject:subModel];
        }
    }
    [self loadSubtitleAtIndex:0];    
}

- (void)loadSubtitleAtIndex:(NSInteger)index {
    if (_subtitleModels.count > 0) {
        // mark the loading sub index
        _selectedSubtitleIndex = index;
        // load subtitle to player
        SubtitleModel *subModel = self.subtitleModels[_selectedSubtitleIndex];
        NSError *error = nil;
        NSURL *subUrl = nil;
        if (subModel.link && subModel.link.length > 0) {
            subUrl = [NSURL URLWithString:subModel.link];
        } else if (subModel.filePath && subModel.filePath.length > 0) {
            subUrl = [NSURL fileURLWithPath:subModel.filePath];
        }
        if (subUrl) {
            self.subtitling.player = self.myPlayer.player;
            [self.subtitling loadSubtitlesType:subModel.type atURL:subUrl error:&error];
            if (error) {
                ALERT_WITH_TITLE(@"Error", error.localizedDescription);
            }else{
                [self.myPlayer play];
            }
        } else {
            ALERT_WITH_TITLE(@"Error", @"Subtitle is not available!");
        }
        
        self.subtitling.containerView.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
        [self.myPlayer hideCaptionButton:NO];
        viewSubtitle.hidden = NO;
    } else {
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
-(void) myCustomPlayer:(MyCustomerPlayer *) playerView didTapOnDownload:(id) sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    if ( [alertController respondsToSelector:@selector(popoverPresentationController)] ) {
        // iOS8
        alertController.popoverPresentationController.sourceView = sender;
    }
    UIAlertAction *enterNameAction = [UIAlertAction actionWithTitle:@"New name" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showAlertEnterFileName];
    }];
    UIAlertAction *defaultNameAction = [UIAlertAction actionWithTitle:@"Use default" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[DownloadManager shareManager] downloadNode:self.currentNode withName:self.rssTitle fromView:self];
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
    [viewcontroller setSubtitleModels:_subtitleModels];
    [viewcontroller setSelectedSubtitleIndex:_selectedSubtitleIndex];
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
    
    if (hasConnectedCastSession && [Common typeOfNode:self.currentNode.nodeType] == NODE_TYPE_MP4) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Chrome Cast" message:@"Cast your video to Chrome Cast" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Cast now" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self castMediaInfo:[Common mediaInformationFromNode:self.currentNode]];
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
-(void) subtitleSelectionViewController:(SubtitleSelectionViewController *)viewcontroller
               didSelectSubtitleAtIndex:(NSInteger)index {
    if (index == SubtitleIndexNone) {
        _selectedSubtitleIndex = index;
        [self.subtitling removeSubtitles];
        [self.myPlayer play];
    } else {
        [self loadSubtitleAtIndex:index];
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
