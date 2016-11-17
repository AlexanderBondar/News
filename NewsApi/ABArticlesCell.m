//
//  ABArticlesCell.m
//  NewsApi
//
//  Created by Alexandr Bondar on 17.11.16.
//  Copyright © 2016 Alexandr Bondar. All rights reserved.
//

#import "ABArticlesCell.h"

@implementation ABArticlesCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (CGFloat) heightForCellWithText:(NSString*)text {
    
    CGFloat offset = 10.f;
    
    UIFont* font = [UIFont systemFontOfSize:17.f];
    
    NSShadow* shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(0, -1);
    shadow.shadowBlurRadius = 0.5;
    
    NSMutableParagraphStyle* paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setLineBreakMode:NSLineBreakByWordWrapping];
    
    [paragraph setAlignment:NSTextAlignmentLeft];
    NSDictionary* attributes = [NSDictionary dictionaryWithObjectsAndKeys:font,      NSFontAttributeName,
                                shadow,    NSShadowAttributeName,
                                paragraph, NSParagraphStyleAttributeName, nil];
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake([UIApplication sharedApplication].keyWindow.frame.size.width - offset*2, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:attributes
                                     context:nil];
    
    
    return CGRectGetHeight(rect) + 44;
    
}


@end
