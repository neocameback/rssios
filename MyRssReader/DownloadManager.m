//
//  DownloadManager.m
//  MyRssReader
//
//  Created by Huyns89 on 8/13/15.
//  Copyright (c) 2015 Huyns. All rights reserved.
//

#import "DownloadManager.h"
#import <AFDownloadRequestOperation.h>
#import "File.h"
#import "WBSuccessNoticeView.h"

@interface DownloadManager()
{
    
}
@end
static NSOperationQueue *operationQueue;
@implementation DownloadManager
+ (DownloadManager *) shareManager
{
    static DownloadManager *_shareDownloadManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareDownloadManager = [[self alloc] init];
    });
    if (!operationQueue) {
        operationQueue = [[NSOperationQueue alloc] init];
    }
    return _shareDownloadManager;
}

-(void) downloadFile:(NSString *) url name:(NSString*) name fromView:(id) viewcontroller
{
    File *savedFile = [File MR_findFirstByAttribute:@"url" withValue:url];
    /**
     *  if file has not been created so create a file in db
     */
    if (!savedFile) {
        savedFile = [File MR_createEntity];
        [savedFile setCreatedAt:[NSDate date]];
        [savedFile setUrl:url];
        [savedFile setType:@"mp4"];
    }
    [savedFile setName:name];
    [savedFile setUpdatedAt:[NSDate date]];
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:name];
    path = [path stringByAppendingPathExtension:@"mp4"];
    NSLog(@"will save file at path: %@",path);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"You entered a file that already exist. Please choose an other file name." delegate:viewcontroller cancelButtonTitle:@"Cancel" otherButtonTitles:@"Retry", nil];
        [alert setTag:ALERT_NAME_EXIST];
        [alert show];
    }else{
        AFDownloadRequestOperation *operation = [[AFDownloadRequestOperation alloc] initWithRequest:request targetPath:path shouldResume:YES];
        [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
            float percentComplete = (float)totalBytesRead/(float)totalBytesExpectedToRead * 100;
            NSLog(@"Download progress: %lu---- %lld percent: %.2f",(unsigned long)totalBytesRead,totalBytesExpectedToRead, percentComplete);
            [savedFile setDownloadedBytes:[NSNumber numberWithDouble:totalBytesRead]];
            [savedFile setExpectedBytes:[NSNumber numberWithDouble:totalBytesExpectedToRead]];
        }];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            /**
             *  save completed infor to savedFile
             */
            [savedFile setIsCompletedValue:YES];
            [savedFile setAbsoluteUrl:path];
            
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            
            /**
             *  show success notice
             */
            NSString *successText = [NSString stringWithFormat:@"%@.mp4 has been downloaded successful",name];
            WBSuccessNoticeView *notice = [WBSuccessNoticeView successNoticeInView:[APPDELEGATE window].rootViewController.view title:successText duration:1 alpha:1 delay:0.7];
            [notice show];                        
            NSLog(@"Successfully downloaded file to %@", path);
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            NSString *successText = [NSString stringWithFormat:@"Failed to download %@.mp4",name];
            WBSuccessNoticeView *notice = [WBSuccessNoticeView successNoticeInView:[APPDELEGATE window].rootViewController.view title:successText duration:1 alpha:1 delay:0.7];
            [notice show];
            
            [savedFile MR_deleteEntity];
            
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        }];
        [operationQueue addOperation:operation];
    }
}
@end

