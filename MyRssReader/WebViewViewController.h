//
//  WebViewViewController.h
//  MyRssReader
//
//  Created by Huyns89 on 5/26/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewViewController : BaseViewController
{
    __weak IBOutlet UIWebView *_webView;
}
@property (nonatomic, strong) NSString* webUrl;
@end
