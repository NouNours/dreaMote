//
//  RCButton.m
//  Untitled
//
//  Created by Moritz Venn on 23.07.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "RCButton.h"

@implementation RCButton

@synthesize rcCode;

- (id)initWithFrame:(CGRect)frame
{
	if(self = [super initWithFrame:frame])
	{
		self.rcCode = -1;
	}
	return self;
}

@end