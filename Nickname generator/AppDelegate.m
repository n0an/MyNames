//
//  AppDelegate.m
//  Nickname generator
//
//  Created by Anton Novoselov on 08/03/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import "AppDelegate.h"
#import "ANDataManager.h"
#import "ANUtils.h"

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

#import <Firebase.h>

@interface AppDelegate ()

@end

#pragma mark - CONSTANTS
extern NSString* const ANManagedObjectContextSaveDidFailNotification;
extern NSString* const kAppLaunchesCount;

@implementation AppDelegate

#pragma mark - didFinishLaunchingWithOptions
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Fabric with:@[[Crashlytics class]]];
    
    //UIColor *tabBarColor = RGBA(201, 81, 0, 255);
    //[[UITabBar appearance] setTintColor:tabBarColor];
    
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    UIColor *tabBarTintColor = RGBA(236, 240, 241, 1.0);
    [[UITabBar appearance] setBarTintColor:tabBarTintColor];
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"tabitem-selected"]];
    
    [FIRApp configure];
    
    [self listenForFatalCoreDataNotifications];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSInteger appLaunchesCount = [userDefaults integerForKey:kAppLaunchesCount];
    appLaunchesCount++;
    
    [userDefaults setInteger:appLaunchesCount forKey:kAppLaunchesCount];
    
    
    
    return YES;
}

#pragma mark - HELPER METHODS
- (UIViewController*) viewControllerForShowingAlert {
    
    UIViewController *rootVC = self.window.rootViewController;
    
    if (rootVC.presentedViewController != nil) {
        return rootVC.presentedViewController;
        
    } else {
        return rootVC;
    }
}

#pragma mark - NOTIFICATIONS
- (void) listenForFatalCoreDataNotifications {
    
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter]
    ;
    
    [center addObserverForName:ANManagedObjectContextSaveDidFailNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Internal Error" message:@"There was a fatal error in the app and it cannot continue.\n\nPress OK to terminate the app. Sorry for the inconvenience." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSException *exception = [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Fatal Core Data Error" userInfo:nil];
            [exception raise];
        }];
        
        [alert addAction:action];
        UIViewController *vc = [self viewControllerForShowingAlert];
        [vc presentViewController:alert animated:true completion:nil];
    }];
}
    

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[ANDataManager sharedManager] saveContext];

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    [[ANDataManager sharedManager] saveContext];
}

@end
