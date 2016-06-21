#import "_Subtitle.h"
#import "MWFeedItemSubTitle.h"

@interface Subtitle : _Subtitle
// Custom logic goes here.

-(void) initFromSubtitleItem:(MWFeedItemSubTitle *) subtitleItem;
-(NSString *) getFilePath;
@end
