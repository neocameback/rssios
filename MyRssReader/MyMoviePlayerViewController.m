//
//  MyMoviePlayerViewController.m
//  clickplay
//
//  Created by Developer on 9/7/13.
//  Copyright (c) 2013 Developer. All rights reserved.
//

#import "MyMoviePlayerViewController.h"

@interface MyMoviePlayerViewController ()
{
    UIButton *centerButton;
    UIButton *backButton;
    UIButton *settingButton;
    UISlider *playerSlider;
    UIView *playerControlView;
    UIView *playerSettingView;
    UILabel *currentTimeLabel;
    UILabel *endTimeLabel;
    float landScapeScreenWidth;
    float landScapeScreenHeight;
    NSTimer *timer ;
    NSTimer *autohide;
    UIView *topbarBG;
    UIView *bottombarBG;
    UIImageView *subtitleView;
    UIActivityIndicatorView *loadingButton;
    BOOL isinit;
    double lastControlTime;
    UITapGestureRecognizer *tapGesture;
    UITapGestureRecognizer *tapGesture2;
    NSTimeInterval lastViewTime;
    int initX;
    int initY;
    
}
-(void)initUI;
-(void)updateSlider;
-(NSString *)secondsToMMSS:(double)seconds;
-(void)onClick:(UIButton *)sender;
-(void)preloadDid:(NSNotification *)notification;
-(void)handleSingleTap:(UITapGestureRecognizer *)recognizer;
-(void)showPlayerControl;
-(void)hidePlayerControl;
@end
static bool isSilderTouched;
static bool isControlViewShowed;
static bool isSubtitleInit;
@implementation MyMoviePlayerViewController
#define myFont @"HelveticaNeue-Bold"
#define myFontBlack @"HelveticaNeue-CondensedBlack"
#define tableName @"InfoPlist"
@synthesize title;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isSilderTouched = NO;
    isSubtitleInit = NO;
    [self.moviePlayer setControlStyle:MPMovieControlStyleNone];
    isinit = NO;
    [self initUI];
    isControlViewShowed = YES;
    [self hidePlayerControl];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(movieFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(preloadDid:) name:MPMoviePlayerLoadStateDidChangeNotification object:self.moviePlayer];
    tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTap:)];
    tapGesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTap:)];
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"viewDidAppear");
    [super viewDidAppear:animated];
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
    autohide = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(autoHidePlayerControl) userInfo:nil repeats:YES];
    [playerSlider addTarget:self action:@selector(sliderMoveStart) forControlEvents:UIControlEventTouchDown];
    [playerSlider addTarget:self action:@selector(sliderMoving) forControlEvents:UIControlEventTouchDragInside];
    [playerSlider addTarget:self action:@selector(sliderMoveEnd) forControlEvents:UIControlEventTouchUpInside];
    [centerButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [backButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [playerControlView addGestureRecognizer:tapGesture];
    [playerSlider addGestureRecognizer:tapGesture2];
    lastControlTime = CFAbsoluteTimeGetCurrent();
}
-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"viewWillDisappear");
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:self.moviePlayer];
    [timer invalidate];
    [autohide invalidate];
    [playerSlider removeTarget:self action:@selector(sliderMoveStart) forControlEvents:UIControlEventTouchDown];
    [playerSlider removeTarget:self action:@selector(sliderMoving) forControlEvents:UIControlEventTouchDragInside];
    [playerSlider removeTarget:self action:@selector(sliderMoveEnd) forControlEvents:UIControlEventTouchUpInside];
    [centerButton removeTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [backButton removeTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [playerControlView removeGestureRecognizer:tapGesture];
    [playerSlider removeGestureRecognizer:tapGesture2];
    //    [MyURLProtocol removeProtocol];
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initUI
{
    //custome player control bar top/bottom
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    landScapeScreenHeight =  screenRect.size.width;
    landScapeScreenWidth =screenRect.size.height;
    playerControlView = [[UIView alloc]initWithFrame:CGRectMake(0,0,landScapeScreenWidth,landScapeScreenHeight)];
    subtitleView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,landScapeScreenWidth,landScapeScreenHeight)];
    playerSettingView = [[UIView alloc]initWithFrame:CGRectMake(landScapeScreenWidth, 40.0f, 80, landScapeScreenHeight-80)];
    [playerSettingView setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.7]];
    //    [subtitleView setBackgroundColor:[UIColor blueColor]];
    // TOP
    topbarBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, landScapeScreenWidth, 40)];
    [topbarBG setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.7]];
    UILabel *topbarText = [[UILabel alloc]initWithFrame:CGRectMake(60, 6, landScapeScreenWidth-60-10, 27)];
    topbarText.font = [UIFont fontWithName:myFont size:18];
    topbarText.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"now_playing", tableName, nil),title];
    [topbarText setBackgroundColor:[UIColor clearColor]];
    [topbarText setTextColor:[UIColor whiteColor]];
    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(10, 05, 40, 30);
    [backButton setBackgroundColor:[UIColor blackColor]];
    [backButton setContentEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 10)];
