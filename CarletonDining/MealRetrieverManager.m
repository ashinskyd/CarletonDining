//
//  MealRetrieverManager.m
//  CarletonDining
//
//  Created by Ashinsky, David on 11/11/15.
//  Copyright © 2015 Ashinsky, David. All rights reserved.
//

#import "MealRetrieverManager.h"
#import "MealItem.h"
#import "TFHpple.h"

@interface MealRetrieverManager()

@property NSMutableArray *breakfastItems;
@property NSMutableArray *lunchItems;
@property NSMutableArray *dinnerItems;
@property NSMutableArray *brunchItems;

-(void) setupMealsWithStations;
-(void)traverseMealItems:(TFHppleElement *) withStartingElement;

@end

@implementation MealRetrieverManager

-(id)initWithURL:(NSURL *)url{
    _diningUrl = url;
    _breakfastItems = [[NSMutableArray alloc] init];
    _brunchItems = [[NSMutableArray alloc] init];
    _lunchItems = [[NSMutableArray alloc] init];
    _dinnerItems = [[NSMutableArray alloc] init];
    _breakfastMenu = [[NSMutableDictionary alloc] init];
    _lunchMenu = [[NSMutableDictionary alloc] init];
    _dinnerMenu = [[NSMutableDictionary alloc] init];
    _brunchMenu = [[NSMutableDictionary alloc] init];
    return self;
}

-(void)setupMenuData{
    NSData *data = [NSData dataWithContentsOfURL:_diningUrl];
    TFHpple * doc       = [[TFHpple alloc] initWithHTMLData:data];
    NSArray * rootTableElements  = [doc searchWithXPathQuery:@"//table[@class='my-day-menu-table']"];
    if([rootTableElements count]>0){
        TFHppleElement *parentTableElement  = rootTableElements[0];
        [self traverseMealItems:parentTableElement];
        [self setupMealsWithStations];
    }
}


-(void)traverseMealItems:(TFHppleElement *) withStartingElement{
    NSString *kitchen;
    NSString *currentMeal = @"Brunch";
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
                        currentMeal = @"Breakfast";
                        continue;
                    }else if([[potentialItem text] isEqualToString:@"Brunch"]){
                        continue;
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
                    }else if([currentMeal isEqualToString:@"Brunch"] ){
                        [_brunchItems addObject:mealEntry];
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

-(void) setupMealsWithStations{
    NSMutableArray *kitchens = [[NSMutableArray alloc] init];
    for( Mealitem *i in _brunchItems){
        if(! [kitchens containsObject:[i kitchen]]){
            [kitchens  addObject:[i kitchen]];
        }
    }for( NSString *i in kitchens){
        [_brunchMenu setObject:[[NSMutableArray alloc] initWithCapacity:0] forKey:i];
    }
    for( Mealitem *i in _brunchItems){
        NSMutableArray *oldItems = [_brunchMenu objectForKey:[i kitchen]];
        [oldItems addObject:i];
        [_brunchMenu setObject:oldItems forKey:[i kitchen]];
    }
    [kitchens removeAllObjects];
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

@end
