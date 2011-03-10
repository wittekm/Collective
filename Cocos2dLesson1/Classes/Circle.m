//
//  Circle.m
//  Cocos2dLesson1
//
//  Created by Max Wittek on 3/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Circle.h"

CCSprite * button;
CCSprite * ring;

@implementation Circle

// on "init" you need to initialize your instance

-(id) initWithColor:(int)red green:(int)green blue:(int)blue
{
	if( (self=[super init] )) {
		
		self.visible = false;
		
		size = CGSizeMake(120, 120);
		
		CCRenderTexture * buttonTex = [self createCircleTexture:red :green :blue];
		
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

- (CCRenderTexture*) createCircleTexture: (int)red :(int)green :(int)blue
{
	/* NOTE: Should be Retina Display-ified */
	CCRenderTexture * target = 
	[[CCRenderTexture renderTextureWithWidth:size.width height:size.height] retain];
	target.position = ccp(0,0);
	
	CCSprite * underlay = [CCSprite spriteWithFile:@"button.underlay.png"];
	CCSprite * button = [CCSprite spriteWithFile:@"button.button.png"];
	CCSprite * overlay = [CCSprite spriteWithFile:@"button.overlay.png"];
	underlay.position = ccp(size.width/2,size.height/2);
	button.position = ccp(size.width/2,size.height/2);
	overlay.position = ccp(size.width/2,size.height/2);
	
	button.color = ccc3(red, green, blue);
	
	[target begin];
	[underlay visit];
	[button visit];
	[overlay visit];
	[target end];
	
	return target;
}

-(id) init
{
	return [self initWithColor: 200 green:0 blue:0];
}

-(void) setOpacity: (GLubyte) opacity
{
	for( CCNode *node in [self children] )
	{
		if( [node conformsToProtocol:@protocol( CCRGBAProtocol)] )
		{
			[(id<CCRGBAProtocol>) node setOpacity: opacity];
		}
	}
}

- (void) appearWithDuration: (double)duration
{
	self.visible = true;
	ring.visible = true;
	[ring setScale:1.0];
	
	id actionFadeIn = [CCFadeIn actionWithDuration:duration];
	id actionScaleHalf = [CCScaleBy actionWithDuration:duration scale:0.5];
	
	
	//[button runAction: [CCSequence actions:actionFadeIn, nil]];
	//[ring runAction: [CCSequence actions:actionFadeIn, nil]];
	
	[self runAction: [CCSequence actions:actionFadeIn, nil]];
	[ring runAction: [CCSequence actions:actionScaleHalf,  nil]];
}


-(void) drawDerp
{
	CGSize s = [[CCDirector sharedDirector] winSize];

	
	// draw a green circle with 50 segments with line to center
	glLineWidth(2);
	glColor4ub(0, 255, 255, 255);
	ccDrawCircle( ccp(s.width/2, s.height/2), 50, CC_DEGREES_TO_RADIANS(90), 50, YES);	
	
	// restore original values
	glLineWidth(1);
	glColor4ub(255,255,255,255);
	glPointSize(1);
}





@end
