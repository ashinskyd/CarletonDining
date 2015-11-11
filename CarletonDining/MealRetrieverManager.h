//
//  MealRetrieverManager.h
//  CarletonDining
//
//  Created by Ashinsky, David on 11/11/15.
//  Copyright © 2015 Ashinsky, David. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MealRetrieverManager : NSObject

@property NSMutableDictionary *dinnerMenu;
@property NSMutableDictionary *lunchMenu;
@property NSMutableDictionary *brunchMenu;
@property NSMutableDictionary *breakfastMenu;

@property NSURL *diningUrl;

-(void)setupMenuData;

-(id)initWithURL:(NSURL *)url;

@end
