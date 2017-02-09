//
//  tfmContacts3AppDelegate.h
//  tfmContacts3
//
//  Created by Toby Allen on 29/07/2010.
//  Copyright Toby Allen Toflidium Software 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tfmContacts2ViewController.h"
#import "ProgressView.h"

#define TAB_GROUPS 0;
#define TAB_IMPORT 1;
#define TAB_DEBUG 3;
#define TAB_INSTRUCTIONS 2;
@class tfmContacts2ViewController;

@interface tfmContacts3AppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
		tfmContacts2ViewController *mainView;
		ProgressView *progressView;
	
	bool groupChanged;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) tfmContacts2ViewController *mainView;
@property (nonatomic, retain) ProgressView *progressView;
@property (nonatomic) bool groupChanged;


@end
