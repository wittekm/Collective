//
//  CCHitObject.h
//  Cocos2dLesson1
//
//  Created by Max Wittek on 3/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "osu-import.h.mm"

@interface HitObjectDisplay : CCLayer {
	HitObject * hitObject;
	int red;
	int green;
	int blue;
}

- (id) initWithHitObject: (HitObject*)hitObject_ red: (int)r green: (int)g blue: (int)b;
- (void) appearWithDuration: (double)duration;
- (void) setOpacity: (GLubyte) opacity;

@property HitObject* hitObject;

@end
