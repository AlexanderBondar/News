//
//  ABSource.h
//  NewsApi
//
//  Created by Alexandr Bondar on 16.11.16.
//  Copyright © 2016 Alexandr Bondar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FastEasyMapping.h>
#import "ABLogoURL.h"


@interface ABSource : NSObject

@property (copy, nonatomic) NSString* name;
@property (strong, nonatomic) ABLogoURL* urlsToLogos;
@property (copy, nonatomic) NSString* idSource;

+ (FEMMapping*) defaultMapping;

@end
