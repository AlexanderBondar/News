//
//  ABArticle.m
//  NewsApi
//
//  Created by Alexandr Bondar on 16.11.16.
//  Copyright © 2016 Alexandr Bondar. All rights reserved.
//

#import "ABArticle.h"

@implementation ABArticle

+ (FEMMapping*) defaultMapping {
    
    FEMMapping* mapping = [[FEMMapping alloc] initWithObjectClass:self];
    
    [mapping addAttributesFromArray:@[@"author", @"title", @"urlToImage", @"publishedAt"]];
    [mapping addAttributesFromDictionary:@{@"text":@"description", @"urlToArticles":@"url"}];
    
    return mapping;
    
}

@end
