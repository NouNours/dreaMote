//
//  SimpleRCEmulatorController.m
//  dreaMote
//
//  Created by Moritz Venn on 23.10.09.
//  Copyright 2009-2011 Moritz Venn. All rights reserved.
//

#import "SimpleRCEmulatorController.h"
#import "RemoteConnector.h"
#import "Constants.h"

#define SWIPE_MIN_DISPLACEMENT 10.0

@interface SimpleRCEmulatorController()
- (void)manageViews:(UIInterfaceOrientation)interfaceOrientation;
@end

@implementation SimpleRCEmulatorController

#if 0
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if((self = [super initWithNibName: @"SimpleRCEmulator" bundle: nil]))
	{
		//
	}
	return self;
}

- (void)viewDidLoad
{
	[self.view addSubview: self.rcView];
}
#endif

- (void)dealloc
{
	[_lameButton release];
	[_menuButton release];
	[_swipeArea release];

	[super dealloc];
}

- (void)loadView
{
	CGRect frame;
	const CGFloat factor = (IS_IPAD()) ? 2.0f : 1.0f;
	const CGFloat imageWidth = 135 * factor;
	const CGFloat imageHeight = 105 * factor;

	[super loadView];

	const CGSize mainViewSize = self.view.bounds.size;

	// create the rc views (i think its easier to have two views than to keep track of all buttons and add/remove them as pleased)
	frame = CGRectMake(0, 0, mainViewSize.width, mainViewSize.height);
	rcView = [[UIView alloc] initWithFrame: frame];
	[self.view addSubview:rcView];

	// TODO: we could add a volume slider too...

	// lame
	frame = CGRectMake(0, 0, imageWidth, imageHeight);
	_lameButton = [self newButton:frame withImage:@"exit.png" andKeyCode: kButtonCodeLame];
	[rcView addSubview: _lameButton];

	// menu
	frame = CGRectMake(mainViewSize.width - imageWidth, 0, imageWidth, imageHeight);
	_menuButton = [self newButton:frame withImage:@"menu.png" andKeyCode: kButtonCodeMenu];
	[rcView addSubview: _menuButton];

	// swipe
	if(IS_IPAD()){
		frame = CGRectMake(0, 200, 750, 690);
	}
	else
		frame = CGRectMake(0, 100, mainViewSize.width - kLeftMargin - kRightMargin, mainViewSize.height - 225);
	_swipeArea = [[UIButton alloc] initWithFrame: frame];
	_swipeArea.userInteractionEnabled = NO;
	UIImage *image = [UIImage imageNamed:@"4-sided-arrow.png"];
	[_swipeArea setBackgroundImage:image forState:UIControlStateHighlighted];
	[_swipeArea setBackgroundImage:image forState:UIControlStateNormal];
	[rcView addSubview: _swipeArea];
}

#pragma mark -
#pragma mark	Touch handling
#pragma mark -

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	const UITouch *touch = [[event allTouches] anyObject];
	lastLocation = [touch locationInView: self.view];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	const UITouch *touch = [[event allTouches] anyObject];
	const CGPoint location = [touch locationInView: self.view];
	const CGFloat xDisplacement = location.x - lastLocation.x;
	const CGFloat yDisplacement = location.y - lastLocation.y;
	const CGFloat xDisplacementAbs = (CGFloat)fabs(xDisplacement);
	const CGFloat yDisplacementAbs = (CGFloat)fabs(yDisplacement);

	// triple+ tap
	if([touch tapCount] > 2)
	{
		return;
	}
	// double tap
	if([touch tapCount] == 2)
	{
		[self sendButton: [NSNumber numberWithInteger: kButtonCodeOK]];
	}
	// horizontal swipe
	else if(xDisplacementAbs > yDisplacementAbs)
	{
		if(xDisplacementAbs <= SWIPE_MIN_DISPLACEMENT)
			return;

		// moved right?
		if(xDisplacement > 0.0)
		{
			[self sendButton: [NSNumber numberWithInteger: kButtonCodeRight]];
		}
		// moved left!
		else
		{
			[self sendButton: [NSNumber numberWithInteger: kButtonCodeLeft]];
		}
	}
	// vertical swipe
	else
	{
		if(yDisplacementAbs <= SWIPE_MIN_DISPLACEMENT)
			return;

		// moved down?
		if(yDisplacement > 0.0)
		{
			[self sendButton: [NSNumber numberWithInteger: kButtonCodeDown]];
		}
		// moved up!
		else
		{
			[self sendButton: [NSNumber numberWithInteger: kButtonCodeUp]];
		}
	}
}

/* touch stopped */
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	// TODO: anything?
	return;
}

/* move frames */
- (void)manageViews:(UIInterfaceOrientation)interfaceOrientation
{
	const CGFloat factor = (IS_IPAD()) ? 2.0f : 1.0f;
	const CGFloat imageWidth = 135 * factor;
	const CGFloat imageHeight = 105 * factor;
	CGSize mainViewSize = self.view.bounds.size;

	if(UIInterfaceOrientationIsLandscape(interfaceOrientation))
	{
		_lameButton.frame = CGRectMake(mainViewSize.width - imageWidth, kTopMargin, imageWidth, imageHeight);
		_menuButton.frame = CGRectMake(mainViewSize.width - imageWidth, mainViewSize.height - imageHeight, imageWidth, imageHeight);
		_swipeArea.frame = CGRectMake(kLeftMargin, kTopMargin, _swipeArea.frame.size.width, _swipeArea.frame.size.height);
	}
	else
	{
		_lameButton.frame = CGRectMake(0, 0, imageWidth, imageHeight);
		_menuButton.frame = CGRectMake(mainViewSize.width - imageWidth, 0, imageWidth, imageHeight);
		if(IS_IPAD())
			_swipeArea.frame = CGRectMake(kLeftMargin, 220, _swipeArea.frame.size.width, _swipeArea.frame.size.height);
		else
			_swipeArea.frame = CGRectMake(kLeftMargin, 130, _swipeArea.frame.size.width, _swipeArea.frame.size.height);
	}
}

/* view will appear */
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	// RCEmulatorController sends this message only when _navigationPad is set which we don't
	// we want to run this independent of them anyway ;-)
	[self manageViews:self.interfaceOrientation];
}

/* did rotate */
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[super didRotateFromInterfaceOrientation:fromInterfaceOrientation];

	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration: 0.3f];
	// FIXME: we give arbitrary value for landscape / non landscape since this is all we need to know
	[self manageViews:UIInterfaceOrientationIsLandscape(fromInterfaceOrientation) ? UIInterfaceOrientationPortrait : UIInterfaceOrientationLandscapeLeft];
	[UIView commitAnimations];
}

/* allow rotation */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
