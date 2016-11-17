//
//  ABArticlesController.h
//  NewsApi
//
//  Created by Alexandr Bondar on 17.11.16.
//  Copyright © 2016 Alexandr Bondar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABSource.h"
#import "PINImageView+PINRemoteImage.h"


@interface ABArticlesController : UITableViewController

@property (strong, nonatomic) ABSource* source;

@end
