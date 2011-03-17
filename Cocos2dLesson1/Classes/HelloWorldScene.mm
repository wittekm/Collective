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

CCLabelTTF * scoreLabel;
int score;

CCSprite * seeker1;
CCSprite *cocosGuy;

Circle * circ;

Timer * timer;
Beatmap * beatmap;

MPMusicPlayerController * musicPlayer;

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
		//beatmap = new Beatmap("mflo.osu");
		beatmap = new Beatmap("gee_norm.osu");
		
		/*
		seeker1 = [CCSprite spriteWithFile: @"seeker.png"];
		seeker1.position = ccp(50, 100);
		[self addChild:seeker1];
		
		cocosGuy = [CCSprite spriteWithFile:@"Icon.png"];
		cocosGuy.position = ccp(200, 300);
		[self addChild:cocosGuy];
		
		seeker1.position = ccp(-400, -400);
		cocosGuy.position = ccp(-400, -400);
		*/
		 
		[self schedule:@selector(nextFrame:)];
		
		self.isTouchEnabled = YES;
		
// this shit don't work in the simulator
#if TARGET_OS_IPHONE
		@try {
			/* Music stuff */
			musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
			
			MPMediaQuery * mfloQuery = [[MPMediaQuery alloc] init];
			[mfloQuery addFilterPredicate: [MPMediaPropertyPredicate
										predicateWithValue: @"Gee"
										forProperty: MPMediaItemPropertyTitle]];
			
			[musicPlayer setQueueWithQuery:mfloQuery];
			[musicPlayer play];
			[timer startTimer];
			
			
			// Artwork
			MPMediaItem * currentItem = musicPlayer.nowPlayingItem;
			MPMediaItemArtwork *artwork = [currentItem valueForProperty:MPMediaItemPropertyArtwork];
			UIImage * artworkImage = [artwork imageWithSize:CGSizeMake(320, 320)];
			
			CCSprite * albumArt = [CCSprite spriteWithCGImage:[artworkImage CGImage]];
			albumArt.position = ccp(480/2, 320/2);
			[self addChild:albumArt];
		} @catch(NSException *e) {
			cout << "no music playing dawg" << endl;
		}
#endif
		/* cgpoints go from bottom left to top right like a graph */
		
		
		score = 0;
		scoreLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Helvetica" fontSize:24.0];
		//scoreLabel.anchorPoint = ccp([scoreLabel contentSize].width,[scoreLabel contentSize].height);
		scoreLabel.position = ccp(430,200);
		[self addChild: scoreLabel];
	}
	return self;
}

BOOL otherDirection = NO;

- (void) nextFrame:(ccTime)dt {
	
	/***** Music Game Stuff ****/
	
	double milliseconds = [musicPlayer currentPlaybackTime] * 1000.0f;
	milliseconds += 1000; // offset for gee norm
	//double milliseconds = [timer timeFromStart] * 1000.0f;
	//milliseconds += 1000; // offset for m-flo
	
	
	double durationS = 0.8; // seconds
	double timeAllowanceMs = 150;
	// Make stuff start to appear
	while(!beatmap->hitObjects.empty()) {
		HitObject o = beatmap->hitObjects.front(); 
		
		// TODO:
		// convert it into iphone space
		o.x *= (480.-64.)/480.;
		o.y *= (320.-64.)/320.;
		
		
		if(milliseconds > o.startTimeMs) {
			cout << "making a circle" << endl;
			HitObjectDisplay * c = [[Circle alloc] initWithHitObject:o red:0 green:180 blue:0];
			[self addChild:c];
			[c appearWithDuration: durationS];
			circles.push_back(c);
			beatmap->hitObjects.pop_front();
		}
		else
			break;
	}
	
	while(!circles.empty()) {
		HitObject o = circles.front().hitObject;
		if(milliseconds > o.startTimeMs + timeAllowanceMs + (1000.0 * durationS)) {
			cout << "asdf so yeah im getting rid of shit" << endl;
			HitObjectDisplay * c = circles.front();
			circles.pop_front();
			[self removeChild:c cleanup:true];
		}
		else
			break;
	}
	/*
	while(!hitObjects.empty()) {
		HitObject o = hitObjects.front();
		if(milliseconds > o.startTimeMs + timeAllowanceMs + (1000.0 * durationS)) {
			cout << "asdf so yeah im getting rid of shit" << endl;
			hitObjects.pop_front();
			Circle * c = circles.front();
			circles.pop_front();
			[self removeChild:c cleanup:true];
		}
		else
			break;
	}
	 */

	
}

-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}


/*
-(BOOL)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
}
 */

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint location = [self convertTouchToNodeSpace: touch];
	
	NSLog(@"%f %f", location.x, location.y);
	
	if(!hitObjects.empty()) {
		HitObject o = hitObjects.front();
		double dist = sqrt( pow(o.x - location.x, 2) + pow(o.y - location.y, 2));
		int distInt = dist;
		
		/*
		hitObjects.pop_front();
		Circle * c = circles.front();
		circles.pop_front();
		[self removeChild:c cleanup:true];
		 */
		
		
	
		score += 1;
		[scoreLabel setString:[NSString stringWithFormat:@"%d %d", score, distInt]];
		NSLog(@"%d %d %f", o.x, o.y, location.x, location.y, dist);
		//[scoreLabel setString:[NSString stringWithFormat:@"%d %d %d %d", o.x, location.x, o.y, location.y]];
	}
	else
		[scoreLabel setString:[NSString stringWithFormat:@"%d X", score]];

    return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint location = [self convertTouchToNodeSpace: touch];
	
	//[self runAction: [CCRipple3D actionWithPosition: location radius: 48 waves: 1 amplitude: 90 grid: ccg(4,4) duration: 0.75]];
	
	
	/*
	Circle * circ = [[Circle alloc] initWithColor: 120 green: 0 blue: 0];
	circ.position = location;
	[self addChild:circ];
	
	[circ appearWithDuration:2.0];
	*/
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
