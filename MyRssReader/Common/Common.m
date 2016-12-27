//
//  Common.m
//  MyRssReader
//
//  Created by Huyns89 on 8/26/15.
//  Copyright (c) 2015 Huyns. All rights reserved.
//

#import "Common.h"
#import "AFNetworking.h"

@implementation Common

+(NSString *) getPathOfFile:(NSString*) name extension:(NSString*) ext
{
    NSString *path = [NSTemporaryDirectory()  stringByAppendingPathComponent:name];
    path = [path stringByAppendingPathExtension:ext];
    
    return path;
}

+(NSString *) getIpAddress
{
    NSUInteger  an_Integer;
    NSArray * ipItemsArray;
    NSString *externalIP;
    
    NSURL *iPURL = [NSURL URLWithString:@"http://checkip.dyndns.com/"];
    
    if (iPURL) {
        NSError *error = nil;
        NSString *theIpHtml = [NSString stringWithContentsOfURL:iPURL
                                                       encoding:NSUTF8StringEncoding
                                                          error:&error];
        if (!error) {
            NSScanner *theScanner;
            NSString *text = nil;
            
            theScanner = [NSScanner scannerWithString:theIpHtml];
            
            while ([theScanner isAtEnd] == NO) {
                
                // find start of tag
                [theScanner scanUpToString:@"<" intoString:NULL] ;
                
                // find end of tag
                [theScanner scanUpToString:@">" intoString:&text] ;
                
                // replace the found tag with a space
                //(you can filter multi-spaces out later if you wish)
                theIpHtml = [theIpHtml stringByReplacingOccurrencesOfString:
                             [ NSString stringWithFormat:@"%@>", text]
                                                                 withString:@" "] ;
                ipItemsArray =[theIpHtml  componentsSeparatedByString:@" "];
                an_Integer=[ipItemsArray indexOfObject:@"Address:"];
                
                externalIP =[ipItemsArray objectAtIndex:  ++an_Integer];
            }
            NSLog(@"%@",externalIP);
            return externalIP;
        } else {
            NSLog(@"Oops... g %ld, %@",
                  (long)[error code],
                  [error localizedDescription]);
        }
    }
    return nil;
}
+(void) getUserIpAddress:(void (^) (id)) success failureBlock:(void (^) (id)) fail
{
    /**
     *  get user's IP Address
     */
    AFHTTPRequestOperationManager *operation = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:GET_IP_ADDRESS]];
    operation.requestSerializer.timeoutInterval = 3.0;
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    operation.requestSerializer = [AFHTTPRequestSerializer serializer];
    [operation.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html", @"application/json", nil]];
    [operation GET:@"" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fail(error);
    }];
}
+(NSMutableURLRequest*) requestWithMethod:(NSString *) method ipAddress:(NSString*) ipAddres Url:(NSURL *) url
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *userAgent = nil;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
    // User-Agent Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.43
    userAgent = [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale]];
#elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
    userAgent = [NSString stringWithFormat:@"%@/%@ (Mac OS X %@)", [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey], [[NSProcessInfo processInfo] operatingSystemVersionString]];
#endif
#pragma clang diagnostic pop
    if (userAgent) {
        if (![userAgent canBeConvertedToEncoding:NSASCIIStringEncoding]) {
            NSMutableString *mutableUserAgent = [userAgent mutableCopy];
            if (CFStringTransform((__bridge CFMutableStringRef)(mutableUserAgent), NULL, (__bridge CFStringRef)@"Any-Latin; Latin-ASCII; [:^ASCII:] Remove", false)) {
                userAgent = mutableUserAgent;
            }
        }
        [request setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    }
    [request setTimeoutInterval:kRequestTimeOut];
    NSString *uidString = [NSString stringWithFormat:@"w#Q6Ytzg9^2htklrUQufpKOEv3*9N_%@_RssChannel",ipAddres];
    NSString *md5String = [uidString MD5String];
    [request setValue:md5String forHTTPHeaderField:@"UID"];
    [request setHTTPMethod:method];
    [request setURL:url];
    
    return request;
}

