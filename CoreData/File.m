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

-(BOOL) rename:(NSString *) newName
{
    /**
     *  update name of the physical file
     */
    NSString *oldPath = [self getFilePath];
    NSString *newPath = [Common getPathOfFile:newName extension:self.type];
    NSError * err = NULL;
    NSFileManager * fm = [NSFileManager defaultManager];
    BOOL result = [fm moveItemAtPath:oldPath toPath:newPath error:&err];
    if(!result)
        return NO;
    /**
     *  update name of file on DB
     */
    [self setName:newName];
    /**
     *  make similar with Subtitles
     */
    for (Subtitle *sub in self.subtitlesSet) {
        
        oldPath = [sub getFilePath];
        newPath = [sub getFilePathWithName:newName];
        BOOL result = [fm moveItemAtPath:oldPath toPath:newPath error:&err];
        if(!result)
            return NO;
        [sub setName:newName];
    }
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    return YES;
}
@end
