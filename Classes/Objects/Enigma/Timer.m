//
//  Timer.m
//  dreaMote
//
//  Created by Moritz Venn on 01.01.09.
//  Copyright 2008-2011 Moritz Venn. All rights reserved.
//

#import "Timer.h"

#import "CXMLElement.h"

#import "../Generic/Service.h"

/*!
 @brief Private functions of ConfigListController.
 */
@interface EnigmaTimer()
/*!
 @brief Translate timer flags into common representation.
 */
- (void)getTypedata;
@end

@implementation EnigmaTimer

@synthesize valid = _isValid;
@synthesize timeString = _timeString;

- (NSInteger)repeatcount
{
	return 0;
}

- (void)setRepeatcount: (NSInteger)new
{
	return;
}

- (NSString *)tdescription
{
	return nil;
}

- (void)setTdescription: (NSString *)new
{
	return;
}

- (NSString *)title
{
	if(_title == nil)
	{
		const NSArray *resultNodes = [_node nodesForXPath:@"event/description" error:nil];
		for(CXMLElement *resultElement in resultNodes)
		{
			self.title = [resultElement stringValue];
			break;
		}
	}
	return _title;
}

- (void)setTitle: (NSString *)new
{
	if(_title == new)
		return;
	[_title release];
	_title = [new retain];
}

- (NSString *)location
{
	return nil;
}

- (void)setLocation:(NSString *)new
{
	// IGNORE
}

- (NSObject<ServiceProtocol> *)service
{
	if(_service == nil)
	{
		NSArray *resultNodes = nil;
		NSString *sname = nil;
		NSString *sref = nil;

		resultNodes = [_node nodesForXPath:@"service/name" error:nil];
		for(CXMLElement *resultElement in resultNodes)
		{
			sname = [[resultElement stringValue] retain];
			break;
		}

		resultNodes = [_node nodesForXPath:@"service/reference" error:nil];
		for(CXMLElement *resultElement in resultNodes)
		{
			sref = [[resultElement stringValue] retain];
			break;
		}
		
		if(sname && sref)
		{
			_service = [[GenericService alloc] init];
			_service.sname = sname;
			_service.sref = sref;
		}
		[sname release];
		[sref release];
	}
	return _service;
}

- (void)setService: (NSObject<ServiceProtocol> *)new
{
	if(_service == new)
		return;
	[_service release];
	_service = [new retain];
}

- (NSString *)sname
{
	return nil;
}

- (NSString *)sref
{
	return nil;
}

- (NSDate *)end
{
	if(_end == nil)
	{
		const NSArray *resultNodes = [_node nodesForXPath:@"event/duration" error:nil];
		for(CXMLElement *resultElement in resultNodes)
		{
			[self setEndFromDurationString: [resultElement stringValue]];
			break;
		}
	}
	return _end;
}

- (void)setEnd: (NSDate *)new
{
	if(_end == new)
		return;
	[_end release];
	_end = [new retain];
}

- (NSDate *)begin
{
	if(_begin == nil)
	{
		const NSArray *resultNodes = [_node nodesForXPath:@"event/start" error:nil];
		for(CXMLElement *resultElement in resultNodes)
		{
			[self setBeginFromString: [resultElement stringValue]];
			break;
		}
	}
	return _begin;
}

- (void)setBegin: (NSDate *)new
{
	if(_begin == new)
		return;
	[_begin release];
	_begin = [new retain];
}

- (NSString *)eit
{
	return nil;
}

- (void)setEit: (NSString *)new
{
	return;
}

- (BOOL)disabled
{
	return NO;
}

- (void)setDisabled: (BOOL)new
{
	return;
}

- (BOOL)justplay
{
	if(!_typedataSet)
	{
		[self getTypedata];
	}
	return _justplay;
}

- (void)setJustplay: (BOOL)new
{
	_justplay = new;
}

- (NSInteger)repeated
{
	if(!_typedataSet)
	{
		[self getTypedata];
	}

	return _repeated;
}

- (void)setRepeated: (NSInteger)new
{
	_repeated = new;
}

- (NSInteger)afterevent
{
	if(!_typedataSet)
	{
		[self getTypedata];
	}
	return _afterevent;
}

- (void)setAfterevent: (NSInteger)new
{
	_afterevent = new;
}

