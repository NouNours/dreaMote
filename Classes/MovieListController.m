//
//  MovieListController.m
//  Untitled
//
//  Created by Moritz Venn on 23.07.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MovieListController.h"

#import "MovieTableViewCell.h"
#import "MovieViewController.h"

#import "RemoteConnectorObject.h"
#import "Constants.h"
#import "FuzzyDateFormatter.h"

@implementation MovieListController

- (id)init
{
	self = [super init];
	if (self) {
		self.title = NSLocalizedString(@"Movies", @"Title of MovieListController");
		_movies = [[NSMutableArray array] retain];
		refreshMovies = YES;

		dateFormatter = [[FuzzyDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];

		movieViewController = nil;
	}
	return self;
}

- (void)dealloc
{
	[_movies makeObjectsPerformSelector:@selector(release)];
	[_movies release];
	[dateFormatter release];
	[movieViewController release];

	[super dealloc];
}

- (void)didReceiveMemoryWarning
{
	[movieViewController release];
	movieViewController = nil;

    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
	if(refreshMovies)
	{
		[_movies makeObjectsPerformSelector:@selector(release)];
		[_movies removeAllObjects];

		[(UITableView *)self.view reloadData];

		// Spawn a thread to fetch the movie data so that the UI is not blocked while the
		// application parses the XML file.
		[NSThread detachNewThreadSelector:@selector(fetchMovies) toTarget:self withObject:nil];
	}

	refreshMovies = YES;

	[super viewWillAppear: animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	if(refreshMovies)
	{
		[_movies makeObjectsPerformSelector:@selector(release)];
		[_movies removeAllObjects];
		[movieViewController release];
		movieViewController = nil;
	}

	[dateFormatter resetReferenceDate];
}

- (void)loadView
{
	UITableView *tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStylePlain];
	tableView.delegate = self;
	tableView.dataSource = self;
	tableView.rowHeight = kUIRowHeight;
	tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	tableView.sectionHeaderHeight = 0;

	// setup our content view so that it auto-rotates along with the UViewController
	tableView.autoresizesSubviews = YES;
	tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);

	self.view = tableView;
	[tableView release];
}

- (void)fetchMovies
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[[RemoteConnectorObject sharedRemoteConnector] fetchMovielist: self action:@selector(addMovie:)];
	[pool release];
}

- (void)addMovie:(id)movie
{
	if(movie != nil)
	{
		[_movies addObject: (Movie*)movie];
#ifdef ENABLE_LAGGY_ANIMATIONS
		[(UITableView*)self.view insertRowsAtIndexPaths: [NSArray arrayWithObject: [NSIndexPath indexPathForRow:[_movies count]-1 inSection:0]]
						withRowAnimation: UITableViewRowAnimationTop];
	}
	else
#else
	}
#endif
		[(UITableView *)self.view reloadData];
}

#pragma mark	-
#pragma mark		Table View
#pragma mark	-

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	MovieTableViewCell *cell = (MovieTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kMovieCell_ID];
	if(cell == nil)
		cell = [[[MovieTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:kMovieCell_ID] autorelease];

	cell.formatter = dateFormatter;
	cell.movie = [_movies objectAtIndex:indexPath.row];
	
	return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	Movie *movie = [_movies objectAtIndex: indexPath.row];
	if(movieViewController == nil)
		movieViewController = [[MovieViewController alloc] init];
	movieViewController.movie = movie;

	[self.navigationController pushViewController: movieViewController animated: YES];

	refreshMovies = NO;

	return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return [_movies count];
}

- (BOOL)shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
