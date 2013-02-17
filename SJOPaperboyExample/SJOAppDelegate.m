//
//  SJOAppDelegate.m
//  SJOPaperboyExample
//
//  Created by Sam Oakley on 17/02/2013.
//  Copyright (c) 2013 Sam Oakley. All rights reserved.
//

#import "SJOAppDelegate.h"
#import "SJOPaperboyLocationManager.h"
#import "SJOPaperboyViewController.h"

@implementation SJOAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    SJOPaperboyViewController* paperboyViewController = [[SJOPaperboyViewController alloc] init];
    
    UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:paperboyViewController];
    
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    
    
    self.paperboyLocationManager = [SJOPaperboyLocationManager sharedLocationManager];
    [[SJOPaperboyLocationManager sharedInstance] setLocationChangedBlock:^{
        //Perform your bakground updates here.
        NSLog(@"Location changed block called.");
    }];
    
    
    return YES;
}


@end
