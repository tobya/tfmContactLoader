//
//  GroupDetails.h
//  tfmContacts3
//
//  Created by Toby Allen on 05/09/2010.
//  Copyright 2010 Toby Allen - Toflidium Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABContactsHelper.h"
#import "VirtualGroup.h"
#import "tfmContacts3AppDelegate.h"

@class tfmContacts3AppDelegate;

@interface GroupDetails : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate> {

	importedGroup *selectedGroup ;
	NSString *groupName;
	UILabel *lblgroupName;
	UILabel *lblgroupURL;
	UILabel *lblProgress;
	UILabel *lblGroupDescription;
	NSString *currentProgress;
	NSArray *members;
	
	UITableView *tvContactList;
	tfmContacts3AppDelegate *appDelegate;
}

@property (nonatomic, retain) IBOutlet	UILabel *lblgroupName;

@property (nonatomic, retain) IBOutlet UILabel *lblgroupURL;
@property (nonatomic, retain) IBOutlet UILabel *lblProgress;
@property (nonatomic, retain) IBOutlet UILabel *lblGroupDescription;
@property (nonatomic, retain) IBOutlet UITableView *tvContactList;
@property (nonatomic, retain) importedGroup *selectedGroup ;
@property (nonatomic, retain) NSString *groupName ;
@property (nonatomic, retain) NSString *currentProgress ;
@property (nonatomic, retain) 	NSArray *members;
@property (nonatomic, retain) 	tfmContacts3AppDelegate *appDelegate;

- (IBAction)deleteGroupClick:(id)sender;

@end
