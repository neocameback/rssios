//
//  DownloadManager.m
//  MyRssReader
//
//  Created by Huyns89 on 8/13/15.
//  Copyright (c) 2015 Huyns. All rights reserved.
//

#import "DownloadManager.h"
#import "AFDownloadRequestOperation.h"
#import "JDStatusBarNotification.h"

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
        [operationQueue setMaxConcurrentOperationCount:3];
    }
    return _shareDownloadManager;
}

-(void) downloadNode:(RssNodeModel *)node withName:(NSString *) name fromView:(id) viewcontroller
{
    NSString *fileName = name ?: node.nodeTitle;
    if ([DownloadManager isFileNameExist:fileName]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"You entered a file that already exist. Please choose an other file name." delegate:viewcontroller cancelButtonTitle:@"Cancel" otherButtonTitles:@"Retry", nil];
        [alert setTag:ALERT_NAME_EXIST];
        [alert show];
        return;
    }
    
    NSString *successText = [NSString stringWithFormat:@"%@.mp4 has been added to Saved videos",node.nodeTitle];
    [JDStatusBarNotification showWithStatus:successText dismissAfter:2 styleName:JDStatusBarStyleDark];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDownloadOperationStarted object:nil];
    
    File *savedFile = [File MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"url == %@ AND name == %@",node.nodeUrl, node.nodeTitle]];
    /**
     *  if file has not been created so create a file in db
     */
    if (!savedFile) {
        savedFile = [File MR_createEntity];
        [savedFile setCreatedAt:[NSDate date]];
        [savedFile setUrl:node.nodeUrl];
        [savedFile setType:@"mp4"];
    }
    [savedFile setName:name ?: node.nodeTitle];
    [savedFile setThumbnail:node.nodeImage];
    [savedFile setUpdatedAt:[NSDate date]];
    
    /**
     *  download subtitle also
     */
    [savedFile.subtitlesSet removeAllObjects];
    for (MWFeedItemSubTitle *subItem in node.subtitles) {
        Subtitle *subtitle = [Subtitle MR_createEntity];
        subtitle.createdAt = [NSDate date];
        [subtitle initFromSubtitleItem:subItem];
        [subtitle setName:name ?: node.nodeTitle];
        [subtitle setFile:savedFile];
        
        [savedFile.subtitlesSet addObject:subtitle];
        
        [self downloadSubtitle:subtitle];
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:node.nodeUrl]];
    NSString *path = [savedFile getFilePath];
    
    AFDownloadRequestOperation *operation = [[AFDownloadRequestOperation alloc] initWithRequest:request targetPath:path shouldResume:YES];
    [operation setDeleteTempFileOnCancel:YES];
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        float percentComplete = 0;
        @try {
            percentComplete = (float)totalBytesRead/(float)totalBytesExpectedToRead * 100;
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            [savedFile setProgressValue:percentComplete];
        }
        [savedFile setDownloadedBytes:[NSNumber numberWithDouble:totalBytesRead]];
        [savedFile setExpectedBytes:[NSNumber numberWithDouble:totalBytesExpectedToRead]];
        [savedFile setStateValue:DownloadStateInProgress];
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        /**
         *  save completed infor to savedFile
         */
        [savedFile setStateValue:DownloadStateCompleted];
        [savedFile setProgressValue:100];
        [savedFile setAbsoluteUrl:path];
        
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:nil];
        
        /**
         *  show success notice
         */
        NSString *successText = [NSString stringWithFormat:@"%@.mp4 has been downloaded successful",node.nodeTitle];
        [JDStatusBarNotification showWithStatus:successText dismissAfter:2 styleName:JDStatusBarStyleDark];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDownloadOperationCompleted object:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        NSString *successText = [NSString stringWithFormat:@"Failed to download %@.mp4",node.nodeTitle];
        [JDStatusBarNotification showWithStatus:successText dismissAfter:2 styleName:JDStatusBarStyleDark];
        [savedFile setStateValue:DownloadStateFailed];
        
        [savedFile MR_deleteEntity];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDownloadOperationCompleted object:nil];
    }];
    [operationQueue addOperation:operation];
}

-(void) downloadSubtitle:(Subtitle *) subtitle
{
    NSString *path = [subtitle getFilePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:subtitle.link]];
    AFDownloadRequestOperation *operation = [[AFDownloadRequestOperation alloc] initWithRequest:request targetPath:path shouldResume:YES];
    [operation setDeleteTempFileOnCancel:YES];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [subtitle MR_deleteEntity];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:nil];
    }];
    [operation start];
}

+(BOOL) isFileNameExist:(NSString *) fileName
{
    File *existFile = [File MR_findFirstByAttribute:@"name" withValue:fileName];
    if (existFile) {
        return YES;
    }else{
        return NO;
    }
}

-(void) resumeDownloadFile:(File*) savedFile
{
    [savedFile setUpdatedAt:[NSDate date]];
}
-(void) deleteFile:(File*) file;
{
    /**
     *  delele file from document
     */
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSString *path = [file getFilePath];
    
    BOOL fileExists = [fileManager fileExistsAtPath:path];
    if (fileExists)
    {
        BOOL success = [fileManager removeItemAtPath:path error:&error];
        if (!success) NSLog(@"Error: %@", [error localizedDescription]);
    }
    /**
     *  delete subtitle from document
     */
    for (Subtitle *subtitle in file.subtitlesSet) {
        NSString *path = [subtitle getFilePath];
        BOOL fileExists = [fileManager fileExistsAtPath:path];
        if (fileExists)
        {
            BOOL success = [fileManager removeItemAtPath:path error:&error];
            if (!success) NSLog(@"Error: %@", [error localizedDescription]);
        }
    }
    
    /**
     *  delete from db
     */
    [file MR_deleteEntity];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:nil];
}
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(void) cancelDownloadingTasks
{
    [operationQueue cancelAllOperations];
    [File MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"progress < 100"] inContext:[NSManagedObjectContext MR_defaultContext]];
}
@end

