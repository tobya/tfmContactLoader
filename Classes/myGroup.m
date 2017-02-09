//
//  myGroup.m
//  tfmContacts3
//
//  Created by Toby Allen on 13/03/2011.
//  Copyright 2011 Toby Allen - Toflidium Software. All rights reserved.
//

#import "myGroup.h"


@implementation importedGroup
@synthesize name;
@synthesize groupType;
@synthesize strGuid;
@synthesize contacts;


- initWithName: ( NSString *)groupname
{
	self = [super init];
	
	if ( self ) {
		
		self.name = groupname;
	}
	
	return self;
}


@end

