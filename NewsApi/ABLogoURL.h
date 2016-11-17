//
//  ABLogoURL.h
//  NewsApi
//
//  Created by Alexandr Bondar on 16.11.16.
//  Copyright © 2016 Alexandr Bondar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FastEasyMapping.h>

@interface ABLogoURL : NSObject

@property (copy, nonatomic) NSString* large;
@property (copy, nonatomic) NSString* medium;
@property (copy, nonatomic) NSString* small;

+ (FEMMapping*) defaultMapping;

@end
