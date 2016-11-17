//
//  ABArticlesCell.h
//  NewsApi
//
//  Created by Alexandr Bondar on 17.11.16.
//  Copyright © 2016 Alexandr Bondar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABArticlesCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *textNewsLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

+ (CGFloat) heightForCellWithText:(NSString*)text;

@end
