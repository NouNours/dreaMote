//
//  Movie.m
//  dreaMote
//
//  Created by Moritz Venn on 31.12.08.
//  Copyright 2008-2011 Moritz Venn. All rights reserved.
//

#import "Movie.h"

#import "CXMLElement.h"

@implementation EnigmaMovie

- (NSArray *)tags
{
	return _tags;
}

- (void)setTags: (NSArray *)new
{
	[NSException raise:@"ExcUnsupportedFunction" format:@""];
}

- (NSNumber *)size
{
	return _size;
}

- (void)setSize: (NSNumber *)new
{
	[NSException raise:@"ExcUnsupportedFunction" format:@""];
}

- (NSNumber *)length
{
	return _length;
}

- (void)setLength: (NSNumber *)new
{
	[NSException raise:@"ExcUnsupportedFunction" format:@""];
}

- (NSDate *)time
{
	return nil;
}

- (void)setTime: (NSDate *)new
{
	[NSException raise:@"ExcUnsupportedFunction" format:@""];
}

- (NSString *)sname
{
	return nil;
}

- (void)setSname: (NSString *)new
{
	[NSException raise:@"ExcUnsupportedFunction" format:@""];
}

- (NSString *)sref
{
	const NSArray *resultNodes = [_node nodesForXPath:@"reference" error:nil];
	for(CXMLElement *resultElement in resultNodes)
	{
		return [resultElement stringValue];
	}
	return nil;
}

- (void)setSref: (NSString *)new
{
	[NSException raise:@"ExcUnsupportedFunction" format:@""];
}

- (NSString *)edescription
{
	return NSLocalizedString(@"N/A", @"");
}

- (void)setEdescription: (NSString *)new
{
	[NSException raise:@"ExcUnsupportedFunction" format:@""];
}

- (NSString *)sdescription
{
	return NSLocalizedString(@"N/A", @"");
}

- (void)setSdescription: (NSString *)new
{
	[NSException raise:@"ExcUnsupportedFunction" format:@""];
}

- (NSString *)title
{
	const NSArray *resultNodes = [_node nodesForXPath:@"name" error:nil];
	for(CXMLElement *resultElement in resultNodes)
	{
		// We have to un-escape some characters here...
		return [[resultElement stringValue] stringByReplacingOccurrencesOfString: @"&amp;" withString: @"&"];
	}
	return nil;
}

- (void)setTitle: (NSString *)new
{
	[NSException raise:@"ExcUnsupportedFunction" format:@""];
}

- (id)initWithNode: (CXMLNode *)node
{
	if((self = [super init]))
	{
		_node = [node retain];
		_size = [[NSNumber numberWithInt: -1] retain];
		_tags = [[NSArray array] retain];
		_length = [[NSNumber numberWithInt: -1] retain];
	}
	return self;
}

- (void)dealloc
{
	[_length release];
	[_size release];
	[_tags release];
	[_node release];

	[super dealloc];
}

- (BOOL)isValid
{
	return _node && self.sref != nil;
}

- (void)setTimeFromString: (NSString *)newTime
{
	[NSException raise:@"ExcUnsupportedFunction" format:@""];
}

- (void)setTagsFromString: (NSString *)newTags
{
	[NSException raise:@"ExcUnsupportedFunction" format:@""];
}

@end
