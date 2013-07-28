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
    
    
    [SJOPaperboyViewController setDefaultBackgroundValue:YES];
    [SJOPaperboyViewController setDefaultLocationUpdateValue:YES];
    SJOPaperboyViewController* paperboyViewController = [[SJOPaperboyViewController alloc] init];
    
    UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:paperboyViewController];
    
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(setMinimumBackgroundFetchInterval:)]) {
        NSInvocation* invoc = [NSInvocation invocationWithMethodSignature:
                               [[UIApplication sharedApplication] methodSignatureForSelector:
                                @selector(setMinimumBackgroundFetchInterval:)]];
        [invoc setTarget:[UIApplication sharedApplication]];
        [invoc setSelector:@selector(setMinimumBackgroundFetchInterval:)];
        NSTimeInterval arg2 = 1800;
        [invoc setArgument:&arg2 atIndex:2];
        [invoc invoke];
    }
    
    self.paperboyLocationManager = [SJOPaperboyLocationManager sharedLocationManager];
    [[SJOPaperboyLocationManager sharedInstance] setLocationChangedBlock:^{
        //Perform your background updates here.
        NSLog(@"Location changed block called.");
    }];
    
    
    return YES;
}


#ifdef __IPHONE_7_0
-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    
}
#endif

@end
