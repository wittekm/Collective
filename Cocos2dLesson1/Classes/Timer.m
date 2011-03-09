#import "Timer.h"

@implementation Timer

- (id) init {
    self = [super init];
    if (self != nil) {
        start = nil;
        end = nil;
		pauseTime = nil;
    }
    return self;
}

- (void) startTimer {
    start = [[NSDate date] retain];
}

- (void) stopTimer {
    end = [[NSDate date] retain];
}

- (void) pauseTimer {
	pauseTime = [[NSDate date] retain];
}

- (void) unpauseTimer {
	start = [[[NSDate date] dateByAddingTimeInterval: (-1) * [pauseTime timeIntervalSinceDate:start] ] retain];
}

- (double) timeElapsedInSeconds {
    //return 0.0;
	return [end timeIntervalSinceDate:start];
}

- (double) timeElapsedInMilliseconds {
    return [self timeElapsedInSeconds] * 1000.0f;
}

- (double) timeElapsedInMinutes {
    return [self timeElapsedInSeconds] / 60.0f;
}

- (double) timeFromStart {
    return [[NSDate date] timeIntervalSinceDate:start];
}

@end
