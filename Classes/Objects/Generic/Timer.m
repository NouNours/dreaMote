//
//  Timer.m
//  dreaMote
//
//  Created by Moritz Venn on 09.03.08.
//  Copyright 2008-2011 Moritz Venn. All rights reserved.
//

#import "Timer.h"

#import "Service.h"

@implementation GenericTimer

@synthesize eit = _eit;
@synthesize begin = _begin;
@synthesize end = _end;
@synthesize title = _title;
@synthesize tdescription = _tdescription;
@synthesize disabled = _disabled;
@synthesize repeated = _repeated;
@synthesize repeatcount = _repeatcount;
@synthesize justplay = _justplay;
@synthesize service = _service;
@synthesize sref = _sref;
@synthesize sname = _sname;
@synthesize state = _state;
@synthesize afterevent = _afterevent;
@synthesize location = _location;
@synthesize valid = _isValid;
@synthesize timeString = _timeString;

+ (NSObject<TimerProtocol> *)withEvent: (NSObject<EventProtocol> *)ourEvent
{
	NSObject<TimerProtocol> *timer = [[GenericTimer alloc] init];
	timer.title = ourEvent.title;
	timer.tdescription = ourEvent.sdescription;
	timer.begin = ourEvent.begin;
	timer.end = ourEvent.end;
	timer.eit = ourEvent.eit;
	timer.disabled = NO;
	timer.justplay = NO;
	NSObject<ServiceProtocol> *newService = [[GenericService alloc] init];
	timer.service = newService;
	[newService release];
	timer.repeated = 0;
	timer.repeatcount = 0;
	timer.state = 0;
	timer.afterevent = 0;

	return [timer autorelease];
}

+ (NSObject<TimerProtocol> *)withEventAndService: (NSObject<EventProtocol> *)ourEvent: (NSObject<ServiceProtocol> *)ourService
{
	NSObject<TimerProtocol> *timer = [[GenericTimer alloc] init];
	timer.title = ourEvent.title;
	timer.tdescription = ourEvent.sdescription;
	timer.begin = ourEvent.begin;
	timer.end = ourEvent.end;
	timer.eit = ourEvent.eit;
	timer.disabled = NO;
	timer.justplay = NO;
	timer.service = ourService;
	timer.repeated = 0;
	timer.repeatcount = 0;
	timer.state = 0;

	return [timer autorelease];
}

+ (NSObject<TimerProtocol> *)timer
{
	NSObject<TimerProtocol> *timer = [[GenericTimer alloc] init];
	timer.begin = [NSDate date];
	timer.end = [timer.begin addTimeInterval: (NSTimeInterval)3600];
	timer.eit = @"-1";
	timer.title = @"";
	timer.tdescription = @"";
	timer.disabled = NO;
	timer.justplay = NO;
	NSObject<ServiceProtocol> *newService = [[GenericService alloc] init];
	timer.service = newService;
	[newService release];
	timer.repeated = 0;
	timer.repeatcount = 0;
	timer.state = 0;

	return [timer autorelease];
}

- (id)init
{
	if((self = [super init]))
	{
		_duration = -1;
		_service = nil;
		_isValid = YES;
		_timeString = nil;
	}
	return self;
}

- (id)initWithTimer:(NSObject<TimerProtocol> *)timer
{
	if((self = [super init]))
	{
		_begin = [timer.begin copy];
		_end = [timer.end copy];
		_eit = [timer.eit copy];
		_title = [timer.title copy];
		_tdescription = [timer.tdescription copy];
		_disabled = timer.disabled;
		_justplay = timer.justplay;
		_service = [timer.service copy];
		_repeated = timer.repeated;
		_repeatcount = timer.repeatcount;
		_state = timer.state;
		_duration = -1;
		_isValid = timer.valid;
		_afterevent = timer.afterevent;
	}

	return self;
}

- (void)dealloc
{
	[_begin release];
	[_end release];
	[_eit release];
	[_title release];
	[_tdescription release];
	[_service release];
	[_sname release];
	[_sref release];
	[_timeString release];

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
	if(_sname)
	{
		[_service release];
		_service = [[GenericService alloc] init];
		_service.sref = newSref;
		_service.sname = _sname;

		[_sname release];
		_sname = nil;
	}
	else
	{
		[_sref release];
		_sref = [newSref retain];
	}
}

- (void)setSname: (NSString *)newSname
{
	if(_sref)
	{
		[_service release];
		_service = [[GenericService alloc] init];
		_service.sref = _sref;
		_service.sname = newSname;

		[_sref release];
		_sref = nil;
	}
	else
	{
		[_sname release];
		_sname = [newSname retain];
	}
}

@end
