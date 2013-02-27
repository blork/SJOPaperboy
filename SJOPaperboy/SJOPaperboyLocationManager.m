//
//  PaperboyLocationManager.m
//  Pinner
//
//  Created by Sam Oakley on 16/02/2013.
//  Copyright (c) 2013 Sam Oakley. All rights reserved.
//

#import "SJOPaperboyLocationManager.h"

@implementation SJOPaperboyLocationManager

- (id)init
{
    self = [super init];
    if (self != nil) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    }
    return self;
}

+ (SJOPaperboyLocationManager*)sharedInstance
{
    static SJOPaperboyLocationManager *sharedLocationManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedLocationManagerInstance = [[self alloc] init];
    });
    return sharedLocationManagerInstance;
}


+ (CLLocationManager*)sharedLocationManager
{
    return [SJOPaperboyLocationManager sharedInstance].locationManager;
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    [self locationChanged];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    [self locationChanged];
}

-(void)locationChanged
{
    /*
     * There is a bug in iOS that causes didEnter/didExitRegion to be called multiple
     * times for one location change (http://openradar.appspot.com/radar?id=2484401). 
     * Here, we rate limit it to prevent performing the update twice in quick succession.
     */
    
    static long timestamp;
    
    if (timestamp == 0) {
        timestamp = [[NSDate date] timeIntervalSince1970];
    } else {
        if ([[NSDate date] timeIntervalSince1970] - timestamp < 10) {
            return;
        }
    }
    
    if (self.locationChangedBlock) {
        self.locationChangedBlock();
    }
}

@end
