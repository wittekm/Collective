//
//  CCHitObject.m
//  Cocos2dLesson1
//
//  Created by Max Wittek on 3/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HitObjectDisplay.h.mm"


@implementation HitObjectDisplay

@synthesize hitObject;

- (id) initWithHitObject: (HitObject)hitObject_ red: (int)r green: (int)g blue: (int)b {
	if( (self=[super init]) ) {
		hitObject = hitObject_;
		red = r;
		green = g;
		blue = b;
		self.position = CGPointMake(hitObject.x, hitObject.y);
	}
	return self;
}


- (void) appearWithDuration: (double)duration {
	[self doesNotRecognizeSelector:_cmd];
}

- (void) setOpacity: (GLubyte) opacity {
	for( CCNode *node in [self children] )
	{
		if( [node conformsToProtocol:@protocol( CCRGBAProtocol)] )
		{
			[(id<CCRGBAProtocol>) node setOpacity: opacity];
		}
	}
}

@end
