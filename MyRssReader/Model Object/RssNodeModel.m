//
//  TempNode.m
//  MyRssReader
//
//  Created by Huyns89 on 5/30/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import "RssNodeModel.h"
#import "MWFeedItem.h"
#import "NSString+HTML.h"
#import "RssNode.h"
#import "Node.h"

@implementation RssNodeModel
@synthesize bookmarkStatus, isAddedToBoomark, nodeImage, nodeSource, nodeTitle, nodeDesc, nodeType, nodeUrl;
-(id) initWithFeedItem:(MWFeedItem*) item
{
    self = [super init];
    
    self.bookmarkStatus = item.bookmarkStatus;
    self.nodeTitle = item.title;
    self.nodeDesc = item.summary; //[item.summary stringByConvertingHTMLToPlainText];
    self.nodeLink = item.link;
    if (item.enclosures.count > 0) {
        self.nodeType = item.enclosures[0][@"type"];
        self.nodeUrl = item.enclosures[0][@"url"];
    }
    /**
     *  get node thumbnail from media:thumbnail
     */
    if (item.medias.count > 0) {
        self.nodeImage = [item.medias firstObject][@"url"];
    }
    /**
     *  if thumbnail = nil or length <= 0 so get from enclosure
     */
    if (!self.nodeImage || self.nodeImage.length <= 0) {
        if (item.summary && item.summary.length > 0) {
            NSError *error = NULL;
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(<img\\s[\\s\\S]*?src\\s*?=\\s*?['\"](.*?)['\"][\\s\\S]*?>)+?"
                                                                                   options:NSRegularExpressionCaseInsensitive
                                                                                     error:&error];
            
            [regex enumerateMatchesInString:item.summary
                                    options:0
                                      range:NSMakeRange(0, [item.summary length])
                                 usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                     
                                     self.nodeImage = [item.summary substringWithRange:[result rangeAtIndex:2]];
                                     self.nodeImage = [self.nodeImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                 }];
        }
    }
    
    return self;
}
-(id) initWithRssNode:(RssNode*) rssNode;
{
    self = [super init];
    self.bookmarkStatus = rssNode.bookmarkStatus;
    self.nodeTitle = rssNode.nodeTitle;
    self.nodeDesc = rssNode.nodeDesc;
    self.nodeLink = rssNode.nodeLink;
    self.nodeType = rssNode.nodeType;
    self.nodeUrl = rssNode.nodeUrl;
    self.nodeImage = rssNode.nodeImage;
    
    return self;
}
-(id) initWithBookmarkNode:(Node *) rssNode
{
    self = [super init];
    self.bookmarkStatus = rssNode.bookmarkStatus;
    self.nodeTitle = rssNode.nodeTitle;
    self.nodeDesc = rssNode.nodeDesc;
    self.nodeLink = rssNode.nodeLink;
    self.nodeType = rssNode.nodeType;
    self.nodeUrl = rssNode.nodeUrl;
    self.nodeImage = rssNode.nodeImage;
    
    return self;
}

-(id) initWithFile:(NSDictionary*) file;
{
    self = [super init];
    
    self.nodeTitle = file[@"name"];
    self.nodeDesc = file[@"desc"];
    self.nodeImage = file[@"thumbnail"];
    self.nodeType = file[@"type"];
    self.nodeUrl = file[@"url"];
    /**
     *  file is not cacheable
     */
    self.bookmarkStatus = @"false";
    
    return self;
}
@end
