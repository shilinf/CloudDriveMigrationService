//
//  AppDelegate.m
//  CloudDriveMigrationServiceIOSClient
//
//  Created by Bochun Zhang on 7/27/15.
//  Copyright (c) 2015 Microsoft. All rights reserved.
//

#import "AppDelegate.h"
#import <DropboxSDK/DropboxSDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    DBSession *dbSession = [[DBSession alloc]
                            initWithAppKey:@"5a91csqjtsujuw7"
                            appSecret:@"x5wbkk2o273jqz7"
                            root:kDBRootDropbox]; // either kDBRootAppFolder or kDBRootDropbox
    [DBSession setSharedSession:dbSession];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url
  sourceApplication:(NSString *)source annotation:(id)annotation {
    if ([[DBSession sharedSession] handleOpenURL:url]) {
        if ([[DBSession sharedSession] isLinked]) {
            NSLog(@"App linked successfully!");
            // At this point you can start making API calls
            //[DBSession sharedSession]
            //[[NSUserDefaults standardUserDefaults]setObject: self.liveClient.session.accessToken forKey:@"onedriveToken"];
            NSLog([url query]);
            NSString* query = [url query];
            NSArray* queryArray = [query componentsSeparatedByString:@"&"];
            NSString* token;
            NSString* secret;
            for (id q in queryArray) {
                NSArray* qcomps = [q componentsSeparatedByString:@"="];
                if ([qcomps count] >= 2 && [@"oauth_token" isEqualToString:[qcomps objectAtIndex:0]]) {
                    token = [qcomps objectAtIndex:1];
                } else if ([qcomps count] >= 2 && [@"oauth_token_secret" isEqualToString:[qcomps objectAtIndex:0]]) {
                    secret = [qcomps objectAtIndex:1];
                }
            }
            NSString* combToken = [NSString stringWithFormat:@"%@,%@", token, secret];
            NSLog(combToken);
            [[NSUserDefaults standardUserDefaults]setObject: combToken forKey:@"dropboxToken"];
        }
        return YES;
    }
    // Add whatever other url handling code your app requires here
    return NO;
}

@end
