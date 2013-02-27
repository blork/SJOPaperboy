//
//  PaperboyLocationManager.h
//  Pinner
//
//  Created by Sam Oakley on 16/02/2013.
//  Copyright (c) 2013 Sam Oakley. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface SJOPaperboyLocationManager : NSObject<CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager* locationManager;
@property (copy, nonatomic) dispatch_block_t locationChangedBlock;
+ (CLLocationManager*) sharedLocationManager;
+ (SJOPaperboyLocationManager*) sharedInstance;
@end
