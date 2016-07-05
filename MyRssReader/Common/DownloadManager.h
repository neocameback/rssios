//
//  DownloadManager.h
//  MyRssReader
//
//  Created by Huyns89 on 8/13/15.
//  Copyright (c) 2015 Huyns. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "File.h"

@interface DownloadManager : NSObject
+ (DownloadManager *)shareManager;
-(void) downloadNode:(RssNodeModel *)node withName:(NSString *) name fromView:(id) viewcontroller;
-(void) resumeDownloadFile:(File*) savedFile;
-(void) deleteFile:(File*) file;
- (NSURL *)applicationDocumentsDirectory;
-(void) cancelDownloadingTasks;
@end

