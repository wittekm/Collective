/*
 *  osu-import.h
 *  Collective
 *
 *  Created by Max Wittek on 2/15/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 
 Based on .osu file format as specified by Peppy, osuspecv5.txt
 
 *
 */

#ifndef OSU_IMPORT_H
#define OSU_IMPORT_H

#include <vector>
#include <list>
#include <sstream>
#include "Utility.h"

typedef char * OSUString; // up for changing later

struct HitObject {
	HitObject() {}
	HitObject(int x_, int y_, int startTimeMs_, int objectType_, int soundType_) :
	x(x_), y(y_), startTimeMs(startTimeMs_), objectType(objectType_), soundType(soundType_) {}
	
	int x;
	int y;
	int startTimeMs;
	int objectType;
	int soundType;
	
	friend std::ostream &operator<<(std::ostream&, const HitObject&);
};

struct HitSlider : public HitObject {
	HitSlider(int x_, int y_, int startTimeMs_, int objectType_, int soundType_, std::stringstream& ss);
	
	int curveType;
	std::vector<std::pair<int, int> > sliderPoints;
	int repeatCount;
	int sliderLengthPixels;
};

struct HitSpinner : HitObject {
	HitSpinner(int x_, int y_, int startTimeMs_, int objectType_, int soundType_, std::stringstream& ss);
	
	int endTimeMs;
};

std::ostream& operator<<(std::ostream& os, const HitObject& o);

class Beatmap {
	
public:
	Beatmap(OSUString filename);
	
	// [General]
	OSUString AudioFilename;
	int AudioLeadIn;
	int PreviewTime;
	int Countdown;
	OSUString SampleSet;
	std::vector<int> EditorBookmarks;
	
	// [Metadata]
	OSUString Title, Artist, Creator, Version, Source, Tags;
	
	// [Difficulty]
	int HPDrainRate;
	int CircleSize;
	int OverallDifficulty;
	double SliderMultiplier;
	int SliderTickRate;
	
	// [Events]
	
	// [TimingPoints]
	int offsetMs;
	double beatLength;
	int timingSignature;
	int sampleSetId;
	bool useCustomSamples;
	
	// [Colours] (lol colours... up to five of them, btw
	std::vector<RGBColor> comboColors;
	
	// [HitObjects]
	std::list<HitObject> hitObjects;
};




#endif

