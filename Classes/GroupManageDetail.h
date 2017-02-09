//
//  GroupManageViewController.h
//  tfmContacts3
//
//  Created by Toby Allen on 01/08/2010.
//  Copyright Toby Allen Toflidium Software 2010. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GroupManageDetail : UIViewController
										< UIPickerViewDelegate, 
											UIPickerViewDataSource,
											UIActionSheetDelegate>
{
	UIPickerView *pkrGroupNames;
	UILabel *lblGroupName;      
	UITextField *txtGroupSearch;
	UIButton *btnReload;
  NSArray *pkGroupNames_Data;
  NSString *groupName;
	NSString *currentProgress;
	
}




@property (nonatomic,retain) IBOutlet UIPickerView *pkrGroupNames;
@property (nonatomic, retain) IBOutlet UILabel *lblGroupName; 
@property (nonatomic, retain) IBOutlet UITextField *txtGroupSearch;
@property (nonatomic, retain) IBOutlet UIButton *btnReload;
@property (nonatomic,retain) NSArray *pkGroupNames_Data;
@property (nonatomic,retain)  NSString *groupName;
@property (nonatomic,retain) NSString *currentProgress;
- (IBAction)deleteGroupClick:(id)sender;
- (IBAction)reloadClick:(id)sender;
- (void)	reloadGroups;
- (IBAction)dumpDataClick:(id)sender;


@end




@interface eventGroup 
{
	NSString *groupName;
	NSString *groupID;
}



@end

