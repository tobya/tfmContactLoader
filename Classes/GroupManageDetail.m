//
//  GroupManageViewController.m
//  tfmContacts3
//
//  Created by Toby Allen on 01/08/2010.
//  Copyright Toby Allen Toflidium Software 2010. All rights reserved.
//

#import "GroupManageDetail.h"
#import "ABContactsHelper.h"
#import "VirtualGroup.h"


@implementation GroupManageDetail

@synthesize pkrGroupNames;
@synthesize lblGroupName;
@synthesize pkGroupNames_Data;
@synthesize groupName;
@synthesize currentProgress;
@synthesize txtGroupSearch;
@synthesize btnReload;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {

	
	
	[self reloadGroups];

  [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
			[self reloadGroups];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	
	[pkGroupNames_Data release];
	[pkrGroupNames release];
    [super dealloc];
}

- (void) reloadGroups
{
	self.pkGroupNames_Data = nil;
	//self.pkGroupNames_Data = [ABContactsHelper groups];	
	//self.pkGroupNames_Data = [self ABGroupsToMyGroups:[ABContactsHelper groups]];
	//self.pkGroupNames_Data = [self.pkGroupNames_Data arrayByAddingObjectsFromArray:[self findIDGroups] ];
	self.pkGroupNames_Data = [self findIDGroups];
	[pkrGroupNames reloadComponent:0];
}

- (IBAction)deleteGroupClick:(id)sender
{
	NSInteger row = [pkrGroupNames selectedRowInComponent:0];
	
  ABGroup *selectedGroup = [pkGroupNames_Data objectAtIndex:row];
	
	
	NSString *alertTitle = [[NSString alloc] initWithFormat:@"Delete Group %@ and remove all associated contacts?", selectedGroup.name];
	
	UIActionSheet *confirmDeleteSheet = [[UIActionSheet alloc] initWithTitle:alertTitle delegate:self cancelButtonTitle:@"Cancel" 
																										destructiveButtonTitle:@"Yes" otherButtonTitles:nil];
	[confirmDeleteSheet showInView:self.view];
	[confirmDeleteSheet release];
	
	[alertTitle release];
	
}

- (IBAction)reloadClick:(id)sender
{
	[self reloadGroups];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex != [actionSheet cancelButtonIndex])
	{
			[self performSelectorInBackground:@selector(doDeleteGroup:) withObject:nil ];
	
	}
	else {
		NSLog(@"Cancelled Alert");
	}
	
}

- (IBAction)dumpDataClick:(id)sender
{
	// Regular data dump
	for (ABContact *person in [ABContactsHelper contacts])
	{
		printf("******\n");
		printf("Name: %s\n", person.compositeName.UTF8String);
		printf("Organization: %s\n", person.organization.UTF8String);
		printf("Title: %s\n", person.jobtitle.UTF8String);
		printf("Department: %s\n", person.department.UTF8String);
		printf("Note: %s\n", person.note.UTF8String);
		printf("Creation Date: %s\n", [person.creationDate description].UTF8String);
		printf("Modification Date: %s\n", [person.modificationDate description].UTF8String);
		printf("Emails: %s\n", [person.emailDictionaries description].UTF8String);
		printf("Phones: %s\n", [person.phoneDictionaries description].UTF8String);
		printf("URLs: %s\n", [person.urlDictionaries description].UTF8String);
		printf("Addresses: %s\n\n", [person.addressDictionaries description].UTF8String);
	}	
	[self findIDGroups];
}

