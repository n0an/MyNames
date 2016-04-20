//
//  ANWebViewVC.h
//  Nickname generator
//
//  Created by Anton Novoselov on 05/04/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ANWebViewVC : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView* webView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem* backButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem* forwardButtonItem;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView* activityIndicator;

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

- (IBAction)actionBack:(id)sender;
- (IBAction)actionForward:(id)sender;
- (IBAction)actionRefresh:(id)sender;

@property (strong, nonatomic) NSString* nameURL;



@end
