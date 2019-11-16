//
//  AppDelegate.m
//  Launcher
//
//  Created by branson on 2019/11/15.
//  Copyright © 2019 branson. All rights reserved.
//

#import "AppDelegate.h"
#import "../N Clip Board/Constants.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    BOOL isMainBundleRunning = false;
    NSArray<NSRunningApplication *>* runningApps = [[NSWorkspace sharedWorkspace]runningApplications];
    for (NSRunningApplication* app in runningApps) {
        if ([app bundleIdentifier] == Constants.MainBundleName) {
            isMainBundleRunning = true;
            break;
        }
    }
    
    if (!isMainBundleRunning) {
        [[NSDistributedNotificationCenter defaultCenter]addObserver:NSApp selector:@selector(terminate) name:@"killLauncher" object:Constants.MainBundleName];
        
        NSString* path = [[NSBundle mainBundle]bundlePath];
        NSArray<NSString *>* components = [path pathComponents];
        components = [components subarrayWithRange: NSMakeRange(0, [components count] - 3)];
        components = [components arrayByAddingObjectsFromArray:@[@"MacOS", @"N Clip Board"]];
        
        NSString* locationOfMainBundle = [NSString pathWithComponents:components];
        [[NSWorkspace sharedWorkspace]launchApplication:locationOfMainBundle];
    } else {
        [NSApp terminate:self];
    }
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
