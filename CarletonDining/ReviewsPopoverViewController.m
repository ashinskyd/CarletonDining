//
//  ReviewsPopoverViewController.m
//  CarletonDining
//
//  Created by Ashinsky, David on 11/12/15.
//  Copyright © 2015 Ashinsky, David. All rights reserved.
//

#import "ReviewsPopoverViewController.h"
#import <Parse/Parse.h>

@interface ReviewsPopoverViewController ()

@end

@implementation ReviewsPopoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_tableview setDelegate:self];
    [_tableview setDataSource:self];
    UINib *nib = [UINib nibWithNibName:@"MenuItemCellTableViewCell" bundle:nil];
    [_tableview registerNib:nib forCellReuseIdentifier:@"MealCell"];
    // Do any additional setup after loading the view from its nib.
    PFQuery *query = [PFQuery queryWithClassName:@"TestObject"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully found object!.");
            // Do something with the found objects
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableView *cell = [_tableview dequeueReusableCellWithIdentifier:@"MealCell"];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
