//
//  UIViewController+ANAlerts.m
//  Nickname generator
//
//  Created by Anton Novoselov on 28/03/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

#import "UIViewController+ANAlerts.h"
#import <Social/Social.h>

@implementation UIViewController (ANAlerts)

- (void) showAlertShareErrorWithTitle:(NSString *)title andMessage:(NSString *) message {
    
    UIAlertController* errorAlertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [errorAlertController addAction:okAction];
    
    [self presentViewController:errorAlertController animated:true completion:nil];
}

- (void) showShareMenuActionSheetWithText:(NSString *) textToShare andImage:(UIImage*) imageToShare andSource:(NSObject *) sourceObject {
    
    NSString* introTextToShare = NSLocalizedString(@"SHARE_TEXT", nil);
    
    NSString* fullTextToShare = [NSString stringWithFormat:@"%@ - %@", textToShare, introTextToShare];
    
    // Presenting action sheet with share options - Facebook, Twitter, UIActivityVC
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"SHARE_MESSAGE", nil) preferredStyle:UIAlertControllerStyleActionSheet];
    
    // TWITTER ACTION
    UIAlertAction* twitterAction = [UIAlertAction actionWithTitle:@"Twitter" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        // Check if Twitter is available. Otherwise, display an error message
        
        if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
            
            [self showAlertShareErrorWithTitle:NSLocalizedString(@"SHARE_TWITTER_UNAVAILABLE_TITLE", nil) andMessage:NSLocalizedString(@"SHARE_TWITTER_UNAVAILABLE_MESSAGE", nil)];
            
            return;
            
        }
        
        // Display Tweet Composer
        SLComposeViewController* tweetComposer = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [tweetComposer setInitialText:fullTextToShare];
        [tweetComposer addImage:imageToShare];
        
        //[tweetComposer addURL:shareUrl];
        
        [self presentViewController:tweetComposer animated:true completion:nil];
        
        
    }];
    
    // FACEBOOK ACTION
    UIAlertAction* facebookAction = [UIAlertAction actionWithTitle:@"Facebook" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        // Check if Facebook is available. Otherwise, display an error message
        
        if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            
            [self showAlertShareErrorWithTitle:NSLocalizedString(@"SHARE_FACEBOOK_UNAVAILABLE_TITLE", nil) andMessage:NSLocalizedString(@"SHARE_FACEBOOK_UNAVAILABLE_MESSAGE", nil)];
            
            return;
            
        }
        
        // Display Facebook Composer
        SLComposeViewController* facebookComposer = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [facebookComposer setInitialText:fullTextToShare];
        [facebookComposer addImage:imageToShare];
        
        //[facebookComposer addURL:shareUrl];
        
        [self presentViewController:facebookComposer animated:true completion:nil];
        
    }];
    
    // OTHER ACTION - UIActivityVC
    UIAlertAction* otherAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"SHARE_ACTION_OTHER", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSArray* shareItems;
        
        if (imageToShare != nil) {
            shareItems = @[textToShare, imageToShare];
        } else {
            shareItems = @[textToShare];
        }
        
        [self showActivityVCWithItems:shareItems];
        
    }];
    
    // CANCEL ACTION
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"CANCEL_CLEAR", nil) style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:facebookAction];
    [alertController addAction:twitterAction];
    [alertController addAction:otherAction];
    [alertController addAction:cancelAction];
    
    alertController.popoverPresentationController.sourceView = self.view;
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}


- (void) showActivityVCWithItems:(NSArray *)items {
    
    UIActivityViewController* activityVC = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    
    activityVC.popoverPresentationController.sourceView = self.view;
    
    [self presentViewController:activityVC animated:true completion:nil];
}


@end
