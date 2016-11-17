//
//  ABSourceCell.h
//  NewsApi
//
//  Created by Alexandr Bondar on 16.11.16.
//  Copyright © 2016 Alexandr Bondar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABSourceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView* logoImageView;
@property (weak, nonatomic) IBOutlet UILabel* nameSourceLabel;

@end
