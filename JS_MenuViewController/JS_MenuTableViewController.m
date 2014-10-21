//
//  JS_MenuTableViewController.m
//  UIPlayground
//
//  Created by mozeal on 10/19/2557 BE.
//  Copyright (c) 2557 Jimmy Software. All rights reserved.
//

#import "JS_MenuTableViewController.h"
#import "JS_MenuTableViewCell.h"
#import "PresentingAnimator.h"
#import "DismissingAnimator.h"

static NSString * const kCellIdentifier = @"jsmenucellIdentifier";

@interface JS_MenuTableViewController ()  <UIViewControllerTransitioningDelegate>

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

- (void) viewWillAppear:(BOOL)animated
{
    [self setToolbarItems:nil];
    [self.navigationController setToolbarHidden:YES];
}

- (void) viewDidAppear:(BOOL)animated
{
    UIView *parentView = [self.view superview];
    if( parentView ) {
        UIView *dimmingView  = [parentView viewWithTag:9997];
        if( dimmingView ) {
            NSLog( @"DIMMING: Found" );
            UITapGestureRecognizer *singleFingerTap =
            [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
            [dimmingView addGestureRecognizer:singleFingerTap];
        }
    }
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    CGPoint location __unused = [recognizer locationInView:[recognizer.view superview]];
    
    
    if( _delegate && [_delegate respondsToSelector:@selector(JS_MenuTableViewController:selected:)] ) {
        [_delegate JS_MenuTableViewController:self selected:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureTitleView
{
    UILabel *headlinelabel = [UILabel new];
    headlinelabel.font = [UIFont fontWithName:@"Avenir-Light" size:26];
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
    if( !viewController ) {
        if( _delegate && [_delegate respondsToSelector:@selector(JS_MenuTableViewController:selected:)] )
        {
            [_delegate JS_MenuTableViewController:self selected:[self titleForRowAtIndexPath:indexPath]];
        }
        return;
    }
    
    viewController.title = [self titleForRowAtIndexPath:indexPath];
    if( !viewController.view ) {
        viewController.view = [[UIView alloc] initWithFrame:[self.view bounds]];
    }
    
    NSDictionary *params = [self parametersForRowAtIndexPath:indexPath];
    if( params ) {
    for( NSString *key in [params allKeys] ) {
        [viewController setValue:[params objectForKey:key] forKey:key];
    }
    }
    
    NSString *type = [self presentationTypeForRowAtIndexPath:indexPath];
    if( [type isEqualToString:@"Push"] ) {
    [self.navigationController pushViewController:viewController
                                         animated:YES];
}
    else if( [type isEqualToString:@"Present"] ) {
        [self createDismissButton:viewController];
        [self.navigationController presentViewController:viewController animated:YES completion:nil];
    }
    else if( [type isEqualToString:@"Popup"] ) {
        viewController.view.layer.cornerRadius = 8.f;
        viewController.view.backgroundColor = [UIColor whiteColor];
        viewController.view.clipsToBounds = YES;
        

        [self createDismissButton:viewController];
        
        
        viewController.transitioningDelegate = self;
        viewController.modalPresentationStyle = UIModalPresentationCustom;
        
        
        
        [self performSelector:@selector(present:) withObject:viewController afterDelay:0.4];

    }
}

- (void)createDismissButton:(UIViewController *)viewController
{
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeSystem];
    dismissButton.translatesAutoresizingMaskIntoConstraints = NO;
    dismissButton.tintColor = [UIColor yellowColor];
    dismissButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:20];
    [dismissButton setTitle:@"Dismiss" forState:UIControlStateNormal];
    [dismissButton addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [viewController.view addSubview:dismissButton];
    [viewController.view bringSubviewToFront:dismissButton];
    
    [viewController.view addConstraint:[NSLayoutConstraint constraintWithItem:dismissButton
                                                                    attribute:NSLayoutAttributeCenterX
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:viewController.view
                                                                    attribute:NSLayoutAttributeCenterX
                                                                   multiplier:1.f
                                                                     constant:0.f]];
    
    
    [viewController.view addConstraints:[NSLayoutConstraint
                                         constraintsWithVisualFormat:@"V:[dismissButton]-|"
                                         options:0
                                         metrics:nil
                                         views:NSDictionaryOfVariableBindings(dismissButton)]];
}

- (void)present:(id)sender
{
    [self.navigationController presentViewController:sender animated:YES completion:nil];
}

- (void)dismiss:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    return [PresentingAnimator new];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [DismissingAnimator new];
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

- (NSString *)presentationTypeForRowAtIndexPath:(NSIndexPath *)indexPath {
    if( [self.items[indexPath.row] count] < 2 )
         return nil;
    return [self.items[indexPath.row] objectAtIndex:1];
}

- (UIViewController *)viewControllerForRowAtIndexPath:(NSIndexPath *)indexPath {
    if( [self.items[indexPath.row] count] < 3 )
        return nil;
    return [NSClassFromString([self.items[indexPath.row] objectAtIndex:2]) new];
}

- (NSDictionary *)parametersForRowAtIndexPath:(NSIndexPath *)indexPath {
    if( [self.items[indexPath.row] count] < 4 )
        return nil;
    return [self.items[indexPath.row] objectAtIndex:3];
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
