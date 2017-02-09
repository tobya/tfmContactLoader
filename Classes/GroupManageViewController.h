//
//  GroupManageViewController.h
//  tfmContacts3
//
//  Created by Toby Allen on 01/08/2010.
//  Copyright Toby Allen Toflidium Software 2010. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GroupManageViewController : UIViewController
										< UIPickerViewDelegate, 
											UIPickerViewDataSource,
											UIActionSheetDelegate>
{
	UIPickerView *pkrGroupNames;
	              
  NSArray *pkGroupNames_Data;

}

@property (nonatomic,retain) IBOutlet UIPickerView *pkrGroupNames;
@property (nonatomic,retain) NSArray *pkGroupNames_Data;
- (IBAction)deleteGroupClick:(id)sender;
- (void)	reloadGroups;
- (IBAction)dumpDataClick:(id)sender;

@end
