//
//  SubtitleModel.h
//  MyRssReader
//
//  Created by Huy on 6/26/16.
//  Copyright © 2016 Huyns. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Subtitle.h"
#import "MWFeedItemSubTitle.h"
@interface SubtitleModel : NSObject

@property (nonatomic, strong) NSString *name, *languageCode, *languageName, *filePath, *link;
@property (nonatomic) BOOL isSelected;
@property (nonatomic) SubTitleType type;

-(id) initWithSubtitle:(Subtitle *) sub;
-(id) initWithMWFeedItemSubtitle:(MWFeedItemSubTitle *) sub;
@end
