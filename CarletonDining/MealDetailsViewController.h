//
//  FirstViewController.h
//  CarletonDining
//
//  Created by Ashinsky, David on 11/9/15.
//  Copyright © 2015 Ashinsky, David. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MealDetailsViewController : UIViewController<UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *MenuTable;
@property NSString *desiredMeal;
@property NSDictionary *passedMealItems;

@end

