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

#define LOGS_ENABLED 1

#define LOGS_NOTIFICATION_ENABLED 1




#define APP_SHORT_NAME @"TRICKS"

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a/255.f];


extern NSString* const ANLogNotification;
extern NSString* const ANLogNotificationTextUserInfoKey;


typedef enum {
    ANProgrammerTypeJunior,
    ANProgrammerTypeMid,
    ANProgrammerTypeSenior
    
} ANProgrammerType;




NSString* fancyDateStringFromDate(NSDate* date);

BOOL iPad();
BOOL iPhone();




NSString* NSStringFromANProgrammerType(ANProgrammerType type);


void ANLog(NSString* format, ...);









#endif


