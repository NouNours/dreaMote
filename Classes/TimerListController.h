//
//  TimerListController.h
//  Untitled
//
//  Created by Moritz Venn on 09.03.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Timer.h"

@class FuzzyDateFormatter;
@class TimerViewController;

@interface TimerListController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
@private
	NSMutableArray *_timers;
	NSInteger dist[kTimerStateMax];
	FuzzyDateFormatter *dateFormatter;
	TimerViewController *timerViewController;
	BOOL _willReappear;
}

@property (nonatomic, retain) NSMutableArray *timers;
@property (nonatomic, retain) FuzzyDateFormatter *dateFormatter;

@end
