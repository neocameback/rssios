//
//  Constant.m
//  MyRssReader
//
//  Created by Huyns89 on 5/27/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import "Constant.h"

@implementation Constant
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
            NSLog(@"Oops... g %d, %@",
                  [error code],
                  [error localizedDescription]);
        }
    }
    return nil;
}
+(NSMutableURLRequest*) initWithMethod:(NSString *) method andUrl:(NSString *) url
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *ipAddres = [Constant getIpAddress];
    NSString *md5String = [[NSString stringWithFormat:@"%@%@",kDefaultMd5Prefix,ipAddres] MD5String];
    [request setHTTPMethod:method];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?Auth=%@",url,md5String]]];
    
    return request;
}

@end
