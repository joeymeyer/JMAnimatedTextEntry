//
//  JMAppDelegate.m
//  JMAnimatedTextEntry Example
//
//  Created by Joey Meyer on 4/27/14.
//  Copyright (c) 2014 Joey Meyer. All rights reserved.
//

#import "JMAppDelegate.h"
#import "JMExampleViewController.h"

@implementation JMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.rootViewController = [[JMExampleViewController alloc] init];
  self.window.backgroundColor = [UIColor whiteColor];
  [self.window makeKeyAndVisible];
  
  return YES;
}

@end
