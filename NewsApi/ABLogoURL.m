//
//  ABLogoURL.m
//  NewsApi
//
//  Created by Alexandr Bondar on 16.11.16.
//  Copyright © 2016 Alexandr Bondar. All rights reserved.
//

#import "ABLogoURL.h"

@implementation ABLogoURL

+ (FEMMapping*) defaultMapping {
    
    FEMMapping* mapping = [[FEMMapping alloc] initWithObjectClass:self];

    [mapping addAttributesFromArray:@[@"small", @"medium", @"large"]];

    return mapping;
}


@end
