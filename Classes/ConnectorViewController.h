//
//  ConnectorViewController.h
//  Untitled
//
//  Created by Moritz Venn on 10.03.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConnectorViewController : UIViewController <UIScrollViewDelegate,
													UITableViewDelegate,
													UITableViewDataSource>
{
	UITableView *myTableView;

	@private
	NSInteger _selectedItem;
	SEL _selectCallback;
	id _selectTarget;
}

+ (ConnectorViewController *)withConnector: (NSInteger) connectorKey;
- (void)setTarget: (id)target action: (SEL)action;

@property (nonatomic) NSInteger selectedItem;
@property (nonatomic, retain) id selectTarget;
@property (nonatomic) SEL selectCallback;

@end
