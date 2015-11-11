//
//  SchillerRefreshControl.h
//  CarletonDining
//
//  Created by Ashinsky, David on 11/11/15.
//  Copyright © 2015 Ashinsky, David. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SchillerRefreshControl : UIRefreshControl


@property UIRefreshControl* refreshControl;
@property UIView *refreshLoadingView;
@property UIView *refreshColorView;


@property UIImageView *schillerImage;

@property bool isRefreshIconsOverlap;
@property bool isRefreshAnimating;


- (void)setupRefreshControl;

@end
