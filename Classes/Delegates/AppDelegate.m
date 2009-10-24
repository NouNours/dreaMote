//
//  AppDelegate.m
//  dreaMote
//
//  Created by Moritz Venn on 08.03.08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "AppDelegate.h"
#import "Constants.h"

#import "RemoteConnectorObject.h"

@implementation AppDelegate

@synthesize window;
@synthesize navigationController;

/* initialize */
- (id)init
{
	if (self = [super init])
	{
		// Your initialization code here
	}
	return self;
}

/* finished launching */
- (void)applicationDidFinishLaunching:(UIApplication *)application
{
	// Show the window and view
	[window addSubview: navigationController.view];
	[window makeKeyAndVisible];

	NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
	NSNumber *activeConnectionId = [NSNumber numberWithInteger: 0];
	NSString *testValue = nil;

	// 0.1-0 configuration
	testValue = [stdDefaults stringForKey: kRemoteHost];
	if(testValue != nil)
	{
		// Build Connection Dict from old defaults
		NSDictionary *connection = [NSMutableDictionary dictionaryWithObjectsAndKeys:
									[stdDefaults stringForKey: kRemoteHost], kRemoteHost,
									[stdDefaults stringForKey: kUsername], kUsername,
									[stdDefaults stringForKey: kPassword], kPassword,
									[NSNumber numberWithInteger:
												[stdDefaults integerForKey: kConnector]], kConnector,
									nil];

		// Load, edit and save new connections array
		[RemoteConnectorObject loadConnections];
		NSMutableArray *connections = [RemoteConnectorObject getConnections];
		[connections addObject: connection];
		[RemoteConnectorObject saveConnections];

		// Remove old defaults
		[stdDefaults removeObjectForKey: kRemoteHost];
		[stdDefaults removeObjectForKey: kUsername];
		[stdDefaults removeObjectForKey: kPassword];
		[stdDefaults removeObjectForKey: kConnector];

		// Register new items
		NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
									 activeConnectionId, kActiveConnection,
									 @"NO", kVibratingRC,
									 @"YES", kConnectionTest,
									 @"10", kMessageTimeout,
									 nil];

		[stdDefaults registerDefaults: appDefaults];
		[stdDefaults synchronize];
	}
	// 0.2-0 configuration
	else if((testValue = [stdDefaults stringForKey: kActiveConnection]) == nil)
	{
		// since no default values have been set (i.e. no preferences file created), create it here
		NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
										activeConnectionId, kActiveConnection,
										@"NO", kVibratingRC,
										@"YES", kConnectionTest,
										@"10", kMessageTimeout,
										nil];

		[stdDefaults registerDefaults: appDefaults];
		[stdDefaults synchronize];
	}
	else
		activeConnectionId = [NSNumber numberWithInteger: [testValue integerValue]];

	if([RemoteConnectorObject loadConnections])
		[RemoteConnectorObject connectTo: [activeConnectionId integerValue]];
}

/* close app */
- (void)applicationWillTerminate:(UIApplication *)application
{
	// Save our connection array
	[RemoteConnectorObject saveConnections];
	[RemoteConnectorObject disconnect];
}

/* dealloc */
- (void)dealloc
{
	[window release];
	[navigationController release];

	[super dealloc];
}

@end