//    [backButton setImage:[UIImage imageNamed:@"header_back.png"] forState:UIControlStateNormal];
//    [backButton setBackgroundImage:[UIImage imageNamed:@"header_btn_up.png"] forState:UIControlStateNormal];
    [backButton setTitle:@"Done" forState:UIControlStateNormal];
    settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    settingButton.frame = CGRectMake(landScapeScreenWidth-50, 5 , 40, 30);
    [settingButton setImageEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 10)];
//    [settingButton setImage:[UIImage imageNamed:@"icon_language.png"] forState:UIControlStateNormal];
//    [settingButton setBackgroundImage:[UIImage imageNamed:@"header_btn_up.png"] forState:UIControlStateNormal];
    [settingButton setTitle:@"Settings" forState:UIControlStateNormal];
    [topbarBG addSubview:topbarText];
    [topbarBG addSubview:backButton];
    [topbarBG addSubview:settingButton];
    
    //Bottom
    bottombarBG = [[UIView alloc] initWithFrame:CGRectMake(0, landScapeScreenHeight - 40, landScapeScreenWidth, 40)];
    [bottombarBG setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.7]];
    
    
    // 1
    // Make the slider as a public propriety so you can access it
    playerSlider = [[UISlider alloc] init];
    [playerSlider setContinuous:YES];
    [playerSlider setHighlighted:YES];
    // remove the slider filling default blue color
    [playerSlider setMaximumTrackTintColor:[UIColor colorWithRed:193.0f/255.0f green:193.0f/255.0f blue:193.0f/255.0f alpha:1]];
    [playerSlider setMinimumTrackTintColor:[UIColor colorWithRed:11.0f/255.0f green:156.0f/255.0f blue:231.0f/255.0f alpha:1]];
    playerSlider.frame = CGRectMake(landScapeScreenWidth*0.1f, 0, landScapeScreenWidth*0.8f , 22);
    currentTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, landScapeScreenWidth*0.1f-2, 24)];
    endTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(landScapeScreenWidth*0.9f+2, 0, landScapeScreenWidth*0.1f-2, 24)];
    [currentTimeLabel setBackgroundColor:[UIColor clearColor]];
    currentTimeLabel.textAlignment = NSTextAlignmentRight;
    [endTimeLabel setBackgroundColor:[UIColor clearColor]];
    currentTimeLabel.font = [UIFont fontWithName:myFont size:14];
    endTimeLabel.font = [UIFont fontWithName:myFont size:14];
    [currentTimeLabel setTextColor:[UIColor whiteColor]];
    [endTimeLabel setTextColor:[UIColor whiteColor]];
    [bottombarBG addSubview:currentTimeLabel];
    [bottombarBG addSubview:endTimeLabel];
    [bottombarBG addSubview:playerSlider];
    
    loadingButton = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    loadingButton.center = CGPointMake(playerControlView.bounds.size.width/ 2.0f, playerControlView.bounds.size.height/ 2.0);
    [loadingButton startAnimating];
    centerButton = [[UIButton alloc]initWithFrame:CGRectMake((landScapeScreenWidth-55)/2, (landScapeScreenHeight-55)/2, 55, 55)];
