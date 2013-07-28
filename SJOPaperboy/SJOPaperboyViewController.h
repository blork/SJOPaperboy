//
//  PaperboyViewController.h
//  Pinner
//
//  Created by Sam Oakley on 13/02/2013.
//  Copyright (c) 2013 Sam Oakley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import <CoreLocation/CoreLocation.h>

@class IPInsetLabel;
@interface SJOPaperboyViewController : UITableViewController<CLLocationManagerDelegate>

@property (nonatomic, strong) UIFont *labelFont;
@property (nonatomic, strong) CLLocationManager *locationManager;
+ (BOOL) isBackgroundUpdatingEnabled;
+ (BOOL) isLocationUpdatingEnabled;
+ (void) setDefaultBackgroundValue:(BOOL) isBackgroundingEnabled;
+ (void) setDefaultLocationUpdateValue:(BOOL) areLocationUpdatesEnabled;
+ (NSArray*) locationsForUpdate;

@end
