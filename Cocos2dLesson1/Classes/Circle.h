//
//  Circle.h
//  Cocos2dLesson1
//
//  Created by Max Wittek on 3/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "HitObjectDisplay.h.mm"

@interface Circle : HitObjectDisplay {
	CGSize size;
}

- (CCRenderTexture*) createCircleTexture: (int)red :(int)green :(int)blue;


@end