#pragma mark Group Find Functions
-(NSArray *)findIDGroups
{
	//NSLog(@"In here");
	
	NSMutableDictionary *glist = [[NSMutableDictionary alloc] initWithCapacity:1];
	//NSMutableArray *glist = [[NSMutableArray alloc] initWithCapacity:1];
	NSMutableArray *GroupList;
	NSMutableArray *ContactList;
//	NSArray *personList = [ABContactsHelper contactsMatchingUrl:@"toflidium.com"];
	
	
	
	
	// Regular data dump
	for (ABContact *person in [ABContactsHelper contacts])
	{

		
		//	if ([note rangeOfString:@"EventContactsUniqueID"].location == NSNotFound)
		NSDictionary *urllist = [person urlDictionary];
		//NSLog(@"About to get key");			
		NSString *GroupID = [urllist objectForKey:@"ContactGroupID"] ;
		NSArray *groupIDPath = [GroupID componentsSeparatedByString:@"/"];
		/*for (NSString *item in groupIDPath) 
		{
			
			NSLog(item);
		
		}*/
		
		NSString *grpName = [groupIDPath objectAtIndex:[groupIDPath count]  -1];
		
		
		//NSLog(GroupID);
		//NSLog([urllist description]);
	  GroupList =	[glist objectForKey:GroupID];
	//	GroupList = 
		//NSInteger index = [glist indexOfObject:GroupID];
		/*if (index <> -1) {
			GroupList = [glist objectAtIndex:index];
		}
		else {
			
			GroupList = nil;
		}*/

		if (GroupID != nil) {
			
		
		if (GroupList == nil)
		{
			//NSMutableDictionary *list = [[NSMutableDictionary alloc] initWithCapacity:1];
		
			//NSMutableArray *ContactList = [[NSMutableArray alloc] initWithCapacity:1];
			//[ContactList addObject:person];
			//[glist setObject:ContactList forKey:GroupID  ];
			//NSLog(@"GroupList == nil");
			importedGroup *grp = [[importedGroup alloc] initWithName:GroupID];
		//	grp.contacts = [[NSMutableArray alloc] initWithCapacity:1];
			grp.groupType = @"EventGroup";
			grp.name = grpName;
			//7[grp.contacts addObject:person];
	
			//[ContactList release];
			//[grp release];
			
			
				
					//importedGroup *grp = [glist objectForKey:GroupID];
					grp.contacts = [ABContactsHelper contactsMatchingUrl:GroupID];		
			
					[glist setObject:grp forKey:GroupID  ];
			
				}
		else {
			//importedGroup *grp = [glist objectForKey:GroupID];
			//7[grp.contacts addObject:person];
		//	NSLog(@"Desc:%@",[grp.contacts description]);
			//NSLog(@"Count:%@",[grp.contacts count]);
			//[grp release];
			
		}
	 
		}
		
		//grp.contacts = [ABContactsHelper contactsMatchingUrl:[NSURL URLWithString:GroupID]]; 

		//
		
		 
	}
	//NSLog([glist description]);
		//NSLog(@"Array group"); 
	NSMutableArray *garray = [NSMutableArray arrayWithObjects:nil ];
	//NSLog(glist);
	for (importedGroup *key in glist)
	{
		
		//NSLog(@"another group %@", key,nil); 
		[garray addObject:[glist objectForKey:key]];
				
	}
	
	
	return garray;


}

