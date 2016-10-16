#import "RssNode.h"
#import "RssNodeModel.h"

@interface RssNode ()

// Private interface goes here.

@end

@implementation RssNode

// Custom logic goes here.

-(void) initFromTempNode:(RssNodeModel*) temp
{
    [self setUpdatedAt:[NSDate date]];
    self.bookmarkStatus = temp.bookmarkStatus;
    self.isAddedToBoomark = temp.isAddedToBoomark;
    self.nodeImage = temp.nodeImage;
    self.nodeSource = temp.nodeSource;
    self.nodeTitle = temp.nodeTitle;
    self.nodeDesc = temp.nodeDesc;
    self.nodeLink = temp.nodeLink;
    self.nodeUrl = temp.nodeUrl;
    self.nodeType = temp.nodeType;
    self.isDeletedFlag = temp.isDeletedFlag;
    
    NSMutableArray *tempArray = [NSMutableArray array];
    for (MWFeedItemSubTitle *sub in temp.subtitles) {
        Subtitle *subtitle = [Subtitle MR_createEntity];
        subtitle.createdAt = [NSDate date];
        [subtitle setRssNode:self];
        [subtitle initFromSubtitleItem:sub];
        
        [tempArray addObject:subtitle];
    }
    self.subtitles = [NSOrderedSet orderedSetWithArray:tempArray];
}

@end
