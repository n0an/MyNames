//
//  UIViewController+ANAlerts.h
//  Nickname generator
//
//  Created by Anton Novoselov on 28/03/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIViewController (ANAlerts)

- (void) showShareMenuActionSheetWithText:(NSString *) textToShare Image:(UIImage*) imageToShare andSourceForActivityVC:(NSObject *) sourceObject;

@end
