//
//  JS_MenuTableViewController.m
//  UIPlayground
//
//  Created by mozeal on 10/19/2557 BE.
//  Copyright (c) 2557 Jimmy Software. All rights reserved.
//

#import "JS_MenuTableViewController.h"
#import "JS_MenuTableViewCell.h"

static NSString * const kCellIdentifier = @"jsmenucellIdentifier";

@interface JS_MenuTableViewController ()

@end

@implementation JS_MenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" "
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    if( !self.title ) {
        self.title = @"UIPlayground";
    }
    [self configureTitleView];
    [self configureTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureTitleView
{
    UILabel *headlinelabel = [UILabel new];
    headlinelabel.font = [UIFont fontWithName:@"Avenir-Light" size:28];
    headlinelabel.textAlignment = NSTextAlignmentCenter;
    headlinelabel.textColor = [UIColor whiteColor];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.title];
    if( [self.title isEqualToString:@"UIPlayground"] ) {
        [attributedString addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor yellowColor]
                                 range:NSMakeRange(0, 2)];
    }
    
    headlinelabel.attributedText = attributedString;
    [headlinelabel sizeToFit];
    
    [self.navigationItem setTitleView:headlinelabel];
}

- (void)configureTableView
{

    [self.tableView registerClass:[JS_MenuTableViewCell class]
           forCellReuseIdentifier:kCellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 50.f;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *viewController = [self viewControllerForRowAtIndexPath:indexPath];
    viewController.title = [self titleForRowAtIndexPath:indexPath];
    
    NSDictionary *params = [self parametersForRowAtIndexPath:indexPath];
    for( NSString *key in [params allKeys] ) {
        [viewController setValue:[params objectForKey:key] forKey:key];
    }
    
    [self.navigationController pushViewController:viewController
                                         animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JS_MenuTableViewCell *cell = (JS_MenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier
                                                                                         forIndexPath:indexPath];
    cell.textLabel.text = [self.items[indexPath.row] firstObject];
    
    return cell;
}

- (NSString *)titleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.items[indexPath.row] firstObject];
}

- (UIViewController *)viewControllerForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [NSClassFromString([self.items[indexPath.row] objectAtIndex:1]) new];
}

- (NSDictionary *)parametersForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.items[indexPath.row] lastObject];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


@end
