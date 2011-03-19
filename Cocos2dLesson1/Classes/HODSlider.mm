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
	
	CGPoint start = CGPointMake(hs->x * 1.0, hs->y * 1.0);
	[curve setPoint: start atIndex: 0];
	
	
	//I have a crazy belief that curves need at least 4 points.
	
	if(points.size() == 1) {
		CGPoint end = ccp(points.at(0).first, points.at(0).second);
		[curve setPoint: ccpLerp(start, end, 1/3.f) atIndex:1];
		[curve setPoint:ccpLerp(start, end, 2/3.f) atIndex:2];
		[curve setPoint: end atIndex: 3];
	}
	
	else if(points.size() == 2) {
		CGPoint mid = ccp(points.at(0).first, points.at(0).second);
		CGPoint end = ccp(points.at(1).first, points.at(1).second);
		[curve setPoint: ccpLerp(start, mid, 1/2.f) atIndex:1];
		[curve setPoint: mid atIndex: 2];
		[curve setPoint:ccpLerp(mid, end, 1/2.f) atIndex:3];
		[curve setPoint: end atIndex: 4];
	}
	else {
		
		for(uint i = 0; i < points.size(); i++) {
			std::pair<int, int> pointPair = points.at(i);
			NSLog(@"%d: %d %d ", i+1, pointPair.first, pointPair.second);
			CGPoint point = CGPointMake((pointPair.first - hs->x) * 1.0, (pointPair.second - hs->y) * 1.0);
			//point = [[CCDirector sharedDirector] convertToGL: point];
			[curve setPoint:point atIndex: i+1];
		}
	}
	
	[curve invalidate];
	[curve setPosition:ccp(-hitObject->x, -hitObject->y)];
	//self.position = CGPointMake(hitObject->x * 1.0, hitObject->y * 1.0);
}

- (CCRenderTexture*) createCircleTexture
{
	/* NOTE: Should be Retina Display-ified */
	CCRenderTexture * target = 
	[[CCRenderTexture renderTextureWithWidth:size.width height:size.height] retain];
	target.position = ccp(0,0);
	
	CCSprite * underlay = [CCSprite spriteWithFile:@"button.underlay.png"];
	CCSprite * overlay = [CCSprite spriteWithFile:@"button.overlay.png"];
	underlay.position = ccp(size.width/2,size.height/2);
	overlay.position = ccp(size.width/2,size.height/2);
	
	[target begin];
	[underlay visit];
	[overlay visit];
	[target end];
	
	return target;
}

- (id) initWithHitObject:(HitObject*)hitObject_ red:(int)r green:(int)g blue:(int)b {
	
	if( (self = [super initWithHitObject:hitObject_ red:r green:g blue:b]) ) {
		
		// Set up the curve
		curve = [FRCurve curveFromType:kFRCurveLagrange order:kFRCurveCubic segments:64]; // MAY NEED RETAIN
		[curve setWidth: 72.0f];
		[curve setShowControlPoints:true];
		ccColor3B curveColor = { r, g, b};
		[curve setColor:curveColor];
		[self addPoints];
		[self addChild:curve];
		
		CCSprite * button;
		
		// Stuff cribbed from Circle
		size = CGSizeMake(120, 120);
		CCRenderTexture * buttonTex = [self createCircleTexture];
		
		ring = [CCSprite spriteWithFile:@"button.ring.png"];		 
		ring.position = ccp(0,0);
		
		//[self addChild:button];
		button = [CCSprite spriteWithTexture: [[buttonTex sprite] texture]];
		[self addChild: button];
		[self addChild:ring];
		
		[self setOpacity:0];
	}
	return self;
}

- (void) appearWithDuration:(double)duration {
	self.visible = true;
	ring.visible = true;
	[ring setScale:1.0];
	
	id actionFadeIn = [CCFadeIn actionWithDuration:duration];
	id actionScaleHalf = [CCScaleBy actionWithDuration:duration scale:0.5];
	
	[self runAction: [CCSequence actions:actionFadeIn, nil]];
	[ring runAction: [CCSequence actions:actionScaleHalf,  nil]];
}

- (void) dealloc {
	[super dealloc];
	[curve dealloc];
}


@end
