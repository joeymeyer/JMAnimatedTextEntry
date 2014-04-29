//
//  UITextView+JMAnimatedTextEntry.m
//  JMAnimatedTextEntry
//
//  Created by Joey Meyer on 4/27/14.
//  Copyright (c) 2014 Joey Meyer. All rights reserved.
//

#import "UITextView+JMAnimatedTextEntry.h"
#import "JMAnimatedTextEntryRegistration.h"

__attribute__((constructor))
static void UITextViewAnimatedTextEntryRegistration() {
  [JMAnimatedTextEntryRegistration registerAnimatedTextEntryClass:[UITextView class]];
}
