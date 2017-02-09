//
//  tfmContacts2ViewController.h
//  tfmContacts2
//
//  Created by Toby Allen on 26/07/2010.
//  Copyright Toflidium Software Toby Allen 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABGroup.h"
#import "tfmContacts3AppDelegate.h"
#import "NSString+HTML.h"

#define kmetaDataFileName = @"tfmContactsSettings.plist"

@class tfmContacts3AppDelegate;
        
@interface tfmContacts2ViewController : UIViewController 
  {
								

	NSMutableDictionary *metaData;
  UITextField *edURL;
	UITextField *edGroupName;
			UILabel *lblProgress;
	UIActivityIndicatorView *activityIndicator;
		NSString *currentProgress;
		NSString *kappShortName;	
		UIButton *btnOpenSafari;
		UIButton *btnLoadFromURL;
		tfmContacts3AppDelegate *appDelegate;
	
}


@property (nonatomic, retain)		IBOutlet UITextField *edURL;
@property (nonatomic , retain)	IBOutlet UITextField *edGroupName;	
@property (nonatomic , retain)	IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain)		NSMutableDictionary *metaData;
@property (nonatomic, retain)		IBOutlet 	UILabel *lblProgress;
@property (nonatomic,retain) IBOutlet UIButton *btnOpenSafari;
@property (nonatomic,retain) IBOutlet		UIButton *btnLoadFromURL;
@property (nonatomic,retain)		NSString *currentProgress;
@property (nonatomic, retain)		NSString *kappShortName;
@property (nonatomic,retain) tfmContacts3AppDelegate *appDelegate;




- (IBAction)createToby:(id)sender;
- (IBAction)deleteGroupClick:(id)sender;
- (IBAction)clickLoadContacts:(id)sender;
- (IBAction)backgroundTap:(id)sender;
- (IBAction)animateClick:(id)sender;
- (IBAction)openSafariClick:(id)sender;
- (id)			addGroup:(NSString *)groupname;
- (void)		reloadGroups;
- (NSString *)dataFilePath:(NSString *)filename;
- (NSString *)saveMetaData;
- (NSString *)loadMetaData;
- (void)		toggleActivityView;
- (void)		doLoadContacts:(id)sender;
- (void)		loadUrl;
- (void)progressUpdate:(NSString *)msg;

- (void)updateLabel;
- (void)displayAlertWithTitle:(NSString *)title Message:(NSString *)message ;
- (void)hideKeyboard;

@end

@interface NSString(ParsingExtensions)

	
 - (NSString *)asDocumentDirectoryFile;

@end

