//
//  Mealitem.h
//  CarletonDining
//
//  Created by Ashinsky, David on 11/9/15.
//  Copyright © 2015 Ashinsky, David. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    glutentFree=0,
    vegan=1,
    locallyCrafted=2,
    vegetarian=3,
    farmToFork=4
}specialArgs;

@interface Mealitem : NSObject

@property NSString *name;
@property NSMutableArray *specials;
@property NSString *kitchen;

-(Mealitem *)init;

@end
