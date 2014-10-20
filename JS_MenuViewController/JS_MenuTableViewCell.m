//
//  JS_MenuTableViewCell.m
//  UIPlayground
//
//  Created by mozeal on 10/19/2557 BE.
//  Copyright (c) 2557 Jimmy Software. All rights reserved.
//

#import "JS_MenuTableViewCell.h"
#import "pop.h"

@implementation JS_MenuTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.textColor = [UIColor grayColor];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.font = [UIFont fontWithName:@"Avenir-Light" size:22];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    if (self.highlighted) {
        POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        scaleAnimation.duration = 0.1;
        scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0.95, 0.95)];
        [self.textLabel pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    } else {
        POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
        scaleAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(2, 2)];
        scaleAnimation.springBounciness = 20.f;
        [self.textLabel pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    }
}

@end
