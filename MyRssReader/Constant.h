//
//  Constant.h
//  MyRssReader
//
//  Created by Huyns89 on 5/27/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kNotificationShouldReloadRssList    @"should_reload_rss"

#define ad_range   16

#define kDefaultRssUrl  @"http://rssvideoplayer.com/sample.xml"
#define kDefaultMd5Prefix   @"RssVideoPlayer-Hanoi052014-"

#define kDefaultShareTitle  @"Rss video player\nhttp://rssvideoplayer.com"
#define kAboutUrl   @"http://rssvideoplayer.com/about.html"

#define kSmallAdUnitId  @"ca-app-pub-8422191650855912/1857715781"
#define kLargeAdUnitId  @"ca-app-pub-8422191650855912/4957456186"
@interface Constant : NSObject

+(NSString *) getIpAddress;
+(NSMutableURLRequest*) initWithMethod:(NSString *) method andUrl:(NSString *) url;
@end
