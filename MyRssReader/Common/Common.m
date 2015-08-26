//
//  Common.m
//  MyRssReader
//
//  Created by Huyns89 on 8/26/15.
//  Copyright (c) 2015 Huyns. All rights reserved.
//

#import "Common.h"

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
+(NSMutableURLRequest*) requestWithMethod:(NSString *) method andUrl:(NSString *) url
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //    NSString *ipAddres = [Constant getIpAddress];
    [request setValue:@"RSSVideoPlayer2.0-iOS" forHTTPHeaderField:@"User-Agent"];
    NSString *md5String = [[NSString stringWithFormat:@"%@%@",kDefaultMd5Prefix,url] MD5String];
    [request setHTTPMethod:method];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?Auth=%@",url,md5String]]];
    
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
    else if ([nodeType rangeOfString:@"rtmp"].location != NSNotFound){
        return NODE_TYPE_RTMP;
    }
    else if ([nodeType rangeOfString:@"web/content"].location != NSNotFound){
        return NODE_TYPE_WEB_CONTENT;
    }
    else{
        return NODE_TYPE_WEB;
    }
}
@end
