//
//  GroupDetails.m
//  tfmContacts3
//
//  Created by Toby Allen on 05/09/2010.
//  Copyright 2010 Toby Allen - Toflidium Software. All rights reserved.
//

#import "GroupDetails.h"
#import "ABContactsHelper.h"
#import <AddressBook/AddressBook.h>
#import <Foundation/Foundation.h>
#import <AddressBookUI/AddressBookUI.h>
#import "tfmContacts3AppDelegate.h"



@implementation GroupDetails
@synthesize lblgroupName;
@synthesize lblgroupURL;
@synthesize lblProgress;
@synthesize selectedGroup;
@synthesize groupName;
@synthesize currentProgress;
@synthesize members;
@synthesize tvContactList;
@synthesize lblGroupDescription;
@synthesize appDelegate;

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
	self.appDelegate = (tfmContacts3AppDelegate *)[[UIApplication sharedApplication] delegate];

    [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 
 

*/
- (void)viewWillAppear:(BOOL)animated {

	
	self.selectedGroup = (importedGroup *)[ABContactsHelper virtualGroupByGUID:[self groupName]]; //[matchingGroups objectAtIndex:0];
	
	
	self.members = [NSArray arrayWithArray:self.selectedGroup.contacts];
	
	
	self.lblGroupDescription.text = selectedGroup.groupDesc;
	self.lblgroupName.text = selectedGroup.name;
	self.lblgroupURL.text = @"No URL";
							
									
	[super viewWillAppear:animated];
}

 - (void)viewWillDisappear:(BOOL)animated {
	 
	 [super viewWillDisappear:animated];
 }
 

- (void)didReceiveMemoryWarning {
	
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	self.appDelegate = nil;
	 
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


#pragma mark OnEvent Functions


- (IBAction)deleteGroupClick:(id)sender
{
	
	
	NSString *alertTitle = [[NSString alloc] initWithFormat:@"Delete Group '%@' and remove all listed contacts?",self.selectedGroup.groupDesc ];
	
	UIActionSheet *confirmDeleteSheet = [[UIActionSheet alloc] initWithTitle:alertTitle delegate:self cancelButtonTitle:@"No" 
																										destructiveButtonTitle:@"Yes" otherButtonTitles:nil];
	[confirmDeleteSheet showFromTabBar:self.view];
	[confirmDeleteSheet release];
	
	[alertTitle release];
	
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	
	if (buttonIndex != [actionSheet cancelButtonIndex])
	{
		[self performSelectorInBackground:@selector(deleteGroup:) withObject:nil ];	
	}
	else {
		NSLog(@"Cancelled Alert");
	}
	
}

#pragma mark Implementation Functions
-(void)deleteGroup:(id)sender
{
	//This method is called on a background thread so we need our own autorelease pool.
  NSAutoreleasePool *thePool = [[NSAutoreleasePool alloc] init];
	
	//NSInteger row = [pkrGroupNames selectedRowInComponent:0];
	
	//importedGroup *selectedGroup = self.selectedGroup; //[pkGroupNames_Data objectAtIndex:row];
	NSString *groupName = self.selectedGroup.name;
	
	
	if ([self.selectedGroup.groupType isEqualToString:@"BuiltIn" ]) {		
		//For some reason the selected group returned from Data Array is not right, so need to reretrieve
		//from actual contacts book.
		NSArray *matchingGroups = [ABContactsHelper groupsMatchingName:self.selectedGroup.name];
		
		ABGroup *myGroup = [matchingGroups objectAtIndex:0];
	
		NSArray *groupMembers = myGroup.members;
		
		for (ABContact *aContact in groupMembers)
		{
			[aContact removeSelfFromAddressBook:nil];
		}
		
		
		[self.selectedGroup removeSelfFromAddressBook:nil];
	}
	else
	{
		for (ABContact *aContact in self.selectedGroup.contacts)
		{
			[aContact removeSelfFromAddressBook:nil];
			NSString *msg = [NSString stringWithFormat:@"Deleting %@ %@" ,aContact.firstname,aContact.lastname,nil];
			[self progressUpdate:msg];
			//[msg release];
		}			
		
	}
	[self progressUpdate:@"All Contacts in Event Group Deleted."];
	//[self reloadGroups];
	self.members = nil;
	
	//Delete Group File from Documents directory
	

/*	NSString *groupFile = [NSString stringWithFormat:@"%@.plist", [groupName asDocumentDirectoryFile],nil];
	NSLog(groupFile);
	
	NSFileManager *fm = [NSFileManager defaultManager];
	if ([fm fileExistsAtPath:groupFile]) 
	{
		NSError *error;
		[fm removeItemAtPath:groupFile  error:error];
		NSLog(error);
	}
		
	*/
	//[groupFile release];
	
	//[self performSelectorOnMainThread:@selector(setGroupChanged) withObject:nil waitUntilDone:YES];	
	self.appDelegate.groupChanged = TRUE;
	[tvContactList reloadData];
	[thePool release];
}



#pragma mark Progress Update Methods
- (void)progressUpdate:(NSString *)msg
{
	self.currentProgress  = msg;
	
	[self performSelectorOnMainThread:@selector(updateLabel) withObject:nil waitUntilDone:YES];	
	
}
- (void)updateLabel;
{
	self.lblProgress.text = self.currentProgress;	
//	NSLog( @"updateLabel %@",self.currentProgress, nil);	
	
}

- (void)popViewStack;
{
	//printf("popViewStack");
	//[self navigationController.popto
	[self.navigationController popViewControllerAnimated:YES];
		
}

- (void)setGroupChanged;
{
		self.appDelegate.groupChanged	= TRUE;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// Return the number of sections.
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// Return the number of rows in the section.
	return [self.members count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	NSInteger row = [indexPath row];
	
	ABContact *contact = [self.members objectAtIndex:row];
	
	// Configure the cell...
	[cell.textLabel setText:contact.contactName];
	cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
	// 	[cell.textLabel setText:[fileInfo objectForKey:@"groupName"]];
	
	return cell;
}




/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	
	 NSInteger row = [indexPath row];
	 
	ABContact *contact = [self.members objectAtIndex:row];
	

	ABPersonViewController *contactView = [[ABPersonViewController alloc] init];
	contactView.displayedPerson = contact.record;
/*	
	contactView.shouldShowLinkedPeople = YES;
	contactView.addressBook = [ABContactsHelper addressBook];
	NSMutableArray *props = [[NSMutableArray alloc] init];
	[props addObject:[NSNumber numberWithInt:kABPersonFirstNameProperty]];
	[props addObject:[NSNumber numberWithInt:kABPersonLastNameProperty]];
	[props addObject:[NSNumber numberWithInt:kABPersonURLProperty]];
	[props addObject:[NSNumber numberWithInt:kABPersonAddressProperty]];
	[props addObject:[NSNumber numberWithInt:kABPersonEmailProperty]];
	[props addObject:[NSNumber numberWithInt:kABPersonNoteProperty]];
	[props addObject:[NSNumber numberWithInt:kABPersonPhoneProperty]];
	contactView.displayedProperties = props;
	[props release];*/
	
	//contactView.personViewDelegate = self;
	
	// [self.navigationController pushViewController:contactView animated:YES];
	// [contactView release];
	 
	[self showPersonViewController:indexPath];

}

-(void)showPersonViewController:(NSIndexPath *)indexPath  
{ 
	
	NSInteger row = [indexPath row];
	
	ABContact *contact = [self.members objectAtIndex:row];
	
	

	//contactView.displayedPerson = contact.record;
	
	// Fetch the address book  
	ABAddressBookRef addressBook = ABAddressBookCreate(); 
	// Search for the person named "Appleseed" in the address book 
	//NSArray *people = (NSArray *)ABAddressBookCopyPeopleWithName(addressBook, CFSTR("Appleseed")); 
	
	ABRecordRef *person = (ABRecordRef *)ABAddressBookGetPersonWithRecordID(addressBook, contact.recordID);
	// Display "Appleseed" information if found in the address book  
	if ((person != nil) ) 
	{ 
		//ABRecordRef person = (ABRecordRef)[people objectAtIndex:0]; 
		ABPersonViewController *picker = [[[ABPersonViewController alloc] init] autorelease]; 
		picker.personViewDelegate = self; 
		picker.displayedPerson = person; 
		// Allow users to edit the person’s information 
		picker.allowsEditing = YES; 
		[self.navigationController pushViewController:picker animated:YES]; 
	} 
	else  
	{ 
		// Show an alert if "Appleseed" is not in Contacts 
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  
																										message:@"Could not find Appleseed in the Contacts application"  
																									 delegate:nil  
																					cancelButtonTitle:@"Cancel"  
																					otherButtonTitles:nil]; 
		[alert show]; 
		[alert release]; 
	} 
	
	//[people release]; 
	CFRelease(addressBook); 
} 




@end
