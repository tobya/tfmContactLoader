//
//  InstructionsViewController.h
//  tfmContacts3
//
//  Created by Toby Allen on 04/08/2010.
//  Copyright Toby Allen Toflidium Software 2010. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface InstructionsViewController : UIViewController <UIWebViewDelegate> {

	UIWebView *webView;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;

@end