- (NSInteger)state
{
	if(!_typedataSet)
	{
		[self getTypedata];
	}
	return _state;
}

- (void)setState: (NSInteger)new
{
	_state = new;
}

- (id)init
{
	if((self = [super init]))
	{
		_duration = -1;
		_service = nil;
		_isValid = YES;
		_timeString = nil;
		_repeated = 0;

		_typedataSet = NO;
	}
	return self;
}

- (id)initWithNode: (CXMLNode *)node
{
	if((self = [self init]))
	{
		_node = [node retain];
	}
	return self;
}

- (id)initWithTimer:(NSObject<TimerProtocol> *)timer
{
	if((self = [super init]))
	{
		_typedataSet = YES;

		_begin = [timer.begin copy];
		_end = [timer.end copy];
		_title = [timer.title copy];
		_justplay = timer.justplay;
		_service = [timer.service copy];
		_state = timer.state;
		_duration = -1;
		_isValid = timer.valid;
		_afterevent = timer.afterevent;

		// NOTE: we don't copy the node...
		// by accessing the properties we can be sure to have all the values though :P
	}

	return self;
}

- (void)dealloc
{
	[_begin release];
	[_end release];
	[_title release];
	[_service release];
	[_timeString release];
	
	[_node release];

	[super dealloc];
}

#pragma mark -
#pragma mark	Copy
#pragma mark -

- (id)copyWithZone:(NSZone *)zone
{
	id newElement = [[[self class] alloc] initWithTimer: self];

	return newElement;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@> Title: '%@'.\n Eit: '%@'.\n", [self class], self.title, self.eit];
}

- (NSString *)getStateString
{
	return [NSString stringWithFormat: @"%d", _state];
}

- (void)setBeginFromString: (NSString *)newBegin
{
	[_timeString release];
	_timeString = nil;

	[_begin release];
	_begin = [[NSDate dateWithTimeIntervalSince1970: [newBegin doubleValue]] retain];
	if(_duration != -1){
		[_end release];
		_end = [[_begin addTimeInterval: _duration] retain];
		_duration = -1;
	}
}

- (void)setEndFromString: (NSString *)newEnd
{
	[_timeString release];
	_timeString = nil;

	[_end release];
	_end = [[NSDate dateWithTimeIntervalSince1970: [newEnd doubleValue]] retain];
}

- (void)setEndFromDurationString: (NSString *)newDuration
{
	[_timeString release];
	_timeString = nil;

	if(_begin == nil) {
		_duration = [newDuration doubleValue];
		return;
	}
	[_end release];
	_end = [[_begin addTimeInterval: [newDuration doubleValue]] retain];
}

- (void)setSref: (NSString *)newSref
{
	return;
}

- (void)setSname: (NSString *)newSname
{
	return;
}

- (void)getTypedata
{
	const NSArray *resultNodes = [_node nodesForXPath:@"typedata" error:nil];
	for(CXMLElement *currentChild in resultNodes)
	{
		const NSInteger typeData = [[currentChild stringValue] integerValue];
		
		// We translate to Enigma2 States here
		if(typeData & stateRunning)
			_state = kTimerStateRunning;
		else if(typeData & stateFinished)
			_state = kTimerStateFinished;
		else // stateWaiting or unknown
			_state =  kTimerStateWaiting;

		if(typeData & doShutdown)
			_afterevent = kAfterEventStandby;
		else if(typeData & doGoSleep)
			_afterevent = kAfterEventDeepstandby;
		else
			_afterevent = kAfterEventNothing;

		if(typeData & SwitchTimerEntry)
			_justplay = YES;
		else // We assume RecTimerEntry here
			_justplay = NO;

		if(typeData & isRepeating)
		{
			if(typeData & Su)
				_repeated |= weekdaySun;
			if(typeData & Mo)
				_repeated |= weekdayMon;
			if(typeData & Tue)
				_repeated |= weekdayTue;
			if(typeData & Wed)
				_repeated |= weekdayWed;
			if(typeData & Thu)
				_repeated |= weekdayThu;
			if(typeData & Fr)
				_repeated |= weekdayFri;
			if(typeData & Sa)
				_repeated |= weekdaySat;
		}
		else
			_repeated = 0;

		_typedataSet = YES;
		return;
	}
}

@end
