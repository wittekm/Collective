//
//  HODSlider.m
//  Cocos2dLesson1
//
//  Created by Max Wittek on 3/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HODSlider.h"
#import "osu-import.h.mm"
#import "Circle.h"

@implementation HODSlider

- (id) initWithHitObject:(HitObject)hitObject_ red:(int)r green:(int)g blue:(int)b {
	
	if( (self = [super initWithHitObject:hitObject_ red:r green:g blue:b]) ) {
		//c = [[Circle alloc] initWithHitObject:hitObject_ red:r green:g blue:b];
		//[self addChild:c];
	}
	return self;
}




@end
