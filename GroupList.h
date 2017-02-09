//
//  GroupList.h
//  tfmContacts3
//
//  Created by Toby Allen on 03/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GroupList : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>{
	UIPickerView *pkrList;
}

@property (nonatomic, retain) IBOutlet UIPickerView *pkrList; 

@end
