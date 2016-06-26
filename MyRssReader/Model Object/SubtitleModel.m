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
    return self;
}

-(NSString *) languageName
{
    return _name;
}
@end
