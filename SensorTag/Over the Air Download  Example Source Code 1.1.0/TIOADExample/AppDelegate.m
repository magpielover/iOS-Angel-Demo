/*
 AppDelegate.m
 TIOADExample
 Created by Ole Andreas Torvmark on 1/7/13.
 Copyright (c) 2013 Texas Instruments. All rights reserved.

 */

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.

    
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    UIViewController *vc = [sb instantiateInitialViewController];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    UINavigationController *nC = [[UINavigationController alloc]initWithRootViewController:vc];
    [nC setNavigationBarHidden:YES];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = nC;
    [self.window makeKeyAndVisible];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(BOOL) application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    NSLog(@"Opened by other application with URL : %@",url);
    
    NSData *FWFile = [NSData dataWithContentsOfURL:url];
    
    NSString *root = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [root stringByAppendingPathComponent:[url lastPathComponent]];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Saving firmware file" message:[NSString stringWithFormat:@"Firmware file saved to shared files with filename : %@",[url lastPathComponent]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [FWFile writeToFile:filePath atomically:YES];
    NSLog(@"Wrote file : %@, %d OK !",filePath,FWFile.length);
    return YES;
}

@end
