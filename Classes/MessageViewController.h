//
//  MessageViewController.h
//  dreaMote
//
//  Created by Moritz Venn on 17.10.08.
//  Copyright 2008-2011 Moritz Venn. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CellTextField.h" /* CellTextField, EditableTableViewCellDelegate */
#import "MessageTypeViewController.h" /* MessageTypeDelegate */

/*!
 @brief Message View.
 
 View to be used to send messages to the STB.
 */
@interface MessageViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate,
													UITableViewDataSource, MessageTypeDelegate,
													EditableTableViewCellDelegate>
{
@private
	UITextField *_messageTextField; /*!< @brief Text Field. */
	CellTextField *_messageCell; /*!< @brief Text Cell. */
	UITextField *_captionTextField; /*!< @brief Caption Field. */
	CellTextField *_captionCell; /*!< @brief Caption Cell. */
	UITextField *_timeoutTextField; /*!< @brief Timeout Field. */
	CellTextField *_timeoutCell; /*!< @brief Timeout Cell. */
	UIButton *_sendButton; /*!< @brief "Send" Button. */
	NSUInteger _type; /*!< @brief Selected message type. */
	UITableViewCell *_typeCell; /*!< @brief Cell with textual representation of message type. */
}

@end
