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
#import "SchillerRefreshControl.h"
#import "DiningHallHoursManager.h"
#import "Mealitem.h"

@interface SimpleTableViewController ()

-(void)traverseMealItems:(TFHppleElement *) withStartingElement;
-(void)setupMenuData;
-(void)setupNumberOfSections;
-(void)updateMenuData;

@property NSURL *diningUrl;
@property NSMutableArray *breakfastItems;
@property NSMutableDictionary *breakfastMenu;
@property NSMutableArray *lunchItems;
@property NSMutableDictionary *lunchMenu;
@property NSMutableArray *dinnerItems;
@property NSMutableDictionary *dinnerMenu;
@property NSMutableArray *brunchItems;
@property NSMutableDictionary *brunchMenu;

@property bool isBurton;

@property DiningHallHoursManager *hoursManager;

@end

@implementation SimpleTableViewController

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
            if([[_brunchMenu allKeys] count] == 0){
                cell.userInteractionEnabled = NO;
                cell.textLabel.enabled = cell.isUserInteractionEnabled;
            }else{
                cell.userInteractionEnabled = YES;
            }
            imageContent.image = [UIImage imageNamed:@"brunch.png"];
            
            [cell.textLabel setText: @"Brunch"];
            break;
        case 1:
            if([[_breakfastMenu allKeys] count] == 0){
                cell.userInteractionEnabled = NO;
                cell.textLabel.enabled = cell.isUserInteractionEnabled;
            }else{
                cell.userInteractionEnabled = YES;
            }
            imageContent.image = [UIImage imageNamed:@"breakfast.png"];
            
            [cell.textLabel setText: [NSString stringWithFormat:@"Breakfast"]];
            break;
            
        case 2:
            if([[_lunchMenu allKeys] count] == 0){
                cell.userInteractionEnabled = NO;
                cell.textLabel.enabled = cell.isUserInteractionEnabled;
            }else{
                cell.userInteractionEnabled = YES;
            }
            [cell.textLabel setText: @"Lunch"];
            imageContent.image = [UIImage imageNamed:@"lunch.png"];
            
            break;
        case 3:
            if([[_dinnerMenu allKeys] count] == 0){
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
-(void)setupMenuData{
    NSData *data = [NSData dataWithContentsOfURL:_diningUrl];
    _hoursManager = [[DiningHallHoursManager alloc] initWithDiningHallIsBurton:_isBurton];
    TFHpple * doc       = [[TFHpple alloc] initWithHTMLData:data];
    NSArray * rootTableElements  = [doc searchWithXPathQuery:@"//table[@class='my-day-menu-table']"];
    if([rootTableElements count]>0){
        TFHppleElement *parentTableElement  = rootTableElements[0];
        [self traverseMealItems:parentTableElement];
        [self setupNumberOfSections];
    }
}


-(void)traverseMealItems:(TFHppleElement *) withStartingElement{
    NSString *kitchen;
    NSString *currentMeal = @"Breakfast";
    [_breakfastMenu removeAllObjects];
    [_lunchMenu removeAllObjects];
    [_brunchMenu removeAllObjects];
    [_dinnerMenu removeAllObjects];
    [_breakfastItems removeAllObjects];
    [_lunchItems removeAllObjects];
    [_brunchItems removeAllObjects];
    [_dinnerItems removeAllObjects];
    for(TFHppleElement *e in [withStartingElement children]){
        if([[e tagName] isEqualToString:@"tr"]){
            if([e firstChildWithTagName:@"td"]){
                TFHppleElement *potentialItem = [[e firstChildWithTagName:@"td"] firstChildWithTagName:@"strong"];
                if( [[e objectForKey:@"class" ] isEqualToString:@"always-show-me"]){
                    if(  [[potentialItem text] isEqualToString:@"Lunch"] ){
                        currentMeal = @"Lunch";
                        continue;
                    }else if([[potentialItem text] isEqualToString:@"Breakfast"]){
                        continue;
                    }else if([[potentialItem text] isEqualToString:@"Brunch"]){
                        currentMeal = @"Brunch";
                    }else{
                        currentMeal = @"Dinner";
                    }
                }else if([[[potentialItem parent] objectForKey:@"class"] isEqualToString:@"child-even description"] || [[[potentialItem parent]objectForKey:@"class"] isEqualToString:@"child-odd description"] ){
                    Mealitem *mealEntry = [[Mealitem alloc] init];
                    NSArray *extras =[[potentialItem text] componentsSeparatedByString:@"("];
                    mealEntry.name = extras[0];
                    if(extras.count > 1){
                        for(int x=1;x<extras.count;x++){
                           
                            if([extras[x] containsString:@"?G"]){
                                specialArgs arg= glutentFree;
                                [mealEntry.specials addObject:[NSNumber numberWithInt:arg]];
                            }else if([extras[x] containsString:@"VG"]){
                                specialArgs arg = vegan;
                                [mealEntry.specials addObject:[NSNumber numberWithInt:arg]];
                            }else if([extras[x] containsString:@"V"]){
                                specialArgs arg = vegetarian;
                                [mealEntry.specials addObject:[NSNumber numberWithInt:arg]];
                            }else if([extras[x] containsString:@"LC"]){
                                specialArgs arg = locallyCrafted;
                                [mealEntry.specials addObject:[NSNumber numberWithInt:arg]];
                            }else if([extras[x] containsString:@"F2F"]){
                                specialArgs arg = farmToFork;
                                [mealEntry.specials addObject:[NSNumber numberWithInt:arg]];
                            }
                        }
                    }
                    mealEntry.kitchen = kitchen;
                    if( [currentMeal isEqualToString:@"Breakfast"] ){
                        [_breakfastItems addObject:mealEntry];
                    }else if([currentMeal isEqualToString:@"Lunch"] ){
                        [_lunchItems addObject:mealEntry];
                    }else if([currentMeal isEqualToString:@"Dinner"] ){
                        [_dinnerItems addObject:mealEntry];
                    }
                }else{
                    TFHppleElement *potentialItem = [[e childrenWithTagName:@"td"][1] firstChildWithTagName:@"strong"];
                    kitchen = [[[e childrenWithTagName:@"td"][0] firstChildWithTagName:@"strong"] text];
                    if( [[[potentialItem parent] objectForKey:@"class"] isEqualToString:@"child-even description"] || [[[potentialItem parent]objectForKey:@"class"] isEqualToString:@"child-odd description"] ){
                        Mealitem *mealEntry = [[Mealitem alloc] init];
                        NSArray *extras =[[potentialItem text] componentsSeparatedByString:@"("];
                        mealEntry.name = extras[0];
                        if(extras.count > 1){
                            for(int x=1;x<extras.count;x++){
                                if([extras[x] containsString:@"?G"]){
                                    specialArgs arg= glutentFree;
                                    [mealEntry.specials addObject:[NSNumber numberWithInt:arg]];
                                }else if([extras[x] containsString:@"VG"]){
                                    specialArgs arg = vegan;
                                    [mealEntry.specials addObject:[NSNumber numberWithInt:arg]];
                                }else if([extras[x] containsString:@"V"]){
                                    specialArgs arg = vegetarian;
                                    [mealEntry.specials addObject:[NSNumber numberWithInt:arg]];
                                }else if([extras[x] containsString:@"LC"]){
                                    specialArgs arg = locallyCrafted;
                                    [mealEntry.specials addObject:[NSNumber numberWithInt:arg]];
                                }else if([extras[x] containsString:@"F2F"]){
                                    specialArgs arg = farmToFork;
                                    [mealEntry.specials addObject:[NSNumber numberWithInt:arg]];
                                }
                            }
                            
                        }
                        mealEntry.kitchen = kitchen;
                        if( [currentMeal isEqualToString:@"Breakfast"] ){
                            [_breakfastItems addObject:mealEntry];
                        }else if([currentMeal isEqualToString:@"Lunch"] ){
                            [_lunchItems addObject:mealEntry];
                        }else if([currentMeal isEqualToString:@"Dinner"] ){
                            [_dinnerItems addObject:mealEntry];
                        }else if( [currentMeal isEqualToString:@"Brunch"] ){
                            [_brunchItems addObject:mealEntry];
                        }
                    }
                    
                }
                
            }
        }
    }
    return;
}

-(void) setupNumberOfSections{
    NSMutableArray *kitchens = [[NSMutableArray alloc] init];
    for( Mealitem *i in _breakfastItems){
        if(! [kitchens containsObject:[i kitchen]]){
            [kitchens  addObject:[i kitchen]];
        }
    }for( NSString *i in kitchens){
        [_breakfastMenu setObject:[[NSMutableArray alloc] initWithCapacity:0] forKey:i];
    }
    for( Mealitem *i in _breakfastItems){
        NSMutableArray *oldItems = [_breakfastMenu objectForKey:[i kitchen]];
        [oldItems addObject:i];
        [_breakfastMenu setObject:oldItems forKey:[i kitchen]];
    }
    [kitchens removeAllObjects];
    for( Mealitem *i in _lunchItems){
        if(! [kitchens containsObject:[i kitchen]]){
            [kitchens  addObject:[i kitchen]];
        }
    }for( NSString *i in kitchens){
        [_lunchMenu setObject:[[NSMutableArray alloc] initWithCapacity:0] forKey:i];
    }
    for( Mealitem *i in _lunchItems){
        NSMutableArray *oldItems = [_lunchMenu objectForKey:[i kitchen]];
        [oldItems addObject:i];
        [_lunchMenu setObject:oldItems forKey:[i kitchen]];
    }
    [kitchens removeAllObjects];
    for( Mealitem *i in _dinnerItems){
        if(! [kitchens containsObject:[i kitchen]]){
            [kitchens  addObject:[i kitchen]];
        }
    }for( NSString *i in kitchens){
        [_dinnerMenu setObject:[[NSMutableArray alloc] initWithCapacity:0] forKey:i];
    }
    for( Mealitem *i in _dinnerItems){
        NSMutableArray *oldItems = [_dinnerMenu objectForKey:[i kitchen]];
        [oldItems addObject:i];
        [_dinnerMenu setObject:oldItems forKey:[i kitchen]];
    }
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

    _breakfastItems = [[NSMutableArray alloc] init];
    _brunchItems = [[NSMutableArray alloc] init];
    _lunchItems = [[NSMutableArray alloc] init];
    _dinnerItems = [[NSMutableArray alloc] init];
    self.breakfastMenu = [[NSMutableDictionary alloc] init];
    self.lunchMenu = [[NSMutableDictionary alloc] init];
    self.dinnerMenu = [[NSMutableDictionary alloc] init];
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
        [self setupMenuData];
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    MealDetailsViewController* dest = [segue destinationViewController];
    if( [[[self tableView] indexPathForCell:sender] section]==0 ){
        dest.desiredMeal = @"Brunch";
        dest.passedMealItems = _brunchMenu;
    }else if( [[[self tableView] indexPathForCell:sender] section]==1 ){
        dest.desiredMeal = @"Breakfast";
        dest.passedMealItems = _breakfastMenu;
    }else if( [[[self tableView] indexPathForCell:sender] section]==2){
        dest.desiredMeal = @"Lunch";
        dest.passedMealItems = _lunchMenu;
    }else{
        dest.desiredMeal = @"Dinner";
        dest.passedMealItems = _dinnerMenu;
    }
    
}
#pragma mark - Navigation


@end
