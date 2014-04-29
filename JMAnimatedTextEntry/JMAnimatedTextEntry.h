//
//  JMAnimatedTextEntry.h
//  JMAnimatedTextEntry
//
//  Created by Joey Meyer on 4/27/14.
//  Copyright (c) 2014 Joey Meyer. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^JMCompletionBlock)(BOOL finished);

@protocol JMAnimatingTextEntry <NSObject>

@optional
- (void)jm_setText:(NSString *)text animatedWithDuration:(NSTimeInterval)duration completion:(JMCompletionBlock)completion;
- (void)jm_stopTextAnimation;

@end
