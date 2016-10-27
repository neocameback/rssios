#import "Subtitle.h"

@interface Subtitle ()

// Private interface goes here.

@end

@implementation Subtitle

// Custom logic goes here.

-(void) initFromSubtitleItem:(MWFeedItemSubTitle *) subtitleItem
{
    self.link = subtitleItem.link;
    self.languageCode = subtitleItem.languageCode;
    if (subtitleItem.type == SubtitleTypeSrt) {
        self.extension = @"srt";
    }else if (subtitleItem.type == SubTitleTypVTT){
        self.extension = @"vtt";
    }
    self.type = subtitleItem.typeString;
    self.updatedAt = [NSDate date];
}

-(NSString *) getFilePath
{
    return [Common getPathOfFile:[NSString stringWithFormat:@"%@_%@",self.languageCode, self.name] extension:self.extension];
}

-(NSString *) getFilePathWithName:(NSString *) name
{
    return [Common getPathOfFile:[NSString stringWithFormat:@"%@_%@",self.languageCode, name] extension:self.extension];
}

@end
