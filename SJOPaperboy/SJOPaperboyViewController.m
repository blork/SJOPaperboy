//
//  PaperboyViewController.m
//  Pinner
//
//  Created by Sam Oakley on 13/02/2013.
//  Copyright (c) 2013 Sam Oakley. All rights reserved.
//

#import "SJOPaperboyViewController.h"
#import "SJOPaperboyLocationManager.h"
#import "IPInsetLabel.h"

#define kBackgroundUpdates @"paperboy_fetch_background_updates"
#define kLocationUpdates @"paperboy_background_updates"
#define kLocations @"paperboy_location_array"

@interface SJOPaperboyViewController ()

@property (nonatomic, strong) IPInsetLabel* headerLabel;
@property (nonatomic, strong) IPInsetLabel* footerLabel;
@property (assign) BOOL isLocating;
@property (assign) int numberOfSections;

-(IPInsetLabel*) styledLabelWithText:(NSString*)text;
-(void) toggleBackgroundUpdates:(id)sender;
-(void) updateGeofencedLocations;
@end


@implementation SJOPaperboyViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.title = NSLocalizedStringFromTable(@"view_controller_title", @"Paperboy", nil);
        
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        self.isLocating = NO;
        self.labelFont = [UIFont systemFontOfSize:16];
        self.numberOfSections = [SJOPaperboyViewController isLocationUpdatingEnabled] ? 3 : 1;
    }
    return self;
}

