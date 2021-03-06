//
//  AppDelegate.h
//  dreaMote
//
//  Created by Moritz Venn on 08.03.08.
//  Copyright 2008-2011 Moritz Venn. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 @brief Application Delegate.
 */
@interface AppDelegate : NSObject  <UIApplicationDelegate, UITabBarControllerDelegate>
{
	BOOL wasSleeping;
	UIWindow *window; /*!< @brief Application window. */
	UITabBarController *tabBarController; /*!< @brief Tab Bar Controller. */
}

/*!
 @brief Application window.
 */
@property (nonatomic, retain) IBOutlet UIWindow *window;

/*!
 @brief Tab Bar Controller.
 */
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end
