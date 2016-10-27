//
//  SubtitleModel.m
//  MyRssReader
//
//  Created by Huy on 6/26/16.
//  Copyright © 2016 Huyns. All rights reserved.
//

#import "SubtitleModel.h"

@implementation SubtitleModel

-(id) initWithSubtitle:(Subtitle *) sub
{
    self = [super init];
    
    _languageCode = sub.languageCode;
    _filePath = [sub getFilePath];
    _name = [_filePath lastPathComponent];
    _type = [Common subtitleTypeFromString:sub.type];
    return self;
}
-(id) initWithMWFeedItemSubtitle:(MWFeedItemSubTitle *) sub
{
    self = [super init];
    
    _languageCode = sub.languageCode;
    _link = sub.link;
    _name = _languageCode;
    _type = sub.type;
    return self;
}
-(NSString *) languageName
{
    return _name;
}
@end
