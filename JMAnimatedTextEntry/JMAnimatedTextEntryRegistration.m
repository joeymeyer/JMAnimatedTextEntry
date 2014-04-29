//
//  JMAnimatedTextEntryRegistration.m
//  JMAnimatedTextEntry
//
//  Created by Joey Meyer on 4/27/14.
//  Copyright (c) 2014 Joey Meyer. All rights reserved.
//

#import "JMAnimatedTextEntryRegistration.h"
#import "JMAnimatedTextEntry.h"
#import <objc/runtime.h>

SEL jm_updateAnimatingTextEntrySelector() {
  return NSSelectorFromString(@"jm_updateAnimatingTextEntry:");
}

const char * jm_start             = "jm_start";
const char * jm_text              = "jm_text";
const char * jm_lastUpdateText    = "jm_lastUpdatedText";
const char * jm_animationDuration = "jm_animationDuration";
const char * jm_displayLink       = "jm_displayLink";
const char * jm_completion        = "jm_completion";

void _jm_setTextAnimatedWithDuration(id self, SEL _cmd, NSString *text, CFTimeInterval duration, JMCompletionBlock completion) {
  [self jm_stopTextAnimation];
  
  CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self
                                                           selector:jm_updateAnimatingTextEntrySelector()];
  [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
  
  CFTimeInterval start = CACurrentMediaTime();
  
  objc_setAssociatedObject(self, jm_start,             @(start),    OBJC_ASSOCIATION_COPY_NONATOMIC);
  objc_setAssociatedObject(self, jm_text,              text,        OBJC_ASSOCIATION_COPY_NONATOMIC);
  objc_setAssociatedObject(self, jm_animationDuration, @(duration), OBJC_ASSOCIATION_COPY_NONATOMIC);
  objc_setAssociatedObject(self, jm_displayLink,       displayLink, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  objc_setAssociatedObject(self, jm_completion,        completion,  OBJC_ASSOCIATION_COPY_NONATOMIC);
}

void _jm_updateAnimatingTextEntry(id self, SEL _cmd, CADisplayLink *displayLink) {
  NSString *lastUpdatedText = objc_getAssociatedObject(self, jm_lastUpdateText);
  NSString *currentText = [self performSelector:@selector(text)];
  
  if (lastUpdatedText != nil && ![lastUpdatedText isEqualToString:currentText]) {
    [self jm_stopTextAnimation];
    return;
  }
  
  CFTimeInterval now = CACurrentMediaTime();
  CFTimeInterval start = (CFTimeInterval)[objc_getAssociatedObject(self, jm_start) doubleValue];
  CFTimeInterval animationDuration = (CFTimeInterval)[objc_getAssociatedObject(self, jm_animationDuration) doubleValue];
  NSString *text = objc_getAssociatedObject(self, jm_text);
  
  CFTimeInterval elapsedTime = now - start;
  
  NSUInteger location = MAX(MIN((NSUInteger)floor((elapsedTime / animationDuration) * (double)text.length), text.length), 0);
  
  NSString *updatedText = [text substringWithRange:NSMakeRange(0, location)];
  
  if (![currentText isEqualToString:updatedText]) {
    [self performSelector:@selector(setText:) withObject:updatedText];
    objc_setAssociatedObject(self, jm_lastUpdateText, updatedText, OBJC_ASSOCIATION_COPY_NONATOMIC);
  }
  
  if (elapsedTime > animationDuration) {
    [self jm_stopTextAnimation];
  }
}

void _jm_stopTextAnimation(id self, SEL _cmd) {
  JMCompletionBlock completion = objc_getAssociatedObject(self, jm_completion);
  
  if (completion) {
    NSString *text = objc_getAssociatedObject(self, jm_text);
    NSString *currentText = [self performSelector:@selector(text)];
    
    completion([text isEqualToString:currentText]);
  }
  
  CADisplayLink *displayLink = objc_getAssociatedObject(self, jm_displayLink);
  [displayLink invalidate];
  
  objc_setAssociatedObject(self, jm_text,              nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
  objc_setAssociatedObject(self, jm_lastUpdateText,    nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
  objc_setAssociatedObject(self, jm_animationDuration, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
  objc_setAssociatedObject(self, jm_start,             nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
  objc_setAssociatedObject(self, jm_displayLink,       nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  objc_setAssociatedObject(self, jm_completion,        nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@implementation JMAnimatedTextEntryRegistration

+ (void)registerAnimatedTextEntryClass:(Class)cls {
  if (![cls instancesRespondToSelector:@selector(text)] || ![cls instancesRespondToSelector:@selector(setText:)]) {
    [NSException raise:@"Invalid class for JMAnimatedTextEntry"
                format:@"%@ does not respond to `%@` and `%@`", NSStringFromClass(cls), NSStringFromSelector(@selector(text)), NSStringFromSelector(@selector(setText:))];
  }
  
  BOOL registrationSucceeded = ({
    class_addMethod(cls,
                    @selector(jm_setText:animatedWithDuration:completion:),
                    (IMP)_jm_setTextAnimatedWithDuration,
                    "v24@0:4@8d12@?20") &&
    class_addMethod(cls,
                    @selector(jm_stopTextAnimation),
                    (IMP)_jm_stopTextAnimation,
                    "v8@0:4") &&
    class_addMethod(cls,
                    jm_updateAnimatingTextEntrySelector(),
                    (IMP)_jm_updateAnimatingTextEntry,
                    "v12@0:4@8");
  });
  
  if (registrationSucceeded == NO) {
    [NSException raise:@"Invalid class for JMAnimatedTextEntry"
                format:@"%@ can't register for JMAnimatedTextEntry because one or more of the registered methods already exist on the class", NSStringFromClass(cls)];
  }
}

@end