-(NSArray *)findGroupsBy
{
	//NSLog(@"In findGroupsBy");
	
	NSMutableDictionary *glist = [[NSMutableDictionary alloc] initWithCapacity:1];
	//NSMutableArray *glist = [[NSMutableArray alloc] initWithCapacity:1];
	NSMutableArray *GroupList;
	NSMutableArray *ContactList;
	
	
	for (ABContact *person in [ABContactsHelper contacts])
	{
		
		
		//	if ([note rangeOfString:@"EventContactsUniqueID"].location == NSNotFound)
		NSDictionary *urllist = [person urlDictionary];
		//NSLog(@"About to get key");			
		NSString *GroupID = [urllist objectForKey:@"ContactGroupID"] ;
		NSArray *groupIDPath = [GroupID componentsSeparatedByString:@"/"];
	/*	for (NSString *item in groupIDPath) 
		{
			
			NSLog(item);
			
		}*/
		
		NSString *grpName = [groupIDPath objectAtIndex:[groupIDPath count]  -1];
		
		
		//NSLog(GroupID);
		//NSLog([urllist description]);
	  GroupList =	[glist objectForKey:GroupID];
		//	GroupList = 
		//NSInteger index = [glist indexOfObject:GroupID];
		/*if (index <> -1) {
		 GroupList = [glist objectAtIndex:index];
		 }
		 else {
		 
		 GroupList = nil;
		 }*/
		
		if (GroupID != nil) {
			
			
			if (GroupList == nil)
			{
				//NSMutableDictionary *list = [[NSMutableDictionary alloc] initWithCapacity:1];
				
				//NSMutableArray *ContactList = [[NSMutableArray alloc] initWithCapacity:1];
				//[ContactList addObject:person];
				//[glist setObject:ContactList forKey:GroupID  ];
			//	NSLog(@"GroupList == nil");
				importedGroup *grp = [[importedGroup alloc] initWithName:GroupID];
				//	grp.contacts = [[NSMutableArray alloc] initWithCapacity:1];
				grp.groupType = @"EventGroup";
				grp.name = grpName;
				//7[grp.contacts addObject:person];
				
				//[ContactList release];
				//[grp release];
				
				
				
				//importedGroup *grp = [glist objectForKey:GroupID];
				grp.contacts = [ABContactsHelper contactsMatchingUrl:GroupID];		
				
				[glist setObject:grp forKey:GroupID  ];
				
			}
			else {
				//importedGroup *grp = [glist objectForKey:GroupID];
				//7[grp.contacts addObject:person];
				//	NSLog(@"Desc:%@",[grp.contacts description]);
				//NSLog(@"Count:%@",[grp.contacts count]);
				//[grp release];
				
			}
			
		}
		
		//grp.contacts = [ABContactsHelper contactsMatchingUrl:[NSURL URLWithString:GroupID]]; 
		
		//
		
		
	}
//	NSLog([glist description]);
	//NSLog(@"Array group"); 
	NSMutableArray *garray = [NSMutableArray arrayWithObjects:nil ];
	//NSLog(glist);
	for (importedGroup *key in glist)
	{
		
		//NSLog(@"another group %@", key,nil); 
		[garray addObject:[glist objectForKey:key]];
		
		//NSLog([[[[glist objectForKey:key] contacts ] itemAtIndex:1]firstname ]);
		
		// NSLog([key description]);
		
		/*	for (ABContact *person in [glist objectForKey:key])
		 {
		 printf("******\n");
		 printf("Name: %s\n", person.compositeName.UTF8String);
		 
		 
		 }	*/
		
		
		
	}
	
	//self.pkGroupNames_Data = nil;
	//self.pkGroupNames_Data = glist;	
	
	//[pkrGroupNames reloadComponent:0];
	
	return garray;
	
	
}



- (NSArray *)ABGroupsToMyGroups:(NSArray *)groups
{
  NSMutableArray *list = [[NSMutableArray alloc] initWithCapacity:[groups count]];
	for(ABGroup *g in groups)
	{
		importedGroup *grp = [[importedGroup alloc]initWithName:g.name] ;
		grp.groupType = @"BuiltIn";
		//grp.strGuid = g.recordID;
		[list addObject:grp];
		[grp release];
		
	}
	return list;
	//[list release];
	
	
}


#pragma mark Implementation Functions
-(void)doDeleteGroup:(id)sender
{
	//This method is called on a background thread so we need our own autorelease pool.
  NSAutoreleasePool *thePool = [[NSAutoreleasePool alloc] init];
	
	NSInteger row = [pkrGroupNames selectedRowInComponent:0];
	
	importedGroup *selectedGroup = [pkGroupNames_Data objectAtIndex:row];
	
	
	
	if ([selectedGroup.groupType isEqualToString:@"BuiltIn" ]) {		
		//For some reason the selected group returned from Data Array is not right, so need to reretrieve
		//from actual contacts book.
		NSArray *matchingGroups = [ABContactsHelper groupsMatchingName:selectedGroup.name];
		
		ABGroup *myGroup = [matchingGroups objectAtIndex:0];
		
		
		/*NSLog(myGroup.name);
		for (ABGroup *group in [ABContactsHelper groups])
		{
			printf("Name: %s\n", group.name.UTF8String);
			NSArray *members = group.members;
			printf("Members: %d\n", members.count);
			
			int n = 1;
			for (ABContact *contact in members)
				printf("%d: %s\n", n++, contact.compositeName.UTF8String);
		}	*/
		NSArray *groupMembers = myGroup.members;
		
		for (ABContact *aContact in groupMembers)
		{
			[aContact removeSelfFromAddressBook:nil];
		}
		
		
		[selectedGroup removeSelfFromAddressBook:nil];
	}
	else
	{
		for (ABContact *aContact in selectedGroup.contacts)
		{
			[aContact removeSelfFromAddressBook:nil];
			NSString *msg = [NSString stringWithFormat:@"Deleting %@ %@" ,aContact.firstname,aContact.lastname,nil];
			[self progressUpdate:msg];
			//[msg release];
		}			
		
	}
	[self progressUpdate:@"All Contacts in Event Group Deleted."];
	[self reloadGroups];
	[thePool release];
}



