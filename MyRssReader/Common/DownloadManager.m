//
//  DownloadManager.m
//  MyRssReader
//
//  Created by Huyns89 on 8/13/15.
//  Copyright (c) 2015 Huyns. All rights reserved.
//

#import "DownloadManager.h"
#import <AFDownloadRequestOperation.h>
#import <JDStatusBarNotification.h>

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

-(void) downloadFile:(NSString *) url name:(NSString*) name thumbnail:(NSString *)thumb fromView:(id) viewcontroller
{
    NSString *successText = [NSString stringWithFormat:@"%@.mp4 has been added to Saved videos",name];
    [JDStatusBarNotification showWithStatus:successText dismissAfter:2 styleName:JDStatusBarStyleDark];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDownloadOperationStarted object:nil];
    
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
    [savedFile setThumbnail:thumb];
    [savedFile setUpdatedAt:[NSDate date]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];

    NSString *path = [Common getPathOfFile:savedFile.name extension:savedFile.type];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"You entered a file that already exist. Please choose an other file name." delegate:viewcontroller cancelButtonTitle:@"Cancel" otherButtonTitles:@"Retry", nil];
        [alert setTag:ALERT_NAME_EXIST];
        [alert show];
    }else{
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
            
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            
            /**
             *  show success notice
             */
            NSString *successText = [NSString stringWithFormat:@"%@.mp4 has been downloaded successful",name];
            [JDStatusBarNotification showWithStatus:successText dismissAfter:2 styleName:JDStatusBarStyleDark];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDownloadOperationCompleted object:nil];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            NSString *successText = [NSString stringWithFormat:@"Failed to download %@.mp4",name];
            [JDStatusBarNotification showWithStatus:successText dismissAfter:2 styleName:JDStatusBarStyleDark];
            [savedFile setStateValue:DownloadStateFailed];
            
            [savedFile MR_deleteEntity];
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDownloadOperationCompleted object:nil];
        }];
        [operationQueue addOperation:operation];
    }
}

-(void) resumeDownloadFile:(File*) savedFile
{
    [savedFile setUpdatedAt:[NSDate date]];
    [savedFile.operation start];
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

