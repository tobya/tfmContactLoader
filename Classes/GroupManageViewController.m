//
//  GroupManageViewController.m
//  tfmContacts3
//
//  Created by Toby Allen on 01/08/2010.
//  Copyright Toby Allen Toflidium Software 2010. All rights reserved.
//

#import "GroupManageViewController.h"
#import "ABContactsHelper.h"


@implementation GroupManageViewController

@synthesize pkrGroupNames;
@synthesize pkGroupNames_Data;

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
	self.pkGroupNames_Data = [ABContactsHelper groups];	
	
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

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex != [actionSheet cancelButtonIndex])
	{
		
		
		NSInteger row = [pkrGroupNames selectedRowInComponent:0];
		
		ABGroup *selectedGroup = [pkGroupNames_Data objectAtIndex:row];
		
		
		//For some reason the selected group returned from Data Array is not right, so need to reretrieve
		//from actual contacts book.
		NSArray *matchingGroups = [ABContactsHelper groupsMatchingName:selectedGroup.name];
		
		ABGroup *myGroup = [matchingGroups objectAtIndex:0];
		
		
		NSLog(myGroup.name);
		for (ABGroup *group in [ABContactsHelper groups])
		{
			printf("Name: %s\n", group.name.UTF8String);
			NSArray *members = group.members;
			printf("Members: %d\n", members.count);
			
			int n = 1;
			for (ABContact *contact in members)
				printf("%d: %s\n", n++, contact.compositeName.UTF8String);
		}	
		NSArray *groupMembers = myGroup.members;
		
		for (ABContact *aContact in groupMembers)
		{
			[aContact removeSelfFromAddressBook:nil];
		}
		
		
		[selectedGroup removeSelfFromAddressBook:nil];
		
		[self reloadGroups];
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
}


#pragma mark Implementation Functions
-(void)doDeleteGroup:(id)sender
{
	
}



#pragma mark Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
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
		ABGroup *grp = [pkGroupNames_Data objectAtIndex:groupRow];
		NSArray *matchingGroups = [ABContactsHelper groupsMatchingName:grp.name];
		
		ABGroup *myGroup = [matchingGroups objectAtIndex:0];		
		
		
		NSInteger memberCount = [[myGroup members]		count];
		//NSLog(@"Group: %@ : Members:%@",grp.name, memberCount);
		printf("Members: %d\n", memberCount);
		return memberCount;
	}
	
}

#pragma mark Picker Delegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	if (component == 0)
	{
		ABGroup *grp = [pkGroupNames_Data objectAtIndex:row];
		return grp.name;
	}
	else
	{
		printf("row: %d\n",row);
		
		NSInteger groupRow = [pickerView selectedRowInComponent:0];
		ABGroup *grp = [pkGroupNames_Data objectAtIndex:groupRow];
		NSLog(@"%@",grp);
		NSArray *matchingGroups = [ABContactsHelper groupsMatchingName:grp.name];
		
		ABGroup *myGroup = [matchingGroups objectAtIndex:0];	
		
		NSArray *members = [myGroup members];
		ABContact *contact = [members objectAtIndex:row];
		NSLog(contact.firstname);
		NSLog(myGroup.name);
		return contact.firstname;
	}
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
			 inComponent:(NSInteger)component
{
	
	if (component == 0)
	{
		[pickerView selectRow:0 inComponent:1 animated:YES];
		[pickerView reloadComponent:1];
	}
}


@end
