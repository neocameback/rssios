//
//  MWFeedItemSubTitle.h
//  MyRssReader
//
//  Created by GEM on 6/20/16.
//  Copyright © 2016 Huyns. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    SubtitleTypeSrt,
    SubTitleTypVTT,
} SubTitleType;

@protocol MWFeedItemSubTitle <NSObject>
@end

@interface MWFeedItemSubTitle : NSObject

@property (nonatomic, strong) NSString *link, *languageCode;
@property (nonatomic) SubTitleType type;
@property (nonatomic) BOOL castable;
@property (nonatomic, strong) NSString *typeString;
-(id) initWithDictionary:(NSDictionary *) dict;
@end
