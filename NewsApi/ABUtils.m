//
//  ABUtils.m
//  NewsApi
//
//  Created by Alexandr Bondar on 17.11.16.
//  Copyright © 2016 Alexandr Bondar. All rights reserved.
//

#import "ABUtils.h"

void ABLog(NSString* format, ...) {
    
#if LOGS_ENABLED
    
    va_list argumentList;
    
    va_start(argumentList, format);
    
    NSLogv(format, argumentList);
    
    va_end(argumentList);
    
#endif
}
