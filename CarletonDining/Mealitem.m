//
//  Mealitem.m
//  CarletonDining
//
//  Created by Ashinsky, David on 11/9/15.
//  Copyright © 2015 Ashinsky, David. All rights reserved.
//

#import "Mealitem.h"

@implementation Mealitem

-(Mealitem *)init{
    self.specials = [[NSMutableArray alloc] init];
    self.name = [[NSString alloc] init];
    self.kitchen = [[NSString alloc] init];
    return self;
}
@end
