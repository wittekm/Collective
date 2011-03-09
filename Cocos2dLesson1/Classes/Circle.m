//
//  Circle.m
//  Cocos2dLesson1
//
//  Created by Max Wittek on 3/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Circle.h"

CCSprite * underlay;
CCSprite * button;
CCSprite * overlay;

CCSprite* ring;

@implementation Circle

// on "init" you need to initialize your instance

-(id) initWithColor:(int)red green:(int)green blue:(int)blue
{
	[self init];
	button.color = ccc3(red, green, blue);
	
	return self;
}

-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		
		
		
		underlay = [CCSprite spriteWithFile:@"button.underlay.png"];
		button = [CCSprite spriteWithFile:@"button.button.png"];
		overlay = [CCSprite spriteWithFile:@"button.overlay.png"];
		ring = [CCSprite spriteWithFile:@"button.ring.png"];
		
		underlay.position = ccp(0,0);
		button.position = ccp(0,0);
		overlay.position = ccp(0,0);
		ring.position = ccp(0,0);
		
		//[button runAction: [CCTintBy actionWithDuration:0 red:40 green:40 blue:0]];
		button.color = ccc3(40, 40, 0);
		
		[self addChild:underlay];
		[self addChild:button];
		[self addChild:overlay];
		[self addChild:ring];
		
		self.visible = false;
		
	}
	return self;
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
	id actionSetInvisible = [CCCallBlock actionWithBlock: Block_copy(^{
		[ring setVisible: false];
		[ring setScale: 1.0];
		NSLog(@"no longer isible ");
	})];
	
	[self runAction: actionFadeIn];
	
	
	[button runAction: [CCSequence actions:actionFadeIn, nil]];
	[underlay runAction: [CCSequence actions:actionFadeIn, nil]];
	[ring runAction: [CCSequence actions:actionFadeIn, nil]];
	
	
	[ring runAction: [CCSequence actions:actionScaleHalf, actionSetInvisible, nil]];
}


-(void) drawDerp
{
	CGSize s = [[CCDirector sharedDirector] winSize];
	
	/*
	// draw a simple line
	// The default state is:
	// Line Width: 1
	// color: 255,255,255,255 (white, non-transparent)
	// Anti-Aliased
	glEnable(GL_LINE_SMOOTH);
	ccDrawLine( ccp(0, 0), ccp(s.width, s.height) );
	
	// line: color, width, aliased
	// glLineWidth > 1 and GL_LINE_SMOOTH are not compatible
	// GL_SMOOTH_LINE_WIDTH_RANGE = (1,1) on iPhone
	glDisable(GL_LINE_SMOOTH);
	glLineWidth( 5.0f );
	glColor4ub(255,0,0,255);
	ccDrawLine( ccp(0, s.height), ccp(s.width, 0) );
	
	// TIP:
	// If you are going to use always the same color or width, you don't
	// need to call it before every draw
	//
	// Remember: OpenGL is a state-machine.
	
	// draw big point in the center
	glPointSize(64);
	glColor4ub(0,0,255,128);
	ccDrawPoint( ccp(s.width / 2, s.height / 2) );
	
	// draw 4 small points
	CGPoint points[] = { ccp(60,60), ccp(70,70), ccp(60,70), ccp(70,60) };
	glPointSize(4);
	glColor4ub(0,255,255,255);
	ccDrawPoints( points, 4);
	 
	 
	
	// draw a green circle with 10 segments
	glLineWidth(16);
	glColor4ub(0, 255, 0, 255);
	ccDrawCircle( ccp(s.width/2,  s.height/2), 100, 0, 10, NO);
	 
	 */
	
	// draw a green circle with 50 segments with line to center
	glLineWidth(2);
	glColor4ub(0, 255, 255, 255);
	ccDrawCircle( ccp(s.width/2, s.height/2), 50, CC_DEGREES_TO_RADIANS(90), 50, YES);	
	
	/*
	
	// open yellow poly
	glColor4ub(255, 255, 0, 255);
	glLineWidth(10);
	CGPoint vertices[] = { ccp(0,0), ccp(50,50), ccp(100,50), ccp(100,100), ccp(50,100) };
	ccDrawPoly( vertices, 5, NO);
	
	// closed purble poly
	glColor4ub(255, 0, 255, 255);
	glLineWidth(2);
	CGPoint vertices2[] = { ccp(30,130), ccp(30,230), ccp(50,200) };
	ccDrawPoly( vertices2, 3, YES);
	
	// draw quad bezier path
	ccDrawQuadBezier(ccp(0,s.height), ccp(s.width/2,s.height/2), ccp(s.width,s.height), 50);
	
	// draw cubic bezier path
	ccDrawCubicBezier(ccp(s.width/2, s.height/2), ccp(s.width/2+30,s.height/2+50), ccp(s.width/2+60,s.height/2-50),ccp(s.width, s.height/2),100);
	
	 */
	
	// restore original values
	glLineWidth(1);
	glColor4ub(255,255,255,255);
	glPointSize(1);
}





@end
