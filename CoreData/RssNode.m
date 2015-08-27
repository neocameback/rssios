#import "RssNode.h"
#import "TempNode.h"

@interface RssNode ()

// Private interface goes here.

@end

@implementation RssNode

// Custom logic goes here.

-(void) initFromTempNode:(TempNode*) temp
{
    [self setUpdatedAt:[NSDate date]];
    self.bookmarkStatus = temp.bookmarkStatus;
    self.isAddedToBoomark = temp.isAddedToBoomark;
    self.nodeImage = temp.nodeImage;
    self.nodeSource = temp.nodeSource;
    self.nodeTitle = temp.nodeTitle;
    self.nodeLink = temp.nodeLink;
    self.nodeUrl = temp.nodeUrl;
    self.nodeType = temp.nodeType;
    self.isDeletedFlag = temp.isDeletedFlag;
}

@end
