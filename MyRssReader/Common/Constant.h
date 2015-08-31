//
//  Constant.h
//  MyRssReader
//
//  Created by Huyns89 on 5/27/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kNotificationShouldReloadRssList    @"should_reload_rss"

#define kSecondsToPresentInterstitial   120
#define kAutoRefreshNewsTime                 @"auto_refresh_news_time"
#define kLastOpenFullScreen @"last_open_full_screen"

#define GET_IP_ADDRESS      @"http://rssvideoplayer.com/ip"
#define kDefaultRssUrl      @"http://rssvideoplayer.com/sample.xml"
#define kDefaultMd5Prefix   @"RssVideoPlayer-Hanoi052014-"

#define kDefaultShareTitle  @"Rss video player\nhttp://rssvideoplayer.com"
#define kAboutUrl           @"http://rssvideoplayer.com/about.html"
#define POST_HANDLE_URL     @"http://rssvideoplayer.com/handle"

#define kGoogleAnalyticId   @"UA-51537954-1"

#define kSmallAdUnitId  @"ca-app-pub-8422191650855912/1857715781"
#define kLargeAdUnitId  @"ca-app-pub-8422191650855912/4957456186"

#define kMessageInternetConnectionLost  @"Internet connection was lost!"

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

@interface Constant : NSObject

@end