#pragma mark Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	if ([self.pkGroupNames_Data count] == 0) {
		return 0;
	}
	
	if (component == 0)
	{
		//NSLog(@"Groups:%@",[self.pkGroupNames_Data count]);
		return [self.pkGroupNames_Data count];
		
	}
	else {
		/*ABGroup *grp = [pkGroupNames_Data objectAtIndex:row];
		 NSArray *members = [grp members];
		 return [members count];*/
		
		
		NSInteger groupRow = [pickerView selectedRowInComponent:0];
//		ABGroup *grp = [pkGroupNames_Data objectAtIndex:groupRow];
		importedGroup *grp = [pkGroupNames_Data objectAtIndex:groupRow];
		
		if ([grp.groupType isEqualToString:@"BuiltIn" ]) {
			
		

		NSArray *matchingGroups = [ABContactsHelper groupsMatchingName:grp.name];
		
		ABGroup *myGroup = [matchingGroups objectAtIndex:0];		
		
		
		NSInteger memberCount = [[myGroup members]		count];
		//NSLog(@"Group: %@ : Members:%@",grp.name, memberCount);
		printf("Members: %d\n", memberCount);
		return memberCount;
		}
		else {
			printf("Members: %d\n",[grp.contacts count]);
			return [grp.contacts count];
			
		}

	}
	
}

#pragma mark Picker Delegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	if (component == 0)
	{
	  if (row > -1)
		{
			importedGroup *grp = [pkGroupNames_Data objectAtIndex:row];
		
			return grp.name;
		}
	}
	else
	{
	//	printf("row: %d\n",row);
		
		NSInteger groupRow = [pickerView selectedRowInComponent:0];
		//ABGroup *grp = [pkGroupNames_Data objectAtIndex:groupRow];
		//NSLog( [pkGroupNames_Data description]);  
		importedGroup *grp = [pkGroupNames_Data objectAtIndex:groupRow];
		//NSLog(@"%@",grp);
	
		if ([grp.groupType isEqualToString:@"BuiltIn" ]) 
		{
			
		NSArray *matchingGroups = [ABContactsHelper groupsMatchingName:grp.name];
		
		ABGroup *myGroup = [matchingGroups objectAtIndex:0];	
		
		NSArray *members = [myGroup members];
		ABContact *contact = [members objectAtIndex:row];
		//NSLog(contact.firstname);
		//NSLog(myGroup.name);
		return contact.firstname;
		}
		else {
		//	NSInteger groupRow = [pickerView selectedRowInComponent:0];
		//	importedGroup *grp = [pkGroupNames_Data objectAtIndex:groupRow];
			//NSLog(@"FurtherDetails:%@", [grp.contacts description]);
			ABContact *contact = [grp.contacts objectAtIndex:row];
		
			return contact.firstname;
		}

	}
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
			 inComponent:(NSInteger)component
{
	if (component == 0)
	{
		importedGroup *grp = [pkGroupNames_Data objectAtIndex:row];
		
		self.lblGroupName.text = grp.name;
		
		[pickerView selectRow:0 inComponent:1 animated:YES];
		[pickerView reloadComponent:1];
	}
}

#pragma mark Progress Update Methods
			 
- (void)progressUpdate:(NSString *)msg
{
	self.currentProgress  = msg;
	
	[self performSelectorOnMainThread:@selector(updateLabel) withObject:nil waitUntilDone:YES];	
	
}

- (void)updateLabel;
{
	self.lblGroupName.text = self.currentProgress;	
	//NSLog( @"updateLabel %@",self.currentProgress, nil);	
	
}


@end



