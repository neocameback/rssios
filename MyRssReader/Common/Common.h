//
//  Common.h
//  MyRssReader
//
//  Created by Huyns89 on 8/26/15.
//  Copyright (c) 2015 Huyns. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RssNodeModel.h"
#import "File.h"

@interface Common : NSObject

+(NSString *) getPathOfFile:(NSString*) name extension:(NSString*) ext;
+(NSString *) getIpAddress;
+(NSMutableURLRequest*) requestWithMethod:(NSString *) method ipAddress:(NSString*) ipAddres Url:(NSURL *) url;
+ (NSString *)getDefaultUserAgent;

+(enum NODE_TYPE) typeOfNode:(NSString *) nodeType;
+(GCKMediaInformation *)mediaInformationFromNode:(RssNodeModel *)node;
+(GCKMediaInformation *)mediaInformationFromFile:(File *)file;
+(void) getUserIpAddress:(void (^) (id)) success failureBlock:(void (^) (id)) fail;
+ (NSInteger)subtitleTypeFromString:(NSString *)typeString;
@end
