#import "_File.h"

/**
 *  download file Model
 */
@interface File : _File {}
// Custom logic goes here.

-(NSString *) getFilePath;
-(BOOL) rename:(NSString *) newName;
@end
