//
//  myGroup.h
//  tfmContacts3
//
//  Created by Toby Allen on 13/03/2011.
//  Copyright 2011 Toby Allen - Toflidium Software. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface importedGroup: NSObject{
	
	NSString *name ;
	NSString *groupType; //iphone / guid
	NSString *strguid;
	NSMutableArray *contacts;
	
}

@property (nonatomic, retain) 	NSString *name ;
@property (nonatomic, retain) NSString *groupType; //iphone / guid
@property (nonatomic, retain) NSString *strGuid;
@property (nonatomic, retain) NSArray *contacts;
- initWithName: (NSString *)groupname;
@end




