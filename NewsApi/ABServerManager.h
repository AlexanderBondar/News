//
//  ABServerManager.h
//  NewsApi
//
//  Created by Alexandr Bondar on 15.11.16.
//  Copyright © 2016 Alexandr Bondar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import <EasyMapping.h>
#import <FastEasyMapping.h>

@interface ABServerManager : NSObject


+ (ABServerManager*) sharedManager;

- (void) getSoursesFromServerForCategory:(NSString*)category
                            withLanguage:(NSString*)language
                              andCountry:(NSString*)country
                               onSuccess:(void(^)(NSArray* sourses))success
                               onFailure:(void(^)(NSError* error))failure;

- (void) getNewsFromSourse:(NSString*)sourceID
                WithAPIKey:(NSString*)apiKey
                   andSort:(NSString*)sort
                 onSuccess:(void(^)(NSArray* articles))success
                 onFailure:(void(^)(NSError* error))failure;


@end
