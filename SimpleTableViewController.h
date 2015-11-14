//
//  SimpleTableViewController.h
//  CarletonDining
//
//  Created by Ashinsky, David on 11/10/15.
//  Copyright © 2015 Ashinsky, David. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
- (IBAction)showPopover:(id)sender;

@end
