//
//  myGroup.m
//  tfmContacts3
//
//  Created by Toby Allen on 13/03/2011.
//  Copyright 2011 Toby Allen - Toflidium Software. All rights reserved.
//

#import "VirtualGroup.h"
#import "ABContactsHelper.h"


@implementation importedGroup
@synthesize name;
@synthesize groupType;
@synthesize groupGuid;
@synthesize contacts;
@synthesize groupDesc;


- initWithName: ( NSString *)groupname
{
	self = [super init];
	
	if ( self ) {
		
		self.name = groupname;
	}
	
	return self;
}


@end


@implementation ABContactsHelper(VirtualExtensions)

+ (NSArray *) virtualGroupsByURLName:(NSString *) urlName
{

	
	NSMutableDictionary *glist = [[NSMutableDictionary alloc] initWithCapacity:1];
	NSMutableArray *GroupList;
	NSMutableArray *ContactList;
	
	// Cycle through all contacts
	for (ABContact *person in [ABContactsHelper contacts])
	{
		
		
		//	if ([note rangeOfString:@"EventContactsUniqueID"].location == NSNotFound)
		NSDictionary *urllist = [person urlDictionary];
	
		NSString *GroupID = [urllist objectForKey:urlName] ;
		NSArray *groupIDPath = [GroupID componentsSeparatedByString:@"/"];
		
		//Get grp GUID
		NSString *grpName = [groupIDPath objectAtIndex:2]  ;
		//NSLog(@"GrpNameBase:%@",grpName,nil);
		NSString *grpID = grpName;
		//NSString *grpDesc = grpName;
		//NSLog([groupIDPath count] );
	//	if ([groupIDPath count] > 2)
		//{
				NSString *grpDesc = [[groupIDPath objectAtIndex:3] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
	//	}


		//NSLog(grpDesc );
	  GroupList =	[glist objectForKey:GroupID];
	
		if (GroupID != nil) {
			
			//Create each Group Entry
			if (GroupList == nil)
			{

				importedGroup *grp = [[importedGroup alloc] initWithName:GroupID];
				grp.groupType = @"EventGroup";
				grp.name = grpName;
				grp.groupGuid = grpID;
				grp.groupDesc = grpDesc;
				grp.contacts =  [ABContactsHelper contactsMatchingUrl:GroupID];		
				
				[glist setObject:grp forKey:GroupID  ];
				
			}

			
		}
		
		
		
	}
	

	//Transfer to Array
  NSMutableArray *garray = [NSMutableArray arrayWithObjects:nil ];
	for (importedGroup *key in glist)
	{

		[garray addObject:[glist objectForKey:key]];
		
	}
	
	//self.pkGroupNames_Data = nil;
	//self.pkGroupNames_Data = glist;	
	
	//[pkrGroupNames reloadComponent:0];
	
	return garray;
	
	
}

+ (NSArray *) virtualGroupByGUID:(NSString *) guidStr
{
	NSRange range;
	
	NSArray *vGroups = [ABContactsHelper virtualGroupsByURLName:@"ContactGroupID"];
	for (importedGroup *grp in vGroups)
	{
		range = [grp.groupGuid rangeOfString:guidStr];
		if (range.location != NSNotFound) {
			return grp;
		}
		
	}
}



@end

