//
//  Timer.h
//  Cocos2DTest
//
//  Created by Max Wittek on 3/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface Timer : NSObject {
    NSDate *start;
    NSDate *end;
	NSDate *pauseTime;
}

- (void) startTimer;
- (void) stopTimer;
- (void) pauseTimer;
- (void) unpauseTimer;
- (double) timeElapsedInSeconds;
- (double) timeElapsedInMilliseconds;
- (double) timeElapsedInMinutes;

- (double) timeFromStart;

@end



/*
#import <Foundation/Foundation.h>

@interface Timer : NSObject {
    double start;
	double end;
	double pause;
}

- (void) startTimer;
- (void) stopTimer;
- (void) pauseTimer;
- (void) unpauseTimer;
- (double) timeElapsedInSeconds;
- (double) timeElapsedInMilliseconds;
- (double) timeElapsedInMinutes;

- (double) timeFromStart;

@end
*/