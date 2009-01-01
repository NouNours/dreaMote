//
//  TimerXMLReader.h
//  dreaMote
//
//  Created by Moritz Venn on 31.12.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TimerXMLReader.h"

#import "../../Objects/Enigma2/Timer.h"

@implementation Enigma2TimerXMLReader

// Timers are 'heavy'
#define MAX_TIMERS 100

+ (Enigma2TimerXMLReader*)initWithTarget:(id)target action:(SEL)action
{
	Enigma2TimerXMLReader *xmlReader = [[Enigma2TimerXMLReader alloc] init];
	xmlReader.target = target;
	xmlReader.addObject = action;

	return xmlReader;
}

- (void)dealloc
{
	[super dealloc];
}

- (void)sendErroneousObject
{
	Enigma2Timer *fakeObject = [[Enigma2Timer alloc] init];
	fakeObject.title = NSLocalizedString(@"Error retrieving Data", @"");
	fakeObject.state = 0;
	fakeObject.valid = NO;
	[self.target performSelectorOnMainThread: self.addObject withObject: fakeObject waitUntilDone: NO];
	[fakeObject release];
}

/*
 Example:
 <?xml version="1.0" encoding="UTF-8"?>
 <e2timerlist>
  <e2timer>
   <e2servicereference>1:0:1:445C:453:1:C00000:0:0:0:</e2servicereference>
   <e2servicename>SAT.1</e2servicename>
   <e2eit>48286</e2eit>
   <e2name>Numb3rs - Die Logik des Verbrechens</e2name>
   <e2description>Numb3rs - Die Logik des Verbrechens</e2description>
   <e2descriptionextended>N/A</e2descriptionextended>
   <e2disabled>0</e2disabled>
   <e2timebegin>1205093400</e2timebegin>
   <e2timeend>1205097600</e2timeend>
   <e2duration>4200</e2duration>
   <e2startprepare>1205093380</e2startprepare>
   <e2justplay>0</e2justplay>
   <e2afterevent>0</e2afterevent>
   <e2logentries></e2logentries>
   <e2filename></e2filename>
   <e2backoff>0</e2backoff>
   <e2nextactivation></e2nextactivation>
   <e2firsttryprepare>True</e2firsttryprepare>
   <e2state>0</e2state>
   <e2repeated>0</e2repeated>
   <e2dontsave>0</e2dontsave>
   <e2cancled>False</e2cancled>
   <e2color>000000</e2color>
   <e2toggledisabled>1</e2toggledisabled>
   <e2toggledisabledimg>off</e2toggledisabledimg>
  </e2timer>
 </e2timerlist>
*/
- (void)parseFull
{
	NSArray *resultNodes = NULL;
	NSUInteger parsedTimersCounter = 0;
	
	resultNodes = [_parser nodesForXPath:@"/e2timerlist/e2timer" error:nil];
	
	for(CXMLElement *resultElement in resultNodes)
	{
		if(++parsedTimersCounter >= MAX_TIMERS)
			break;
		
		// An e2timer in the xml represents a timer, so create an instance of it.
		Enigma2Timer *newTimer = [[Enigma2Timer alloc] initWithNode:(CXMLNode *)resultElement];

		[self.target performSelectorOnMainThread: self.addObject withObject: newTimer waitUntilDone: NO];
		[newTimer release];
	}
}

@end
