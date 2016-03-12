//
//  ANUtils.m
//  Nickname generator
//
//  Created by Anton Novoselov on 12/03/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//


#import "ANUtils.h"


NSString* const ANLogNotification = @"com.anovoselov.ANLogNotification";
NSString* const ANLogNotificationTextUserInfoKey = @"com.anovoselov.ANLogNotificationTextUserInfoKey";

NSString* fancyDateStringFromDate(NSDate* date) {
    
    static NSDateFormatter* formatter = nil;
    
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"-- dd : MM : yy --"];
    }
    
    return [formatter stringFromDate:date];
    
}



BOOL iPad() {
    
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}


BOOL iPhone() {
    
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
    
}

NSString* NSStringFromANProgrammerType(ANProgrammerType type) {
    
    switch (type) {
        case ANProgrammerTypeJunior:    return @"ANProgrammerTypeJunior";
        case ANProgrammerTypeMid:       return @"ANProgrammerTypeMid";
        case ANProgrammerTypeSenior:    return @"ANProgrammerTypeSenior";
            
        default:                        return nil;
    }
    
}



void ANLog(NSString* format, ...) {
    
#if LOGS_ENABLED
    
    va_list argumentList;
    
    va_start(argumentList, format);
    
    NSLogv(format, argumentList);
    
#if LOGS_NOTIFICATION_ENABLED
    
    
//    NSString* log = [[NSString alloc] initWithFormat:format arguments:argumentList];
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:ANLogNotification
//                                                        object:nil
//                                                      userInfo:@{ANLogNotificationTextUserInfoKey: log}];
    
#endif
    
    va_end(argumentList);
    
#endif
    
}