-(void)loadView
{
    [super loadView];
    
    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    NSString *deviceName = [UIDevice currentDevice].localizedModel;
    
    
    NSString* headerText;
    if ([SJOPaperboyViewController hasBackgroundModeEnabled]) {
        headerText = [NSString stringWithFormat:NSLocalizedStringFromTable(@"header_text_plus_fetch", @"Paperboy", nil), appName];
    } else {
        headerText = [NSString stringWithFormat:NSLocalizedStringFromTable(@"header_text", @"Paperboy", nil), appName];
    }
    
    NSString* footerText = [NSString stringWithFormat:NSLocalizedStringFromTable(@"footer_text", @"Paperboy", nil), appName, deviceName];
    
    self.headerLabel = [self styledLabelWithText:headerText];
    self.footerLabel = [self styledLabelWithText:footerText];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateGeofencedLocations];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.headerLabel.frame = CGRectMake(0, 0, self.view.bounds.size.width, 0);
    [self.headerLabel resizeHeightToFitText];
    self.tableView.tableHeaderView = self.headerLabel;
    
    self.footerLabel.frame = CGRectMake(0, 0, self.view.bounds.size.width, 0);
    [self.footerLabel resizeHeightToFitText];
    self.tableView.tableFooterView = self.footerLabel;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [SJOPaperboyViewController hasBackgroundModeEnabled] ? 2 : 1;
        case 1:
            return 2;
        case 2:{
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSDictionary *savedLocations = [userDefaults objectForKey:kLocations];
            return savedLocations.count;
        }
            
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    // Configure the cell...
    switch (indexPath.section) {
        case 0:
        {
            UISwitch* toggleSwitch = [[UISwitch alloc] init];
            
            cell.accessoryView = toggleSwitch;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.imageView.image = nil;
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            cell.textLabel.textColor = [UIColor blackColor];
            
            
            switch (indexPath.row) {
                case 0:
                    if ([SJOPaperboyViewController hasBackgroundModeEnabled]) {
                        toggleSwitch.on = [SJOPaperboyViewController isBackgroundUpdatingEnabled];
                        cell.textLabel.text = NSLocalizedStringFromTable(@"background_updates", @"Paperboy", nil);
                        [toggleSwitch addTarget:self action:@selector(toggleBackgroundUpdates:) forControlEvents:UIControlEventValueChanged];
                        break;
                    }
                default:
                    cell.userInteractionEnabled = [CLLocationManager regionMonitoringAvailable];
                    toggleSwitch.userInteractionEnabled = [CLLocationManager regionMonitoringAvailable];
                    toggleSwitch.on = [SJOPaperboyViewController isLocationUpdatingEnabled];
                    cell.textLabel.text = NSLocalizedStringFromTable(@"location_updates", @"Paperboy", nil);
                    [toggleSwitch addTarget:self action:@selector(toggleLocationUpdates:) forControlEvents:UIControlEventValueChanged];
            }
            break;
        }
        case 1:
        {
            
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            switch (indexPath.row) {
                case 0:
                    if (self.isLocating) {
                        cell.textLabel.text = NSLocalizedStringFromTable(@"getting_location", @"Paperboy", nil);
                        UIActivityIndicatorView* loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                        [loadingIndicator startAnimating];
                        cell.accessoryView = loadingIndicator;
                    } else {
                        cell.textLabel.text = NSLocalizedStringFromTable(@"add_location", @"Paperboy", nil);
                        cell.accessoryView = nil;
                    }
                    break;
                case 1:
                    cell.textLabel.text = NSLocalizedStringFromTable(@"clear_locations", @"Paperboy", nil);
                    cell.accessoryView = nil;
                    break;
            }
            
            cell.userInteractionEnabled = [SJOPaperboyViewController isLocationUpdatingEnabled];
            cell.textLabel.textColor = [UIColor colorWithRed:0.19 green:0.30 blue:0.51 alpha:1.0];
            cell.imageView.image = nil;
            
            break;
        }
        case 2: {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSDictionary *savedLocations = [userDefaults objectForKey:kLocations];
            NSString* location = [[savedLocations allKeys] objectAtIndex:indexPath.row];
            cell.textLabel.text = location.description;
            cell.accessoryView = nil;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            cell.textLabel.textColor = [UIColor blackColor];
            //A navigation icon looks good here. Removed because I shouldn't redistibute Glyphish icons.
            //cell.imageView.image = [UIImage imageNamed:@"22-location-arrow"];
            break;
        }
            
    }
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return indexPath.section == 2;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2 && editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary *savedLocations = [[userDefaults objectForKey:kLocations] mutableCopy];
        NSString* location = [[savedLocations allKeys] objectAtIndex:indexPath.row];
        [savedLocations removeObjectForKey:location];
        
        [userDefaults setObject:[NSDictionary dictionaryWithDictionary:savedLocations] forKey:kLocations];
        [userDefaults synchronize];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self updateGeofencedLocations];
    }
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            break;
        }
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                    self.isLocating = YES;
                    [self.locationManager startUpdatingLocation];
                    [self.tableView reloadData];
                    break;
                case 1: {
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:[NSDictionary dictionary] forKey:kLocations];
                    [userDefaults synchronize];
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [self updateGeofencedLocations];
                    break;
                }
            }
            break;
        }
        case 2:
            break;
            
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark CLLocationManager delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    CLLocation* currentLocation = [locations lastObject];
    self.isLocating = NO;
    [self.locationManager stopUpdatingLocation];
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            
            NSMutableDictionary* savedLocations = [[userDefaults objectForKey:kLocations] mutableCopy];
            
            if (!savedLocations) {
                savedLocations = [NSMutableDictionary dictionary];
            }
            
            NSString* addressString = [ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO) stringByReplacingOccurrencesOfString:@"\n" withString:@" / "];
            
            [savedLocations setObject:[NSKeyedArchiver archivedDataWithRootObject:currentLocation] forKey:addressString];
            
            [userDefaults setObject:[NSDictionary dictionaryWithDictionary:savedLocations] forKey:kLocations];
            [userDefaults synchronize];
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView reloadData];
            
            [self updateGeofencedLocations];
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [self locationManager:manager didUpdateLocations:@[newLocation]];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //TODO: Show alert view
}



#pragma mark Private methods

-(void) updateGeofencedLocations
{
    // Cancel previous update locations before setting new ones
    NSArray *regionArray = [[[SJOPaperboyLocationManager sharedLocationManager] monitoredRegions] allObjects];
    for (int i = 0; i < [regionArray count]; i++) {
        [[SJOPaperboyLocationManager sharedLocationManager] stopMonitoringForRegion:[regionArray objectAtIndex:i]];
    }
    
    if ([SJOPaperboyViewController isLocationUpdatingEnabled]) {
        
        NSMutableArray *geofences = [NSMutableArray array];
        NSArray* locations = [SJOPaperboyViewController locationsForUpdate];
        
        for(CLLocation *location in locations) {
            NSString* identifier = [NSString stringWithFormat:@"%f%f", location.coordinate.latitude, location.coordinate.longitude];
            
            CLRegion* geofence = [[CLRegion alloc] initCircularRegionWithCenter:location.coordinate
                                                                         radius:100
                                                                     identifier:identifier];
            [geofences addObject:geofence];
        }
        
        if (geofences.count > 0) {
            for(CLRegion *geofence in geofences) {
                [[SJOPaperboyLocationManager sharedLocationManager] startMonitoringForRegion:geofence];
            }
        }
        
    }
}

