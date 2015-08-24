//
//  DownloadManager.m
//  MyRssReader
//
//  Created by Huyns89 on 8/13/15.
//  Copyright (c) 2015 Huyns. All rights reserved.
//

#import "DownloadManager.h"
#import <AFDownloadRequestOperation.h>
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
        [operationQueue setMaxConcurrentOperationCount:1];
    }
    return _shareDownloadManager;
}

-(void) downloadFile:(NSString *) url name:(NSString*) name fromView:(id) viewcontroller
{
    File *savedFile = [File MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"url == %@ AND name == %@",url, name]];
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
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];

    NSString *path = [Common getPathOfFile:savedFile.name extension:savedFile.type];
    
    
    NSLog(@"downloadFile path: %@",path);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"You entered a file that already exist. Please choose an other file name." delegate:viewcontroller cancelButtonTitle:@"Cancel" otherButtonTitles:@"Retry", nil];
        [alert setTag:ALERT_NAME_EXIST];
        [alert show];
    }else{
        AFDownloadRequestOperation *operation = [[AFDownloadRequestOperation alloc] initWithRequest:request targetPath:path shouldResume:YES];
        [operation setDeleteTempFileOnCancel:YES];
        [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
//            float percentComplete = (float)totalBytesRead/(float)totalBytesExpectedToRead * 100;
//            NSLog(@"Download progress: %lu---- %lld percent: %.2f",(unsigned long)totalBytesRead,totalBytesExpectedToRead, percentComplete);
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
            [notice showSuccess];
            NSLog(@"Successfully downloaded file to %@", path);
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            NSString *successText = [NSString stringWithFormat:@"Failed to download %@.mp4",name];
            WBSuccessNoticeView *notice = [WBSuccessNoticeView successNoticeInView:[APPDELEGATE window].rootViewController.view title:successText duration:1 alpha:1 delay:0.7];
            [notice showFailure];
            
            [savedFile MR_deleteEntity];
            
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:nil];
        }];
        [operationQueue addOperation:operation];
    }
}

-(void) resumeDownloadFile:(File*) savedFile
{
    [savedFile setUpdatedAt:[NSDate date]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:savedFile.url]];

    NSString *path = [Common getPathOfFile:savedFile.name extension:savedFile.type];
    
    NSLog(@"resumeDownloadFile path: %@",path);
    
    AFDownloadRequestOperation *operation = [[AFDownloadRequestOperation alloc] initWithRequest:request targetPath:path shouldResume:YES];
    [operation setDeleteTempFileOnCancel:YES];
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
//        float percentComplete = (float)totalBytesRead/(float)totalBytesExpectedToRead * 100;
//        NSLog(@"Download progress: %lu---- %lld percent: %.2f",(unsigned long)totalBytesRead,totalBytesExpectedToRead, percentComplete);
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
        NSString *successText = [NSString stringWithFormat:@"%@.mp4 has been downloaded successful",savedFile.name];
        WBSuccessNoticeView *notice = [WBSuccessNoticeView successNoticeInView:[APPDELEGATE window].rootViewController.view title:successText duration:1 alpha:1 delay:0.7];
        [notice showSuccess];
        NSLog(@"Successfully downloaded file to %@", path);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        NSString *successText = [NSString stringWithFormat:@"Failed to download %@.mp4",savedFile.name];
        WBSuccessNoticeView *notice = [WBSuccessNoticeView successNoticeInView:[APPDELEGATE window].rootViewController.view title:successText duration:1 alpha:1 delay:0.7];
        [notice showFailure];
        
        [self deleteFile:savedFile];
    }];
    [operationQueue addOperation:operation];
}
-(void) deleteFile:(File*) file;
{
    /**
     *  delele file from document
     */
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSString *path = [Common getPathOfFile:file.name extension:file.type];
    
    BOOL fileExists = [fileManager fileExistsAtPath:path];
    NSLog(@"Path to file: %@", path);
    NSLog(@"File exists: %d", fileExists);
    NSLog(@"Is deletable file at path: %d", [fileManager isDeletableFileAtPath:path]);
    if (fileExists)
    {
        BOOL success = [fileManager removeItemAtPath:path error:&error];
        if (!success) NSLog(@"Error: %@", [error localizedDescription]);
    }
    /**
     *  delete from db
     */
    [file MR_deleteEntity];
    [[file managedObjectContext] MR_saveToPersistentStoreAndWait];
}
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
@end

