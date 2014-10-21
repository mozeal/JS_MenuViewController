//
//  JS_MenuTableViewController.h
//  UIPlayground
//
//  Created by mozeal on 10/19/2557 BE.
//  Copyright (c) 2557 Jimmy Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JS_MenuTableViewController;

@protocol JS_MenuTableViewControllerDelegate <NSObject>
@optional
-(void)JS_MenuTableViewController:(JS_MenuTableViewController *)viewController selected:(NSString *)command;
@end

@interface JS_MenuTableViewController : UITableViewController
@property(nonatomic,strong) id<JS_MenuTableViewControllerDelegate> delegate;
@property(nonatomic) NSArray *items;
@end
