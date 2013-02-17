//
//  SJOAppDelegate.h
//  SJOPaperboyExample
//
//  Created by Sam Oakley on 17/02/2013.
//  Copyright (c) 2013 Sam Oakley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface SJOAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CLLocationManager *paperboyLocationManager;

@end
