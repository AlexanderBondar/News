//
//  ABArticle.h
//  NewsApi
//
//  Created by Alexandr Bondar on 16.11.16.
//  Copyright © 2016 Alexandr Bondar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FastEasyMapping.h>

@interface ABArticle : NSObject

@property (copy, nonatomic) NSString* author;
@property (copy, nonatomic) NSString* title;
@property (copy, nonatomic) NSString* text;
@property (copy, nonatomic) NSString* publishedAt;
@property (copy, nonatomic) NSString* urlToImage;
@property (copy, nonatomic) NSString* urlToArticles;

+ (FEMMapping*) defaultMapping;

@end
