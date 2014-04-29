//
//  JMExampleViewController.m
//  JMAnimatedTextEntry Example
//
//  Created by Joey Meyer on 4/27/14.
//  Copyright (c) 2014 Joey Meyer. All rights reserved.
//

#import "JMExampleViewController.h"
#import "UIKit+JMAnimatedTextEntry.h"

#define A_BUNCH_OF_TEXT @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla rhoncus dignissim eros non consequat. Cras ut fermentum neque. Morbi vel libero dictum, lacinia est venenatis, ultricies mi. Suspendisse potenti. Vestibulum ac malesuada sapien, in luctus magna."

@implementation JMExampleViewController

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  [self.emailField jm_setText:@"your.email@example.com" animatedWithDuration:0.6 completion:^(BOOL finished) {
    if (finished) {
      [self.passwordField jm_setText:@"passw0rd" animatedWithDuration:0.4 completion:nil];
    }
  }];
  [self.textView jm_setText:A_BUNCH_OF_TEXT animatedWithDuration:20.0 completion:nil];
  [self.label jm_setText:@"Example Title" animatedWithDuration:4.0 completion:nil];
}


@end
