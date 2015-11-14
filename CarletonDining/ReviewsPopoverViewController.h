//
//  ReviewsPopoverViewController.h
//  CarletonDining
//
//  Created by Ashinsky, David on 11/12/15.
//  Copyright © 2015 Ashinsky, David. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewsPopoverViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
- (IBAction)dismiss:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@end
