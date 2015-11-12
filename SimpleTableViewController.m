//
//  SimpleTableViewController.m
//  CarletonDining
//
//  Created by Ashinsky, David on 11/10/15.
//  Copyright © 2015 Ashinsky, David. All rights reserved.
//

#import "SimpleTableViewController.h"
#import "TFHpple.h"
#import "MealDetailsViewController.h"
#import "DiningHallHoursManager.h"
#import "MealRetrieverManager.h"
#import "Mealitem.h"

@interface SimpleTableViewController ()

@property NSURL *diningUrl;
@property bool isBurton;

@property DiningHallHoursManager *hoursManager;
@property MealRetrieverManager *mealRetriever;

@end

@implementation SimpleTableViewController

#pragma tableView delegate methods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *lbl = [[UILabel alloc] init];
    lbl.textAlignment = UITextAlignmentCenter;
    lbl.font = [UIFont fontWithName:@"Helvetica" size:14];
    switch (section){
        case 0:
            lbl.text = [_hoursManager brunchTimes];
            break;
        case 1:
            lbl.text = [_hoursManager breakfastTimes];
            break;
        case 2:
            lbl.text = [_hoursManager lunchTimes];
            break;
        
        case 3:
            lbl.text = [_hoursManager dinnerTimes];
            break;
    }
    lbl.textColor = [UIColor whiteColor];
    lbl.shadowColor = [UIColor grayColor];
    lbl.shadowOffset = CGSizeMake(0,1);
    lbl.backgroundColor = [UIColor blueColor];
    lbl.alpha = 0.9;
    return lbl;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SimpleCell"];
    UIImageView *imageContent = [cell.contentView viewWithTag:1];
    switch( [indexPath section]){
        case 0:
            if([[[_mealRetriever brunchMenu] allKeys] count] == 0){
                cell.userInteractionEnabled = NO;
                cell.textLabel.enabled = cell.isUserInteractionEnabled;
            }else{
                cell.userInteractionEnabled = YES;
            }
            imageContent.image = [UIImage imageNamed:@"brunch.png"];
            
            [cell.textLabel setText: @"Brunch"];
            break;
        case 1:
            if([[[_mealRetriever breakfastMenu] allKeys] count] == 0){
                cell.userInteractionEnabled = NO;
                cell.textLabel.enabled = cell.isUserInteractionEnabled;
            }else{
                cell.userInteractionEnabled = YES;
            }
            imageContent.image = [UIImage imageNamed:@"breakfast.png"];
            
            [cell.textLabel setText: [NSString stringWithFormat:@"Breakfast"]];
            break;
            
        case 2:
            if([[[_mealRetriever lunchMenu] allKeys] count] == 0){
                cell.userInteractionEnabled = NO;
                cell.textLabel.enabled = cell.isUserInteractionEnabled;
            }else{
                cell.userInteractionEnabled = YES;
            }
            [cell.textLabel setText: @"Lunch"];
            imageContent.image = [UIImage imageNamed:@"lunch.png"];
            
            break;
        case 3:
            if([[[_mealRetriever dinnerMenu] allKeys] count] == 0){
                cell.userInteractionEnabled = NO;
                cell.textLabel.enabled = cell.isUserInteractionEnabled;
            }else{
                cell.userInteractionEnabled = YES;
            }
            [cell.textLabel setText: @"Dinner"];
            imageContent.image = [UIImage imageNamed:@"dinner.png"];
            
            break;
    }
    [[cell contentView] addSubview:imageContent];
    
    cell.textLabel.enabled = cell.isUserInteractionEnabled;
    return cell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if([[self tabBarController] selectedIndex] == 0){
        _diningUrl = [NSURL URLWithString:@"http://legacy.cafebonappetit.com/print-menu/cafe/35/menu/92399/days/today/pgbrks/0/"];
        _isBurton = YES;
    
    }else{
            _diningUrl = [NSURL URLWithString:@"http://legacy.cafebonappetit.com/print-menu/cafe/36/menu/92475/days/today/pgbrks/0"];
        _isBurton = NO;
    }
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor blueColor];
    self.refreshControl.tintColor = [UIColor yellowColor];
    [self.refreshControl addTarget:self
                            action:@selector(updateMenuData)
                  forControlEvents:UIControlEventValueChanged];
    _mealRetriever = [[MealRetrieverManager alloc] initWithURL:_diningUrl];
    _hoursManager = [[DiningHallHoursManager alloc] initWithDiningHallIsBurton:_isBurton];
    [[self spinner] startAnimating];
    [self updateMenuData];
}

-(void)updateMenuData{
    __block bool finished = NO;
    __block bool shouldExecute = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^(void){
            if (!finished) {
                shouldExecute = NO;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[self refreshControl] endRefreshing];
                    [[self spinner] stopAnimating];
                                       [[self tableView] reloadData];
                });
            }
        });
        [_mealRetriever setupMenuData];
        [_hoursManager getDiningHallHours];
        finished = YES;
        if(shouldExecute){
            dispatch_async(dispatch_get_main_queue(), ^{
                [[self refreshControl] endRefreshing];
                [[self spinner] stopAnimating];
                [[self tableView] reloadData];
                
            });
        }

    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    MealDetailsViewController* dest = [segue destinationViewController];
    if( [[[self tableView] indexPathForCell:sender] section]==0 ){
        dest.desiredMeal = @"Brunch";
        dest.passedMealItems = [_mealRetriever brunchMenu];
    }else if( [[[self tableView] indexPathForCell:sender] section]==1 ){
        dest.desiredMeal = @"Breakfast";
        dest.passedMealItems = [_mealRetriever breakfastMenu];
    }else if( [[[self tableView] indexPathForCell:sender] section]==2){
        dest.desiredMeal = @"Lunch";
        dest.passedMealItems = [_mealRetriever lunchMenu];
    }else{
        dest.desiredMeal = @"Dinner";
        dest.passedMealItems = [_mealRetriever dinnerMenu];
    }
    
}
#pragma mark - Navigation


@end
