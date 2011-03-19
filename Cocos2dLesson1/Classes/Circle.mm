//
//  Circle.m
//  Cocos2dLesson1
//
//  Created by Max Wittek on 3/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Circle.h"
#import "osu-import.h.mm"

CCSprite * button;
CCSprite * ring;

@implementation Circle

// on "init" you need to initialize your instance

- (id) initWithHitObject:(HitObject*)hitObject_ red:(int)r green:(int)g blue:(int)b
{
	if( (self = [super initWithHitObject:hitObject_ red:r green:g blue:b]) ) {
		self.visible = false;
		
		size = CGSizeMake(120, 120);
		
		CCRenderTexture * buttonTex = [self createCircleTexture:r :g :b];
		
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

// TODO: potential memory leak here
- (CCRenderTexture*) createCircleTexture: (int)red_ :(int)green_ :(int)blue_
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
	
	button.color = ccc3(red_, green_, blue_);
	
	[target begin];
	[underlay visit];
	[button visit];
	[overlay visit];
	[target end];
	
	return target;
}

/*
-(id) init
{
	return [self initWithColor: 200 green:0 blue:0];
}
*/

- (void) appearWithDuration: (double)duration
{
	//self.position = CGPointMake(hitObject.x, hitObject.y);
	
	self.visible = true;
	ring.visible = true;
	[ring setScale:1.0];
	
	id actionFadeIn = [CCFadeIn actionWithDuration:duration];
	id actionScaleHalf = [CCScaleBy actionWithDuration:duration scale:0.5];
	
	[self runAction: [CCSequence actions:actionFadeIn, nil]];
	[ring runAction: [CCSequence actions:actionScaleHalf,  nil]];
}

/*
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
 */

/*
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
 */


@end