-(IPInsetLabel*) styledLabelWithText:(NSString*)text
{
    IPInsetLabel* label = [[IPInsetLabel alloc] init];
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor clearColor];
    label.font = self.labelFont;
    label.textColor = [UIColor colorWithRed:0.32 green:0.35 blue:0.44 alpha:1.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.shadowColor = [UIColor whiteColor];
    label.shadowOffset = CGSizeMake(0, 1);
    label.insets = UIEdgeInsetsMake(18,6,18,6);
    label.text = text;
    label.clipsToBounds = YES;
    return label;
}


-(void) toggleBackgroundUpdates:(id)sender
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL backgroundUpdatesEnabled = ![userDefaults boolForKey:kBackgroundUpdates];
    [userDefaults setBool:backgroundUpdatesEnabled forKey:kBackgroundUpdates];
    [userDefaults synchronize];
}

-(void) toggleLocationUpdates:(id)sender
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL backgroundUpdatesEnabled = ![userDefaults boolForKey:kLocationUpdates];
    [userDefaults setBool:backgroundUpdatesEnabled forKey:kLocationUpdates];
    [userDefaults synchronize];

    NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 2)];
    if (backgroundUpdatesEnabled) {
        self.numberOfSections = 3;
        [self.tableView insertSections:indexes withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        self.numberOfSections = 1;
        [self.tableView deleteSections:indexes withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    [self updateGeofencedLocations];
}

#pragma mark Static helpers

+ (BOOL) isBackgroundUpdatingEnabled
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:kBackgroundUpdates] && [SJOPaperboyViewController hasBackgroundModeEnabled];
}

+ (BOOL) isLocationUpdatingEnabled
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:kLocationUpdates];
}


+ (void) setDefaultBackgroundValue:(BOOL) isBackgroundingEnabled
{
    [SJOPaperboyViewController setDefaultDefaultsValue:isBackgroundingEnabled forKey:kBackgroundUpdates];
}

+ (void) setDefaultLocationUpdateValue:(BOOL) areLocationUpdatesEnabled
{
    [SJOPaperboyViewController setDefaultDefaultsValue:areLocationUpdatesEnabled forKey:kLocationUpdates];
}

+ (void) setDefaultDefaultsValue:(BOOL) value forKey:(NSString*) key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults synchronize];
    
    // check if value readable in userDefaults
    id currentObject = [userDefaults objectForKey:key];
    if (currentObject == nil)
    {
        // not readable: set value
        [userDefaults setBool:value forKey:key];
        [userDefaults synchronize];
    }
}

+ (NSArray*) locationsForUpdate
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *savedLocations = [userDefaults objectForKey:kLocations];
    
    NSMutableArray* locations = [NSMutableArray array];
    for (NSData* data in [savedLocations allValues]) {
        CLLocation* location = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [locations addObject:location];
    }
    return [NSArray arrayWithArray:locations];
}

#pragma mark - New backgrounding detection

+ (BOOL) hasBackgroundModeEnabled
{
    static BOOL sharedInstance = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        BOOL hasFetchCapability = [[UIApplication sharedApplication] respondsToSelector:@selector(setMinimumBackgroundFetchInterval:)];
        if (!hasFetchCapability) {
            sharedInstance = NO;
            return;
        }
        
        NSArray* backgroundModes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UIBackgroundModes"];
        if (!backgroundModes) {
            sharedInstance = NO;
            return;
        }
        
        NSSet* backgroundModesSet = [NSSet setWithArray:backgroundModes];
        sharedInstance = [backgroundModesSet containsObject:@"fetch"];
    });
    return sharedInstance;
}



@end
