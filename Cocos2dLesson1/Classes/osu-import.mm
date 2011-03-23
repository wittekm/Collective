/*
 *  osu-import.cpp
 *  Collective
 *
 *  Created by Max Wittek on 2/15/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *

Creates a Beatmap from a .osu file, used in the "osu!" game; unzip the .osz
file to get at the .osu beatmap.
 */

#define OSU_STRING_LENGTH 80;

#include "osu-import.h.mm"
#include <fstream>
#include <string>
#include <iostream>
#include <sstream>
#include <cassert>
#include <tr1/functional>

// should just use normal old using statements...
using namespace std;
using namespace std::tr1;
using namespace std::tr1::placeholders;

enum HitObjectType {
	Normal = 1, Slider = 2, NewCombo = 4, NormalNewCombo = 5, SliderNewCombo = 6, Spinner = 8
};

int numberCounter = 1; // ughhhh globals suckkkk

HitObject::HitObject(int x_, int y_, int startTimeMs_, int objectType_, int soundType_) 
: x(x_), y(y_), startTimeMs(startTimeMs_), objectType(objectType_), soundType(soundType_) {
	if(objectType & 4) // new combo
		numberCounter = 1;
	
	number = numberCounter++;
}

HitSlider::HitSlider(int x_, int y_, int startTimeMs_, int objectType_, int soundType_, stringstream& ss) 
: HitObject(x_, y_, startTimeMs_, objectType_, soundType_) {
	string word;
	
	// get curve type
	getline(ss, word, '|');
	stringstream(word) >> curveType;
	
	// get all the segments
	getline(ss, word, ',');
	stringstream segmentsStream(word);
	
	// get repeatCount and sliderLengthPixels
	getline(ss, word, ',');
	stringstream(word) >> repeatCount;
	getline(ss, word, ',');
	stringstream(word) >> sliderLengthPixels;
	
	// process all the segments
	while(getline(segmentsStream, word, '|')) {
		stringstream segmentStream(word);
		string num1, num2;
		getline(segmentStream, num1, ':');
		getline(segmentStream, num2, ':');
		int num1int, num2int;
		stringstream(num1) >> num1int;
		stringstream(num2) >> num2int;
		
		// Put them into iphone space
		num1int *= (480.-64.)/480.;
		num2int *= (320.-64.)/320.;
		
		sliderPoints.push_back(make_pair(num1int, num2int));
	}
}

HitSpinner::HitSpinner(int x_, int y_, int startTimeMs_, int objectType_, int soundType_, stringstream& ss) 
: HitObject(x_, y_, startTimeMs_, objectType_, soundType_) {
	string word;
	getline(ss, word, ',');
	stringstream(word) >> endTimeMs;
}

HitObject * readHitObject(string line) {
	int hoVals[5]; // hit object vals
	stringstream lineStream(line);
	string word;
	for(int wordState = 0; wordState < 5 && getline(lineStream, word, ','); ++wordState) {
		stringstream(word) >> hoVals[wordState];
	}
	
	//cout << hoVals[0] << " " << hoVals[1] << endl;
	
	// Put them into iphone space
	hoVals[0] *= (480.-64.)/480.;
	hoVals[1] *= (320.-64.)/320.;
	
	// normal or normalnewcombo
	if((hoVals[3] & 1)) 
	{
		return new HitObject(hoVals[0], hoVals[1], hoVals[2], hoVals[3], hoVals[4]);
	}
	
	// slider or sliderNewCombo
	else if((hoVals[3] & 2)) 
	{
		return new HitSlider(hoVals[0], hoVals[1], hoVals[2], hoVals[3], hoVals[4], lineStream);
	}
	
	// spinner
	else if((hoVals[3] & 8)) 
	{
		return new HitSpinner(hoVals[0], hoVals[1], hoVals[2], hoVals[3], hoVals[4], lineStream);
	}
	
	else
	{
		NSLog(@"I asserted zero. Woops.");
		assert(0);
		return 0;
	}
}

std::ostream& operator<<(std::ostream& os, const HitObject& o) {
	cout << o.x << "\t" << o.y << "\t" << o.startTimeMs;
	return os;
}



 Beatmap::Beatmap(OSUString filename) {
	 /* This is a bunch of code to get an ifstream from a cstr path to a resource*/
	 NSBundle *b = [NSBundle mainBundle];
	 NSString *dir = [b resourcePath];
	 NSArray *parts = [NSArray arrayWithObjects:
					   dir, [NSString stringWithUTF8String:filename], (void *)nil];
	 NSString *path = [NSString pathWithComponents:parts];
	 const char *cpath = [path fileSystemRepresentation];
	 string vertFile(cpath);
	 ifstream is(vertFile.c_str());
	 
	 string line;
	 int state;
	 string HitObjectsString("[HitObjects]\r");
	 
	 while(getline(is, line)) {
		 // skip comments
		 if(line.substr(0,2) == "//" || line == "\r")
		 continue;
		 
		 // read in a HitObject
		 if(state == 100 && line != "\r") {
			 HitObject * h = readHitObject(line);
			 hitObjects.push_back(h);
		 }
		 
		 // change state
		 if(line == HitObjectsString)
			 state = 100;
	 }
 }

/*
Beatmap::Beatmap(OSUString filename) {
	NSString* content = [NSString stringWithContentsOfFile:path
												  encoding:NSUTF8StringEncoding
													 error:NULL];
	
	ifstream is(filename);
	
	string line;
	int state;
	string HitObjectsString("[HitObjects]\r");
	
	while(getline(is, line)) {
		// skip comments
		if(line.substr(0,2) == "//" || line == "\r")
			continue;
		
		// read in a HitObject
		if(state == 100 && line != "\r") {
			HitObject h = readHitObject(line);
			hitObjects.push_back(h);
		}
		
		// change state
		if(line == HitObjectsString)
			state = 100;
	}
}
*/


