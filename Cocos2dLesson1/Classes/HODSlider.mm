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






void drawQuadBezier(CGPoint origin, CGPoint control, CGPoint destination, int segments)
{
    CGPoint vertices[segments + 1];
	
    float t = 0.0;
    for(int i = 0; i < segments; i++)
    {
        float x = pow(1 - t, 2) * origin.x + 2.0 * (1 - t) * t * control.x + t * t * destination.x;
        float y = pow(1 - t, 2) * origin.y + 2.0 * (1 - t) * t * control.y + t * t * destination.y;
        vertices[i] = CGPointMake(x, y);
        t += 1.0 / segments;
    }
    vertices[segments] = destination;
	
    glVertexPointer(2, GL_FLOAT, 0, vertices);
    glEnableClientState(GL_VERTEX_ARRAY);
	
    glDrawArrays(GL_LINE_STRIP, 0, segments + 1);
	
    glDisableClientState(GL_VERTEX_ARRAY);
}

void drawCubicBezier(CGPoint origin, CGPoint control1, CGPoint control2, CGPoint destination, int segments)
{
    CGPoint vertices[segments + 1];
	
    float t = 0.0;
    for(int i = 0; i < segments; i++)
    {
        float x = pow(1 - t, 3) * origin.x + 3.0 * pow(1 - t, 2) * t * control1.x + 3.0 * (1 - t) * t * t * control2.x + t * t * t * destination.x;
        float y = pow(1 - t, 3) * origin.y + 3.0 * pow(1 - t, 2) * t * control1.y + 3.0 * (1 - t) * t * t * control2.y + t * t * t * destination.y;
        vertices[i] = CGPointMake(x, y);
        t += 1.0 / segments;
    }
    vertices[segments] = destination;
	
    glVertexPointer(2, GL_FLOAT, 0, vertices);
    glEnableClientState(GL_VERTEX_ARRAY);
	
    glDrawArrays(GL_LINE_STRIP, 0, segments + 1);
	
    glDisableClientState(GL_VERTEX_ARRAY);
}


- (id) initWithHitObject:(HitObject*)hitObject_ red:(int)r green:(int)g blue:(int)b {
	
	if( (self = [super initWithHitObject:hitObject_ red:r green:g blue:b]) ) {
		//c = [[Circle alloc] initWithHitObject:hitObject_ red:r green:g blue:b];
		//[self addChild:c];
		
		curve = [[FRCurve curveFromType:kFRCurveLagrange order:kFRCurveCubic segments:64] retain];
		[curve setWidth: 64.0f];
		[curve setShowControlPoints:true];
		
		ccColor3B curveColor = { r, g, b};
		[curve setColor:curveColor];
		[self addChild:curve];
	}
	return self;
}

- (void) test {
	[self setVisible:true];
	[self setOpacity:150];
	
	CGPoint w = CGPointMake(3., 4.);
	CGPoint x = CGPointMake(50., 100.);
	CGPoint y = CGPointMake(60., 120.);
	CGPoint z = CGPointMake(100., 40.);
	 
	[curve setType:kFRCurveLagrange];
	[curve setOrder:kFRCurveCubic];
	[curve setPoint:w atIndex:0];
	[curve setPoint:x atIndex:1];
	[curve setPoint:y atIndex:2];
	[curve setPoint:z atIndex:3];
	[curve invalidate];
}


@end
