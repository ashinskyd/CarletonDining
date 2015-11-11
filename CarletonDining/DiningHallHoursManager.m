//
//  DiningHallHoursManager.m
//  CarletonDining
//
//  Created by Ashinsky, David on 11/10/15.
//  Copyright © 2015 Ashinsky, David. All rights reserved.
//

#import "DiningHallHoursManager.h"
#import "TFHpple.h"

@interface DiningHallHoursManager()

@property NSURL *url;


typedef enum dateType{
    Sunday = 1,
    Monday = 2,
    Tuesday = 3,
    Wednesday = 4,
    Thursday = 5,
    Friday = 6,
    Saturday = 7
}dateType;

@end

@implementation DiningHallHoursManager

-(DiningHallHoursManager *)initWithDiningHallIsBurton:(bool)isBurton{
    _url = [NSURL URLWithString:@"https://apps.carleton.edu/campus/dining_services/facilities/"];
    _breakfastTimes = @"";
    NSData *data = [NSData dataWithContentsOfURL:_url];
    NSCalendar* calender = [NSCalendar currentCalendar];
    NSDateComponents* component = [calender components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    dateType currentDay = (dateType)[component weekday];
    TFHpple * doc       = [[TFHpple alloc] initWithHTMLData:data];
    NSArray * rootTableElements  = [doc searchWithXPathQuery:@"//div[@id='pageContent']"];
    if([rootTableElements count]>0){
        TFHppleElement *parentTableElement  = rootTableElements[0];
        if(isBurton){
            parentTableElement = [[parentTableElement childrenWithTagName:@"table"][1] firstChildWithTagName:@"tbody"];
            NSArray *hoursElements =[parentTableElement childrenWithTagName:@"tr"];
            _dinnerTimes = [[hoursElements[7] childrenWithTagName:@"td"][2] text];
            _lunchTimes = [[hoursElements[5] childrenWithTagName:@"td"][2] text];
            if (currentDay==Sunday || currentDay == Saturday){
                _brunchTimes = [[hoursElements[3] childrenWithTagName:@"td"][2] text];
                _breakfastTimes = @"CLOSED";
            }else{
                _brunchTimes = @"CLOSED";
                _breakfastTimes = [[hoursElements[0] childrenWithTagName:@"td"][2] text];
            }

        }else{
            parentTableElement = [[parentTableElement firstChildWithTagName:@"table"] firstChildWithTagName:@"tbody"];
            NSArray *hoursElements =[parentTableElement childrenWithTagName:@"tr"];
            _dinnerTimes = [[hoursElements[9] childrenWithTagName:@"td"][2] text];
            if (currentDay>Sunday && currentDay <Saturday){
                _breakfastTimes = [[hoursElements[0] childrenWithTagName:@"td"][2] text];
                _brunchTimes = @"CLOSED";
            }else if( currentDay == Saturday ){
                _breakfastTimes = [[hoursElements[1] childrenWithTagName:@"td"][2] text];
                _brunchTimes = [[hoursElements[3] childrenWithTagName:@"td"][2] text];
                
            }else{
                _breakfastTimes = @"CLOSED";
                _lunchTimes = @"CLOSED";
                _brunchTimes = [[hoursElements[3] childrenWithTagName:@"td"][2] text];
            }
            if( currentDay==Monday || currentDay== Wednesday){
                _lunchTimes = [[hoursElements[5] childrenWithTagName:@"td"][2] text];
            }else if(currentDay != Sunday && currentDay != Saturday){
                _lunchTimes = [[hoursElements[6] childrenWithTagName:@"td"][2] text];
            }else if(currentDay == Saturday){
                _lunchTimes = [[hoursElements[7] childrenWithTagName:@"td"][2] text];
            }

        }
    }
    return self;
}


@end
