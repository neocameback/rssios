//
//  SubtitleModel.h
//  MyRssReader
//
//  Created by Huy on 6/26/16.
//  Copyright © 2016 Huyns. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Subtitle.h"

@interface SubtitleModel : NSObject

@property (nonatomic, strong) NSString *name, *languageCode, *languageName, *filePath;
@property (nonatomic) BOOL isSelected;

-(id) initWithSubtitle:(Subtitle *) sub;
@end
