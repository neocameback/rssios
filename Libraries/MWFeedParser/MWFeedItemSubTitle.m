//
//  MWFeedItemSubTitle.m
//  MyRssReader
//
//  Created by GEM on 6/20/16.
//  Copyright © 2016 Huyns. All rights reserved.
//

#import "MWFeedItemSubTitle.h"

@implementation MWFeedItemSubTitle

-(id) initWithDictionary:(NSDictionary *) dict
{
    self = [super init];
    
    _link = [dict stringForKey:@"href"];
    _languageCode = [dict stringForKey:@"lang"];
    [self setSubTitleType:[dict stringForKey:@"type"]];
    _typeString = [dict stringForKey:@"type"];
    return self;
}
-(void) setSubTitleType:(NSString *) type
{
    if ([type isEqualToString:@"text/srt"]) {
        _type = SubtitleTypeSrt;
    }else if ([type isEqualToString:@"text/vtt"]){
        _type = SubTitleTypVTT;
    }
}
@end
