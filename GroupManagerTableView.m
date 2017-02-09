 //
//  GroupManagerTableView.m
//  tfmContacts3
//
//  Created by Toby Allen on 02/09/2010.
//  Copyright 2010 Toby Allen - Toflidium Software. All rights reserved.
//

#import "GroupManagerTableView.h"
#import "ABContactsHelper.h"
#import "tfmContacts3AppDelegate.h"
#import "VirtualGroup.h"

@implementation GroupManagerTableView
@synthesize groups;
@synthesize filegroups;
@synthesize detailView;
@synthesize tvtableView;
@synthesize appDelegate;
#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
	
	self.detailView = [[GroupDetails alloc] initWithNibName:@"GroupDetails" bundle:nil];
	
	self.appDelegate = (tfmContacts3AppDelegate *)[[UIApplication sharedApplication] delegate];
	
	
    [super viewDidLoad];

}

- (void)viewDidUnload {
	self.appDelegate = nil;
	[self.groups release];
	

}

- (void)viewWillAppear:(BOOL)animated {
	
	if (self.appDelegate.groupChanged == TRUE) 
	{
		[self loadGroups];
	}
	
 	[self.tvtableView reloadData];
	
	
    [super viewWillAppear:animated];	

}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
}

/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark implementation Functions

- (void) loadGroups;
{

	self.groups = [ABContactsHelper virtualGroupsByURLName:@"ContactGroupID"];
  self.appDelegate.groupChanged = FALSE;
}

- (void) loadFiles
{
	NSString *bundleRoot = [[NSBundle mainBundle] bundlePath];
	NSArray *dirContents = [[NSFileManager defaultManager] directoryContentsAtPath:bundleRoot];
	NSArray *onlyPLISTs = [dirContents filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.plist'"]];
	
	
	return onlyPLISTs;
	
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	  if ([self.groups count] > 0) 
		{
			return [self.groups count];
		}
		else {
			return 1;
		}

}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	NSInteger row = [indexPath row];
	
	
	if ([self.groups count] == 0) 
	{
		  [cell.textLabel setText:@"No ContactLoader Groups Found"];
		cell.accessoryType =  UITableViewCellAccessoryNone;
	}
	else 
	{
	
	importedGroup *grp = [self.groups objectAtIndex:row];
	
    // Configure the cell...
  [cell.textLabel setText:grp.groupDesc];
		
	cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
	}
	
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
	
	if ([self.groups count] == 0) 
	{
	  return;
	}
	
	GroupDetails *detailViewController = [[GroupDetails alloc] initWithNibName:@"GroupDetails" bundle:nil];
	NSInteger row = [indexPath row];
	
	importedGroup *grp = [self.groups objectAtIndex:row];
	
	// Pass the selected object to the new view controller.
	detailViewController.groupName = grp.groupGuid;		
	

	[self.navigationController pushViewController:detailViewController animated:YES];
	[detailViewController release];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}



- (void)dealloc {
    [super dealloc];
}


@end
	 
	