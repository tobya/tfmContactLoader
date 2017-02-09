//
//  GroupManage2.h
//  tfmContacts3
//
//  Created by Toby Allen on 02/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GroupManage2 : UIViewController < UIPickerViewDelegate, 
UIPickerViewDataSource>{
	
	UIPickerView *pkGroupPkr;

}

@property (nonatomic, retain) IBOutlet 	UIPickerView *pkGroupPkr;

@end