+(enum NODE_TYPE) typeOfNode:(NSString *) nodeType
{
    if ([nodeType rangeOfString:@"rss"].location != NSNotFound) {
        return NODE_TYPE_RSS;
    }
    else if ([nodeType caseInsensitiveCompare:@"application/x-mpegurl"] == NSOrderedSame){
        return NODE_TYPE_VIDEO;
    }
    else if ([nodeType caseInsensitiveCompare:@"video/mp4"] == NSOrderedSame){
        return NODE_TYPE_MP4;
    }
    else if ([nodeType rangeOfString:@"youtube"].location != NSNotFound){
        return NODE_TYPE_YOUTUBE;
    }
    else if ([nodeType rangeOfString:@"dailymotion"].location != NSNotFound){
        return NODE_TYPE_DAILYMOTION;
    }
    else if ([nodeType rangeOfString:@"web/content"].location != NSNotFound){
        return NODE_TYPE_WEB_CONTENT;
    }
    else{
        return NODE_TYPE_WEB;
    }
}

+(GCKMediaInformation *)mediaInformationFromNode:(RssNodeModel *)node {
    GCKMediaMetadata *metadata =
    [[GCKMediaMetadata alloc] initWithMetadataType:GCKMediaMetadataTypeMovie];
    [metadata setString:node.nodeTitle forKey:kGCKMetadataKeyTitle];
    [metadata setString:node.nodeDesc forKey:@"description"];
    
    [metadata addImage:[[GCKImage alloc] initWithURL:[NSURL URLWithString:node.nodeImage]
                                               width:320
                                              height:568]];
    NSMutableArray *tracks = [NSMutableArray array];
    NSInteger count = node.subtitles.count;
    for (NSInteger i = 0 ; i < count; i ++) {
        MWFeedItemSubTitle *sub = node.subtitles[i];
        GCKMediaTrack *captionsTrack =
        [[GCKMediaTrack alloc] initWithIdentifier:i
                                contentIdentifier:sub.link
                                      contentType:sub.typeString
                                             type:GCKMediaTrackTypeText
                                      textSubtype:GCKMediaTextTrackSubtypeSubtitles
                                             name:sub.languageCode
                                     languageCode:sub.languageCode
                                       customData:nil];
        [tracks addObject:captionsTrack];
    }
    if (count == 0) {
        tracks = nil;
    }
    GCKMediaTextTrackStyle *trackStyle = [GCKMediaTextTrackStyle createDefault];
    GCKMediaInformation *mediaInfo = nil;
    if ([Common typeOfNode:node.nodeType] == NODE_TYPE_MP4) {
        mediaInfo = [[GCKMediaInformation alloc] initWithContentID:node.nodeUrl
                                                        streamType:GCKMediaStreamTypeBuffered
                                                       contentType:@"video/mp4"
                                                          metadata:metadata
                                                    streamDuration:0
                                                       mediaTracks:tracks
                                                    textTrackStyle:trackStyle
                                                        customData:nil];
        return mediaInfo;
    } else {
        return nil;
    }
}

+(GCKMediaInformation *)mediaInformationFromFile:(File *)file {
    GCKMediaMetadata *metadata =
    [[GCKMediaMetadata alloc] initWithMetadataType:GCKMediaMetadataTypeMovie];
    [metadata setString:file.name forKey:kGCKMetadataKeyTitle];
    [metadata setString:file.desc forKey:@"description"];
    
    [metadata addImage:[[GCKImage alloc] initWithURL:[NSURL URLWithString:file.thumbnail]
                                               width:320
                                              height:568]];
    
    GCKMediaInformation *mediaInfo = [[GCKMediaInformation alloc] initWithContentID:file.url
                                                                         streamType:GCKMediaStreamTypeBuffered
                                                                        contentType:@"video/mp4"
                                                                           metadata:metadata
                                                                     streamDuration:0
                                                                         customData:0];
    return mediaInfo;
}

+ (SubTitleType)subtitleTypeFromString:(NSString *)typeString {
    SubTitleType type = 0;
    if ([typeString isEqualToString:@"text/srt"]) {
        type = SubtitleTypeSrt;
    }else if ([typeString isEqualToString:@"text/vtt"]){
        type = SubTitleTypVTT;
    }
    return type;
}
@end
