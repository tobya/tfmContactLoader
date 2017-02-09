//
//  GroupManagerTableView.h
//  tfmContacts3
//
//  Created by Toby Allen on 02/09/2010.
//  Copyright 2010 Toby Allen - Toflidium Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupDetails.h"
@class tfmContacts3AppDelegate;
@interface GroupManagerTableView : UITableViewController {
	
	NSArray	*groups;
	NSArray *filegroups;
	GroupDetails *detailView;
	UITableView *tvtableView;
	tfmContacts3AppDelegate *appDelegate;

}



@property (nonatomic, retain) NSArray	*groups; 
@property (nonatomic, retain) NSArray	*filegroups; 
@property (nonatomic, retain) GroupDetails *detailView; 
@property (nonatomic,retain) IBOutlet UITableView *tvtableView;
@property (nonatomic,retain) tfmContacts3AppDelegate *appDelegate;
@end

