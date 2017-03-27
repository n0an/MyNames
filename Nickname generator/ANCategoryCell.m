//
//  ANCategoryCell.m
//  Nickname generator
//
//  Created by Anton Novoselov on 26/03/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import "ANCategoryCell.h"

#import "ANNameCategory.h"
#import "ANUtils.h"

extern NSString* const kAppLaunchesCount;

@implementation ANCategoryCell


- (void) configureCellWithNameCategory:(ANNameCategory*) nameCategory {
    
    [self.categoryNewBadge setHidden:YES];
    
    if ([nameCategory.nameCategoryID isEqualToString:@"02.01"]) {
        
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        NSInteger appLaunchesCount = [userDefaults integerForKey:kAppLaunchesCount];
        
        ANLog(@"appLaunchesCount = %d", appLaunchesCount);
        
        if (appLaunchesCount < 10) {
            [self.categoryNewBadge setHidden:NO];
        } else {
            [self.categoryNewBadge setHidden:YES];
        }
    }
    
    
}


@end
