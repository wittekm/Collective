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
#import <vector>

@implementation HODSlider


- (void) addPoints {
	HitSlider * hs = (HitSlider*)hitObject;
	typedef std::vector<std::pair<int, int> > pointsList;
	pointsList points = hs->sliderPoints;
	if(points.size() > 50) return;
	for(uint i = 0; i < points.size(); i++) {
		std::pair<int, int> pointPair = points.at(i);
		CGPoint point = CGPointMake(pointPair.first * 1.0, pointPair.second * 1.0);
		[curve setPoint:point atIndex: i];
	}
	[curve invalidate];
}

- (id) initWithHitObject:(HitObject*)hitObject_ red:(int)r green:(int)g blue:(int)b {
	
	if( (self = [super initWithHitObject:hitObject_ red:r green:g blue:b]) ) {
		curve = [FRCurve curveFromType:kFRCurveLagrange order:kFRCurveCubic segments:64]; // MAY NEED RETAIN
		[curve setWidth: 64.0f];
		[curve setShowControlPoints:true];
		
		ccColor3B curveColor = { r, g, b};
		[curve setColor:curveColor];
		[self addPoints];
		[self addChild:curve];
		
	}
	return self;
}

- (void) dealloc {
	[super dealloc];
	[curve dealloc];
}


@end
