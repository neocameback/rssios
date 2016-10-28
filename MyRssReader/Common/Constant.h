//
//  Constant.h
//  MyRssReader
//
//  Created by Huyns89 on 5/27/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kNotificationShouldReloadRssList    @"should_reload_rss"
#define kNotificationDownloadOperationStarted @"downloadOperationStarted"
#define kNotificationDownloadOperationCompleted @"downloadOperationCompleted"

#define kRequestTimeOut                 60
#define kSecondsToPresentInterstitial   120
#define kAutoRefreshNewsTime                 @"auto_refresh_news_time"
#define kLastOpenFullScreen @"last_open_full_screen"

#define GET_IP_ADDRESS      @"http://ip-api.com/json"
#define kDefaultRssUrl      @"http://rssvideochannel.com/sample.xml"
#define kDefaultMd5Prefix   @"RssVideoChannel-Hanoi102016-"

#define kDefaultShareTitle  @"Rss video channel\nhttp://rssvideochannel.com/"
#define kAboutUrl           @"http://rssvideochannel.com/about.html"
#define POST_HANDLE_URL     @"http://rssvideochannel.com/api/crawl.php"

#define kGoogleAnalyticId   @"UA-51537954-1"

#define kLargeAdUnitId  @"ca-app-pub-8422191650855912/4957456186"

#define kBannerAdUnitID     @"ca-app-pub-8422191650855912/2270603386"
#define kBannerAdUnitID2    @"ca-app-pub-8422191650855912/3747336585"
#define kBannerAdUnitID3    @"ca-app-pub-8422191650855912/5084468982"

#define kStringLoading  @"Loading"
#define kStringLoadingTapToCancel  @"Loading...\n(Tap to cancel)"
#define kMessageInternetConnectionLost  @"Internet connection was lost!"
#define kUserAgent      @"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.155 Safari/537.36"

#define kGreenColor [UIColor colorWithRed:0/255 green:204.0/255 blue:151.0/255 alpha:1]
#define kNavigationColor    [UIColor colorWithHexString:@"31708f"]
enum NODE_TYPE {
    NODE_TYPE_RSS = 0,
    NODE_TYPE_VIDEO = 1,
    NODE_TYPE_MP4 = 2,
    NODE_TYPE_YOUTUBE = 3,
    NODE_TYPE_DAILYMOTION = 4,
    NODE_TYPE_WEB = 5,
    NODE_TYPE_WEB_CONTENT = 6
};

typedef enum : NSUInteger {
    ALERT_ENTER_FILE_NAME = 1,
    ALERT_NAME_EXIST = 2
} ALERT_VIEW_TYPE;

typedef enum : NSUInteger {
    DownloadStateInProgress = 0,
    DownloadStatePause,
    DownloadStateCompleted,
    DownloadStateFailed,
} DownloadState;

typedef enum : NSUInteger {
    SubtitleIndexNone = -1,
} SubtitleIndex;
@interface Constant : NSObject

@end