//    [centerButton setImage:[UIImage imageNamed:@"player_pause.png"] forState:UIControlStateNormal];
//    [centerButton setImage:[UIImage imageNamed:@"player_play.png"] forState:UIControlStateSelected];
    [centerButton setTitle:@"Pause" forState:UIControlStateNormal];
    [centerButton setTitle:@"Play" forState:UIControlStateSelected];
    [centerButton setBackgroundColor:[UIColor clearColor]];
    [playerControlView addSubview:centerButton];
    [playerControlView addSubview:loadingButton];
    [self.view addSubview:subtitleView];
    [self.view addSubview:playerControlView];
    [self.view addSubview:topbarBG];
    [self.view addSubview:bottombarBG];
    [self.view addSubview:playerSettingView];
}
-(void)sliderMoveStart{
    
    isSilderTouched = YES;
    
}
-(void)sliderMoving{
    lastControlTime = CFAbsoluteTimeGetCurrent();
    isSilderTouched = YES;
    double time = self.moviePlayer.duration * playerSlider.value;
    currentTimeLabel.text = [self secondsToMMSS:time];
}
-(void)sliderMoveEnd
{
    self.moviePlayer.currentPlaybackTime = self.moviePlayer.duration * playerSlider.value;
}
-(void)updateSlider {
    
    // Update the slider about the video time
    if(!isSilderTouched){
        float value = self.moviePlayer.currentPlaybackTime/self.moviePlayer.duration;
        [playerSlider setValue: value animated:YES]; // based on ur case
        currentTimeLabel.text = [self secondsToMMSS:self.moviePlayer.currentPlaybackTime];
    }
}

