//
//  FirstViewController.m
//  CarletonDining
//
//  Created by Ashinsky, David on 11/9/15.
//  Copyright © 2015 Ashinsky, David. All rights reserved.
//

#import "MealDetailsViewController.h"
#import "MenuItemCellTableViewCell.h"
#import "TFHpple.h"
#import "Mealitem.h"

@interface MealDetailsViewController ()

@end

@implementation MealDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = _desiredMeal;

    UINib *nib = [UINib nibWithNibName:@"MenuItemCellTableViewCell" bundle:nil];
    [_MenuTable registerNib:nib forCellReuseIdentifier:@"MealCell"];
    _MenuTable.estimatedRowHeight = 100;
    _MenuTable.rowHeight = UITableViewAutomaticDimension;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *key = [_passedMealItems allKeys][section];
    return [[_passedMealItems objectForKey:key] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *key = [_passedMealItems allKeys][[indexPath section] ];
    Mealitem *value = [_passedMealItems objectForKey:key][[indexPath row]];
    NSArray *addOns = [value specials];
    MenuItemCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MealCell"];
    NSMutableArray<UIImageView *> *images = [[NSMutableArray alloc] initWithObjects:[cell Image0],[cell Image1], [cell Image2],[cell Image3],nil];
    for(UIImageView *i in images){
        i.image = nil;
    }
    for(int i=0;i<[addOns count];i++){
        if([[value name] containsString:@"Yuc"]){
            NSLog(@"CALLINGF!");
        }
        if([[addOns objectAtIndex:i] intValue]==glutentFree){
            images[i].image = [UIImage imageNamed:@"gluten-free.png"];
        }else if([[addOns objectAtIndex:i] intValue]==vegan){
            images[i].image = [UIImage imageNamed:@"vegan.png"];
        }else if([[addOns objectAtIndex:i] intValue] == vegetarian){
             images[i].image = [UIImage imageNamed:@"vegetarian.png"];
        }else if([[addOns objectAtIndex:i] intValue]== farmToFork){
            images[i].image = [UIImage imageNamed:@"ftf.png"];
        }else if([[addOns objectAtIndex:i] intValue]== locallyCrafted ){
            images[i].image = [UIImage imageNamed:@"lc.png"];
        }
    }
    cell.MenuText.text = [value name];
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [[_passedMealItems allKeys] count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_passedMealItems allKeys][section];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
