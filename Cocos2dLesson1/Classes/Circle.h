//
//  Circle.h
//  Cocos2dLesson1
//
//  Created by Max Wittek on 3/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface Circle : CCLayer {
}

- (id) initWithColor: (int)red green: (int)green blue: (int)blue;
- (void) appearWithDuration: (double)duration;

@end