-(void)preloadDid:(NSNotification *)notification
{
    NSLog(@"preload");
    isSilderTouched = NO;
    currentTimeLabel.text = [self secondsToMMSS:self.moviePlayer.currentPlaybackTime];
    if(!isinit){
        loadingButton.hidden =TRUE;
        isinit =YES;
        endTimeLabel.text = [self secondsToMMSS:self.moviePlayer.duration];
    }
    [self.moviePlayer play];
}
-(void)movieFinishedCallback:(NSNotification *) notification
{
//    [MyURLProtocol removeProtocol];
    NSNumber *reason = [[notification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    switch ([reason integerValue])
    {
            /* The end of the movie was reached. */
        case MPMovieFinishReasonPlaybackEnded:
            /*
             Add your code here to handle MPMovieFinishReasonPlaybackEnded.
             */
            NSLog(@"Movieplayer is stopped");
            break;
            
            /* An error was encountered during playback. */
        case MPMovieFinishReasonPlaybackError:
            NSLog(@"An error was encountered during playback");
            //            [self performSelectorOnMainThread:@selector(displayError:) withObject:[[notification userInfo] objectForKey:NSLocalizedStringFromTable(@"error", tableName, nil)] waitUntilDone:NO];
            break;
            
            /* The user stopped playback. */
        case MPMovieFinishReasonUserExited:
            NSLog(@"userExtied");
            break;
            
        default:
            break;
    }
    
}
-(void)displayError:(NSError *)theError
{
    if (theError)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Error"
                              message: [theError localizedDescription]
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}
-(void)onClick:(UIButton *)sender
{
    if(sender == centerButton){
        lastControlTime = CFAbsoluteTimeGetCurrent();
        if(sender.selected){
            [self.moviePlayer play];
            sender.selected = FALSE;
        }else{
            [self.moviePlayer pause];
            sender.selected = TRUE;
        }
    }else if(sender == backButton){
        NSLog(@"back clicked");
        [self.moviePlayer stop];
        [self dismissMoviePlayerViewControllerAnimated];
        [timer invalidate];
    }
    
}
-(void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"handleSingleTap: %@",recognizer.view.class.description);
    if(recognizer.view == playerControlView){
        NSLog(@"CONTROLVIEW CLICKED");
        if(isControlViewShowed){
            [UIView animateWithDuration:0.5 animations:^{
                [self hidePlayerControl];
            }];
        }
        else{
            lastControlTime = CFAbsoluteTimeGetCurrent();
            [UIView animateWithDuration:0.5 animations:^{
                [self showPlayerControl];
            }];
        }
        
    }else if(recognizer.view == playerSlider){
        isSilderTouched = YES;
        lastControlTime = CFAbsoluteTimeGetCurrent();
        CGPoint translation = [recognizer locationInView:recognizer.view];
        float rate = translation.x / (landScapeScreenWidth*0.8f);
        playerSlider.value = rate;
        self.moviePlayer.currentPlaybackTime = self.moviePlayer.duration * rate;
        currentTimeLabel.text = [self secondsToMMSS:self.moviePlayer.currentPlaybackTime];
        NSLog(@"handleSingleTap; %f",translation.x);
        
        
        NSLog(@"click outside");
    }
    
}
-(void)hidePlayerControl
{
    if(isControlViewShowed){
        CGRect btmFrame = bottombarBG.frame;
        btmFrame.origin.y = landScapeScreenHeight;
        bottombarBG.frame = btmFrame;
        bottombarBG.alpha = 0.2;
        
        CGRect topFrame = topbarBG.frame;
        topFrame.origin.y = 0 - topFrame.size.height;
        topbarBG.frame = topFrame;
        topbarBG.alpha = 0.2;
        centerButton.alpha = 0;
        
        CGRect playSetframe = playerSettingView.frame;
        if(playSetframe.origin.x != landScapeScreenWidth)
        {
            playSetframe.origin.x = landScapeScreenWidth;
            playerSettingView.frame = playSetframe;
        }
        isControlViewShowed = NO;
    }
    
}
-(void)autoHidePlayerControl
{
    float duration = CFAbsoluteTimeGetCurrent() - lastControlTime;
    if(isControlViewShowed && duration> 5){
        [UIView animateWithDuration:0.5 animations:^{
            [self hidePlayerControl];
            isControlViewShowed = NO;
        }];
    }
}
-(void)showPlayerControl
{
    CGRect btmFrame = bottombarBG.frame;
    btmFrame.origin.y = landScapeScreenHeight - btmFrame.size.height;
    bottombarBG.frame = btmFrame;
    bottombarBG.alpha = 1;
    
    CGRect topFrame = topbarBG.frame;
    topFrame.origin.y = 0;
    topbarBG.frame = topFrame;
    topbarBG.alpha = 1;
    centerButton.alpha = 1;
    
    isControlViewShowed = YES;
}

-(NSString *)secondsToMMSS:(double)seconds
{
    NSInteger time = floor(seconds);
    NSInteger hh = time / 3600;
    NSInteger mm = (time / 60) % 60;
    NSInteger ss = time % 60;
    if(hh > 0)
        return  [NSString stringWithFormat:@"%d:%02i:%02i",hh,mm,ss];
    else
        return  [NSString stringWithFormat:@"%02i:%02i",mm,ss];
}

-(void)ShowSettingView
{
    lastControlTime = CFAbsoluteTimeGetCurrent();
    CGRect frame = playerSettingView.frame;
    if(frame.origin.x == landScapeScreenWidth-80){
        frame.origin.x = landScapeScreenWidth;
    }else{
        frame.origin.x = landScapeScreenWidth-80;
    }
    [UIView animateWithDuration:0.25 animations:^{
        playerSettingView.frame = frame;
    }];
    
    
}

@end
