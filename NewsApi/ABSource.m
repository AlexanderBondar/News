//
//  ABSource.m
//  NewsApi
//
//  Created by Alexandr Bondar on 16.11.16.
//  Copyright © 2016 Alexandr Bondar. All rights reserved.
//

#import "ABSource.h"

@implementation ABSource



+ (FEMMapping*) defaultMapping {
    
    FEMMapping* mapping = [[FEMMapping alloc] initWithObjectClass:self];
    
    [mapping addAttributesFromArray:@[@"name"]];
    [mapping addAttributesFromDictionary:@{@"idSource":@"id"}];
    [mapping addRelationshipMapping:[ABLogoURL defaultMapping] forProperty:@"urlsToLogos" keyPath:@"urlsToLogos"];
    
    return mapping;
    
}


@end
