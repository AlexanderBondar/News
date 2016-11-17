//
//  ABServerManager.m
//  NewsApi
//
//  Created by Alexandr Bondar on 15.11.16.
//  Copyright © 2016 Alexandr Bondar. All rights reserved.
//

#import "ABServerManager.h"
#import "ABSource.h"
#import "ABArticle.h"
#import "ABUtils.h"

@interface ABServerManager ()

@property (strong, nonatomic) AFHTTPSessionManager* sessionManager;

@end

@implementation ABServerManager

+ (ABServerManager*) sharedManager {
    
    static ABServerManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[ABServerManager alloc] init];
        
    });
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSURL* baseURL = [NSURL URLWithString:@"https://newsapi.org/v1/"];
        
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    }
    return self;
}

- (void) getSoursesFromServerForCategory:(NSString*)category
                            withLanguage:(NSString*)language
                              andCountry:(NSString*)country
                               onSuccess:(void(^)(NSArray* sourses))success
                               onFailure:(void(^)(NSError* error))failure {

    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:category,     @"category",
                                                                      language,     @"language",
                                                                      country,      @"country",   nil];
    
    [self.sessionManager GET:@"sources"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

                         ABLog(@"JSON -sources- %@", responseObject);
                         
                         NSArray* sources = [responseObject objectForKey:@"sources"];
                         
                         NSArray* sourcesArray = [FEMDeserializer collectionFromRepresentation:sources mapping:[ABSource defaultMapping]];
                         
                         success(sourcesArray);
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                         NSLog(@"ERROR - %@", [error localizedDescription]);
                     }];
    
}

- (void) getNewsFromSourse:(NSString*)sourceID
                WithAPIKey:(NSString*)apiKey
                   andSort:(NSString*)sort
                 onSuccess:(void(^)(NSArray* articles))success
                 onFailure:(void(^)(NSError* error))failure {
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:sourceID,     @"source",
                                                                      apiKey,       @"apiKey",
                                                                      sort,         @"sortBy",   nil];
    
    [self.sessionManager GET:@"articles"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         
                         ABLog(@"JSON -articles- %@", responseObject);
                         
                         NSArray* articles = [responseObject objectForKey:@"articles"];

                         NSArray* articlesArray = [FEMDeserializer collectionFromRepresentation:articles mapping:[ABArticle defaultMapping]];

                         success(articlesArray);
                     }
     
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                         NSLog(@"ERROR - get articles - %@", [error localizedDescription]);
                     }];

}

@end
