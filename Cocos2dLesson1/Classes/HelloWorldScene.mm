//
//  HelloWorldLayer.m
//  Cocos2dLesson1
//
//  Created by Max Wittek on 3/4/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

// Import the interfaces
#import <MediaPlayer/MediaPlayer.h> 
#import "CCTouchDispatcher.h"
#import "HelloWorldScene.h"
#import "Circle.h"
#import "Timer.h"
#import "osu-import.h.mm"
#include <list>
#include <iostream>
using std::cout;
using std::endl;
using std::vector;

CCSprite * seeker1;
CCSprite *cocosGuy;

Circle * circ;

Timer * timer;
Beatmap * beatmap;

std::list<Circle*> circles;
std::list<HitObject> hitObjects;

// HelloWorld implementation
@implementation Layer1
+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Layer2 *layer = [Layer1 node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	if( (self=[super init])) {

	[CCMenuItemFont setFontSize:30];
	[CCMenuItemFont setFontName: @"Courier New"];
	
	CCMenuItem *item1 = [CCMenuItemFont itemFromString: @"Press me to start!!" target: self selector:@selector(menuCallbackStart:)];
	CCMenu *menu = [CCMenu menuWithItems:
					item1, nil];
	[self addChild: menu];
		
	}
	return self;
}
-(void) menuCallbackStart: (id) sender
{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[Layer2 scene]]];
	//[(CCMultiplexLayer*)parent_ switchTo:2];
}

@end

@implementation Layer2

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Layer2 *layer = [Layer2 node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		/*
		// create and initialize a Label
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:64];

		// ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
	
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height/2 );
		
		// add the label as a child to this Layer
		[self addChild: label];
		 */
		
		// Initialize Timer
		timer = [[Timer alloc] init];
		
		// Initialize Beatmap (C++)
		beatmap = new Beatmap("mflo.osu");
		
		//circ = [[Circle alloc] init];
		circ = [[Circle alloc] initWithColor:40 green:40 blue:0];
		circ.position = ccp(480/2,320/2);
		[self addChild: circ];
		
		seeker1 = [CCSprite spriteWithFile: @"seeker.png"];
		seeker1.position = ccp(50, 100);
		[self addChild:seeker1];
		
		cocosGuy = [CCSprite spriteWithFile:@"Icon.png"];
		cocosGuy.position = ccp(200, 300);
		[self addChild:cocosGuy];
		
		seeker1.position = ccp(-400, -400);
		cocosGuy.position = ccp(-400, -400);
		
		[self schedule:@selector(nextFrame:)];
		
		self.isTouchEnabled = YES;
		
		[timer startTimer];
		
		
		@try {
		/* Music stuff */
		MPMusicPlayerController * musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
		MPMediaItem * currentItem = musicPlayer.nowPlayingItem;
		MPMediaItemArtwork *artwork = [currentItem valueForProperty:MPMediaItemPropertyArtwork];
		UIImage * artworkImage = [artwork imageWithSize:CGSizeMake(320, 320)];
		
		CCSprite * albumArt = [CCSprite spriteWithCGImage:[artworkImage CGImage]];
		albumArt.position = ccp(480/2, 320/2);
		[self addChild:albumArt];
		} @catch(NSException *e) {
			cout << "well hey you did some crazy shit there" << endl;
		}
		/* cgpoints go from bottom left to top right like a graph */
	}
	return self;
}

BOOL otherDirection = NO;

- (void) nextFrame:(ccTime)dt {
	
	/*
	if(otherDirection)
		seeker1.position = ccp( seeker1.position.x - 200*dt, seeker1.position.y );
	else
		seeker1.position = ccp( seeker1.position.x + 200*dt, seeker1.position.y );

	
    if (seeker1.position.x > 480+32)
		otherDirection = true;
    
	else if (seeker1.position.x < 0)
        otherDirection = false;
	 */
	
	/***** Music Game Stuff ****/
	
	double milliseconds = [timer timeFromStart] * 1000.0f;
	
	double duration = 1.0;
	// Make stuff start to appear
	while(!beatmap->hitObjects.empty()) {
		HitObject o = beatmap->hitObjects.front(); 
		
		cout << o.startTimeMs << " " << milliseconds << endl;
		if(o.startTimeMs < milliseconds) {
			CGPoint location = CGPointMake(o.x, o.y);
			location = [[CCDirector sharedDirector] convertToGL: location];
			
			Circle * c = [[Circle alloc] init];
			c.position = location;
			[self addChild:c];
			circles.push_back(c);
			hitObjects.push_back(o);
			[c appearWithDuration: duration];
			
			beatmap->hitObjects.pop_front();
		}
		else
			break;
	}

	while(!hitObjects.empty()) {
		if(hitObjects.front().startTimeMs + 1500 < milliseconds) {
			cout << "asdf so yeah im getting rid of shit" << endl;
			hitObjects.pop_front();
			Circle * c = circles.front();
			circles.pop_front();
			[self removeChild:c cleanup:true];
		}
		else
			break;
	}

	
}

-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint location = [self convertTouchToNodeSpace: touch];
	
	//[self runAction: [CCRipple3D actionWithPosition: location radius: 48 waves: 1 amplitude: 90 grid: ccg(4,4) duration: 0.75]];
	
	/*
	[cocosGuy stopAllActions];
	[cocosGuy runAction: [CCMoveTo actionWithDuration:1 position:location]];  
	 */
	
	Circle * circ = [[Circle alloc] initWithColor: 120 green: 0 blue: 0];
	circ.position = location;
	[self addChild:circ];
	
	[circ appearWithDuration:1.0];
	
}



// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
