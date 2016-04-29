//
//  ANUtils.h
//  Nickname generator
//
//  Created by Anton Novoselov on 12/03/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef UTILS
#define UTILS


//#define PRODUCTION_BUILD

#define LOGS_ENABLED 0

#define LOGS_NOTIFICATION_ENABLED 0


#define APP_SHORT_NAME @"MyNames"

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a/255.f];


extern NSString* const ANLogNotification;
extern NSString* const ANLogNotificationTextUserInfoKey;
extern NSString* const ANCDMFavoriteName;




NSString* fancyDateStringFromDate(NSDate* date);


BOOL iPad();
BOOL iPhone();

BOOL isOrientationPortrait();

BOOL isOrientationLandscape();

UIColor* randomColor();



void ANLog(NSString* format, ...);









#endif


