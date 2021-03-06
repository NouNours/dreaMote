//
//  ServiceListController.h
//  dreaMote
//
//  Created by Moritz Venn on 08.03.08.
//  Copyright 2008-2011 Moritz Venn. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ServiceSourceDelegate.h"

// Forward declarations
@class EventListController;
@class CXMLDocument;
@protocol ServiceProtocol;
@protocol ServiceListDelegate;

/*!
 @brief Service List.
 
 Lists services of a Bouquet and opens EventListController for this Service upon
 selection.
 */
@interface ServiceListController : UIViewController <UITableViewDelegate, UITableViewDataSource,
													UIPopoverControllerDelegate, ServiceSourceDelegate,
													UISplitViewControllerDelegate>
{
@private
	UIPopoverController *popoverController;
	NSObject<ServiceProtocol> *_bouquet; /*!< @brief Current Bouquet. */
	NSMutableArray *_services; /*!< @brief Service List. */
	id<ServiceListDelegate, NSCoding> _delegate; /*!< @brief Delegate. */
	BOOL _refreshServices; /*!< @brief Refresh Service List on next open? */
	BOOL _isRadio; /*!< @brief Are we in radio mode? */
	EventListController *_eventListController; /*!< @brief Caches Event List View. */
	UIBarButtonItem *_radioButton; /*!< @brief Radio/TV-mode toggle */

	CXMLDocument *_serviceXMLDoc; /*!< Current Service XML Document. */
}

/*!
 @brief Set Service Selection Delegate.
 
 This Function is required for Timers as they will use the provided Callback when you change the
 Service of a Timer.
 
 @param delegate New delegate object.
 */
- (void)setDelegate: (id<ServiceListDelegate, NSCoding>) delegate;



/*!
 @brief Bouquet.
 */
@property (nonatomic, retain) NSObject<ServiceProtocol> *bouquet;

/*!
 @brief Currently in radio mode?
 */
@property (nonatomic) BOOL isRadio;

@end



/*!
 @brief Delegate for ServiceListController.

 Objects wanting to be called back by a ServiceListController need to implement this Protocol.
 */
@protocol ServiceListDelegate <NSObject>

/*!
 @brief Service was selected.
 
 @param newService Service that was selected.
 */
- (void)serviceSelected: (NSObject<ServiceProtocol> *)newService;

@end
