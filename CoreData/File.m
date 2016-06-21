#import "File.h"

@interface File ()

// Private interface goes here.

@end

@implementation File

// Custom logic goes here.

-(NSString *) getFilePath
{
    return [Common getPathOfFile:self.name extension:self.type];
}
@end
