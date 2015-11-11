//
//  DiningHallHoursManager.h
//  CarletonDining
//
//  Created by Ashinsky, David on 11/10/15.
//  Copyright © 2015 Ashinsky, David. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiningHallHoursManager : NSObject

@property NSString *breakfastTimes;
@property NSString *brunchTimes;
@property NSString *lunchTimes;
@property NSString *dinnerTimes;

-(DiningHallHoursManager *)initWithDiningHallIsBurton:(bool)isBurton;

-(void)getDiningHallHours;
@end
