//
//  Event.m
//  dreaMote
//
//  Created by Moritz Venn on 01.01.09.
//  Copyright 2008-2011 Moritz Venn. All rights reserved.
//

#import "Event.h"

#import "CXMLElement.h"

@implementation EnigmaEvent

@synthesize timeString = _timeString;

- (NSObject<ServiceProtocol> *)service
{
	[NSException raise:@"ExcUnsupportedFunction" format:@""];
	return nil;
}

- (void)setService: (NSObject<ServiceProtocol> *)service
{
	[NSException raise:@"ExcUnsupportedFunction" format:@""];
}

- (NSString *)edescription
{
	const NSArray *resultNodes = [_node nodesForXPath:@"details" error:nil];
	for(CXMLElement *resultElement in resultNodes)
	{
		return [resultElement stringValue];
	}
	return nil;
}

- (void)setEdescription: (NSString *)new
{
	[NSException raise:@"ExcUnsupportedFunction" format:@""];
}

- (NSString *)sdescription
{
	return nil;
}

- (void)setSdescription: (NSString *)new
{
	[NSException raise:@"ExcUnsupportedFunction" format:@""];
}

- (NSString *)title
{
	const NSArray *resultNodes = [_node nodesForXPath:@"description" error:nil];
	for(CXMLElement *resultElement in resultNodes)
	{
		return [resultElement stringValue];
	}
	return nil;
}

- (void)setTitle: (NSString *)new
{
	[NSException raise:@"ExcUnsupportedFunction" format:@""];
}

- (NSDate *)end
{
	if(_end == nil)
	{
		const NSArray *resultNodes = [_node nodesForXPath:@"duration" error:nil];
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
		const NSArray *resultNodes = [_node nodesForXPath:@"start" error:nil];
		for(CXMLElement *resultElement in resultNodes)
		{
			[_timeString release];
			_timeString = nil;

			_begin = [[NSDate dateWithTimeIntervalSince1970: [[resultElement stringValue] doubleValue]] retain];
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
	[NSException raise:@"ExcUnsupportedFunction" format:@""];
}

- (id)initWithNode: (CXMLNode *)node
{
	if((self = [super init]))
	{
		_begin = nil;
		_end = nil;
		_node = [node retain];
	}
	return self;
}

- (void)dealloc
{
	[_begin release];
	[_end release];
	[_node release];
	[_timeString release];

	[super dealloc];
}

- (NSString *)description
{
	// NOTE: because we don't cache values this might lag a little...
	return [NSString stringWithFormat:@"<%@> Title: '%@'.\n Eit: '%@'.\n", [self class], self.title, self.eit];
}

- (void)setBeginFromString: (NSString *)newBegin
{
	[NSException raise:@"ExcUnsupportedFunction" format:@""];
}

- (void)setEndFromDurationString: (NSString *)newDuration
{
	[_timeString release];
	_timeString = nil;
	
	if(self.begin == nil)
		[NSException raise:@"ExcBeginNull" format:@""];
	
	[_end release];
	_end = [[_begin addTimeInterval: [newDuration doubleValue]] retain];
}

- (BOOL)isEqualToEvent: (NSObject<EventProtocol> *)otherEvent
{
	return [self.eit isEqualToString: otherEvent.eit] &&
		[self.title isEqualToString: otherEvent.title] &&
		[self.sdescription isEqualToString: otherEvent.sdescription] &&
		[self.edescription isEqualToString: otherEvent.edescription] &&
		[self.begin isEqualToDate: otherEvent.begin] &&
		[self.end isEqualToDate: otherEvent.end] &&
		[self.service isEqualToService: otherEvent.service];
}

- (NSComparisonResult)compare: (NSObject<EventProtocol> *)otherEvent
{
	return [otherEvent.begin compare: self.begin];
}

@end
