//
//  myGroup.h
//  tfmContacts3
//
//  Created by Toby Allen on 13/03/2011.
//  Copyright 2011 Toby Allen - Toflidium Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABContactsHelper.h"


@interface importedGroup: NSObject{
	
	NSString *name ;
	NSString *groupType; //iphone / guid
	NSString *groupguid;
	NSString *groupDesc ;
	NSMutableArray *contacts;
	
}

@property (nonatomic, retain) 	NSString *name ;
@property (nonatomic, retain) NSString *groupType; //iphone / guid
@property (nonatomic, retain) NSString *groupGuid;
@property (nonatomic, retain) NSString *groupDesc ;
@property (nonatomic, retain) NSArray *contacts;
- initWithName: (NSString *)groupname;
@end





@interface ABContactsHelper(VirtualExtensions)


+ (NSArray *) virtualGroupsByURLName:(NSString *) urlName;
+ (NSArray *) virtualGroupByGUID:(NSString *) guidStr;

@end