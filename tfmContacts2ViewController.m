//
//  tfmContacts2ViewController.m
//  tfmContacts2
//
//  Created by Toby Allen on 26/07/2010.
//  Copyright Toby Allen Toflidium Software 2010. All rights reserved.
//

#import "tfmContacts2ViewController.h"
#import "tfmContacts3AppDelegate.h"
#import "ABContactsHelper.h"
#import "BPUUID.h"
#import "VirtualGroup.h" 

@implementation tfmContacts2ViewController


@synthesize edURL;
@synthesize edGroupName;
@synthesize activityIndicator;
@synthesize metaData;
@synthesize lblProgress;
@synthesize currentProgress;
@synthesize kappShortName;
@synthesize btnOpenSafari;
@synthesize btnLoadFromURL;
@synthesize appDelegate;



-(void) toggleActivityView;
{
	if([activityIndicator isAnimating])
	{
		[activityIndicator stopAnimating];
		 activityIndicator.hidden = YES;
		btnLoadFromURL.enabled = YES;
			
	}
		else
		{	
		  [activityIndicator startAnimating];
			activityIndicator.hidden = NO;
			btnLoadFromURL.enabled = NO;

		}
}

- (IBAction)animateClick:(id)sender
{
	[self toggleActivityView];
	self.currentProgress = @"My Label Caption";
	
	[self performSelectorOnMainThread:@selector(updateLabel) withObject:nil waitUntilDone:YES];
}









- (NSString *)saveMetaData
{
/*	
	NSString *metaDataFilename = [self dataFilePath:@"mdata.plist"];
	
		NSMutableDictionary *metaData = [NSMutableDictionary dictionaryWithContentsOfFile:metaDataFilename];

	[self.metaData writeToFile:metaDataFilename atomically:YES];
	[metaDataFilename release];*/
	
}

- (NSString *)loadMetaData
{
/*	NSString *metaDataFilename = [self dataFilePath:@"mdata.plist"];
	if ([[NSFileManager defaultManager] fileExistsAtPath:metaDataFilename])	
	{
	
	NSMutableDictionary *dict =  [NSMutableDictionary dictionaryWithContentsOfFile:metaDataFilename];
		self.metaData = dict;
			[dict release];
	}
	else {
		
		NSMutableArray *array = [[NSArray alloc] init];
		
		NSMutableDictionary *dict = [[NSMutableDictionary alloc] 
																 initWithObjectsAndKeys:@"GroupCount", 
																 [NSNumber numberWithInt:0],
																 array,@"Details",
																 nil];
			self.metaData = dict;
			[dict release];
		[array release];
	}


	

	[metaDataFilename release];
	
	*/
	
	
}


-(void)viewWillAppear:(BOOL)animated
{

 self.lblProgress.text = @"Enter the URL containing the details of the contacts you wish to import, or navigate to the URL your IT staff has given you.  See Help for more information";
	
}

- (void)viewDidLoad {

	
	
	self.appDelegate = (tfmContacts3AppDelegate *)[[UIApplication sharedApplication] delegate];
	self.appDelegate.mainView = self;
	
	

	self.kappShortName = @"ContactLoader";

	[self loadUrl];
	[super viewDidLoad];
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
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.appDelegate = nil;
	[self saveMetaData];

}


- (void)dealloc {


	
    [super dealloc];
}



#pragma mark Startup
- (void)loadUrl
{
	NSString *passedURL = [[NSUserDefaults standardUserDefaults] stringForKey:@"url"];
	
	if (passedURL != nil)
	{
		NSURL *url = [[NSURL alloc] initWithString:passedURL];
	/*	NSLog([url path]);
		NSLog([url resourceSpecifier]);
		NSLog([url query]);
		NSLog([url scheme]);
		*/
		edURL.text =[[NSString alloc] initWithFormat:@"http:%@", [url resourceSpecifier], nil] ;
		
		
		
		//These lines Remove url from defaults so only used once.  Comment out to apply.
		//[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"url"];
		//	[[NSUserDefaults standardUserDefaults] synchronize];
		
		
		NSString *encodedURL = [edURL.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
				NSURL *linkurl =[NSURL URLWithString:encodedURL ];
		NSDictionary *dictContacts =  [NSDictionary dictionaryWithContentsOfURL:linkurl ];
		edGroupName.text = [dictContacts objectForKey:@"GroupName"];
		
		[url release];
		
		//Change to correct tab
		tfmContacts3AppDelegate *appDelegate = (tfmContacts3AppDelegate *)[[UIApplication sharedApplication] delegate] ;
		appDelegate.tabBarController.selectedIndex = TAB_IMPORT;
//		appDelegate.tabBarController.selectedViewController = self;
		
	  //UIViewController *selectViewController = [appDelegate.tabBarController.viewControllers objectAtIndex:TAB_IMPORT ] 
		/*UIViewController *selectedViewController = [appDelegate.tabBarController.viewControllers objectAtIndex:1];
		[appDelegate.tabBarController setSelectedViewController:appDelegate.tabBarController.moreNavigationController];
		[appDelegate.tabBarController.moreNavigationController popToRootViewControllerAnimated:NO];//make sure we're at the top level More
		[appDelegate.tabBarController.moreNavigationController pushViewController:selectedViewController animated:NO];
		*/
		
		
		appDelegate = nil;
		
	}
	
	
}

#pragma mark Click Events



- (IBAction)clickLoadContacts:(id)sender
{
		[self toggleActivityView];
		self.lblProgress.hidden = NO;
		[self progressUpdate:@"Connecting..."];
		NSURL *url =[NSURL URLWithString:edURL.text ];
		//NSError *error;
		NSString *contactsPList = [NSString stringWithContentsOfURL:url]; //stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
		//NSLog(contactsPList);
	
		if ([self.edGroupName.text   isEqual:@""])
		{
			[self toggleActivityView];
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty Group"
																										message:@"Group Name cannot be blank.  Please choose another name."
																									 delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
			[alert release];
			
			return;
		
		
		}	
	
	
	if (contactsPList == nil)
	{
		
		[self displayAlertWithTitle:@"Download Failure" Message:@"Unable to download ContactLoader file from URL provided, perhaps the URL is incorrect or you do not have an active network connection?  Please modify and try again."];
		
		[self toggleActivityView];
		return;
	}
	[self hideKeyboard];
	
	  NSString *groupName = self.edGroupName.text;
		
	  //Load up an array to pass as parameter 
	NSArray *dataArray = [[NSArray alloc] initWithObjects:url,contactsPList, groupName,nil];// 
	//autorelease];  
		

	


	[self performSelectorInBackground:@selector(doLoadContacts_plist:) withObject:dataArray ];
	//[dataArray release];
	//[groupName release];
}




- (IBAction)backgroundTap:(id)sender
{
	[self hideKeyboard];
	
	
}

- (void)hideKeyboard
{
	[self.edURL resignFirstResponder];
	[self.edGroupName resignFirstResponder];
}


- (IBAction)openSafariClick:(id)sender
{
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:edURL.text]];
	self.btnOpenSafari.hidden = YES;
}

#pragma mark Implementation Functions

/*
- (id) addGroup:(NSString *)groupname
{
	NSArray *groups = [ABContactsHelper groupsMatchingNameExactly:groupname];
	printf("%d matching groups found\n", groups.count);

	//if exists 
	if (groups.count > 0)
	{
		return nil;	
	}
	
	
	ABGroup *agroup =  [ABGroup group];
	
	// set name
	agroup.name = groupname;
	
	
	// Save the new group
	[ABContactsHelper addGroup:agroup withError:nil];
	
	return agroup;
	
}
 */

- (void)displayAlertWithTitle:(NSString *)title Message:(NSString *)message 
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
																									message:message
																								 delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
	
}



- (void)doLoadContacts_plist:(id)sender
{
	//This method is called on a background thread so we need our own autorelease pool.
  NSAutoreleasePool *thePool = [[NSAutoreleasePool alloc] init];
	
	//Typecast our passed as object.
	//0:url
	//1:contactlist
	//2:groupname
	NSArray *data = (NSArray *)sender;
	NSError *error;
	//NSURL *url =[data objectAtIndex:0];
	NSURL *url =[NSURL URLWithString:edURL.text ];  
	//NSString *urlContent = [NSString stringWithContentsOfURL:url];// usedEncoding:NSASCIIStringEncoding error:error];
	//ABGroup *newGroup = [self addGroup:[data objectAtIndex:2]];
	
	
	//NSLog("@%", url);
	//NSLog(urlContent);
	//GUID To uniquely identify group for iphones that sync with google.
	BPUUID *UUID = [BPUUID UUID];
	NSString *guidString = [UUID stringRepresentation];	
	
	NSString *groupDesc = [data objectAtIndex:2];
	///NSLog(groupName);
	[self progressUpdate:[NSString stringWithFormat:@"Connecting to URL"]];
	importedGroup *newGroup = [[importedGroup alloc]initWithName:guidString];
	newGroup.groupDesc = groupDesc;
	//[groupName release];	
	
/*	if (newGroup == nil)
	{
	  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Group Exists"
																										message:@"A Group with the chosen name already exists.  Please choose another name."
																									 delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		[self toggleActivityView];
		return;
		
		
	}*/


	
	//[self progressUpdate:[NSString stringWithFormat:@"Creating Group"]];	
	//[ABContactsHelper addGroup:newGroup withError:nil];
	
	
	
	
	
	
	NSString *datafilename = [NSString stringWithFormat:@"%@.plist", newGroup.name, nil];
	//NSString *datafilenamecopy = [NSString stringWithFormat:@"copy_%@.plist", newGroup.name, nil];
	//NSString *datafilename = [NSString stringWithFormat:@"%@.plist", @"plist7600", nil];
	;
	
	
	//NSLog("@%" ,url);
	NSDictionary *dictContacts =  [NSDictionary dictionaryWithContentsOfURL:url ];

	//[dictContacts writeToFile:[datafilename asDocumentDirectoryFile] atomically:YES ]
	
	//[urlContent writeToFile:[datafilenamecopy asDocumentDirectoryFile] atomically:YES];
  //[urlContent release];
	//NSLog([datafilename asDocumentDirectoryFile]);
	//NSMutableDictionary *dictContacts =  [[NSMutableDictionary alloc] initWithContentsOfFile:[datafilename asDocumentDirectoryFile] ];
	
	//Create Metainfo to write to file
		NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:	 
																	[NSString stringWithFormat:@"%@",url],@"url",
																	 dictContacts,@"fileContent",	
																	 newGroup.name,@"groupName",
																 newGroup.groupDesc, @"groupdesc",
																 datafilename,@"filename",
																	guidString,@"groupGUID" ,nil];
	
	 [dict writeToFile:[datafilename asDocumentDirectoryFile] atomically:YES];
	 [dict release];
	
	
	
	//NSLog(urlContent);
	//
  NSString *finalMessage = @"All Contacts Imported.";
  NSString *abortImport = @"No";
	
	//NSArray *aContacts = [urlContent csvRows];
	//	printf("Tag %s\n", [aContacts description].UTF8String);
	
	
	if ([dictContacts count] == 0) {
		[self progressUpdate:@"No Contacts found at URL, please check with your technical support.  Click below to open url in Safari."];
	  [self toggleActivityView];
		self.btnOpenSafari.hidden = FALSE;
		//[self updateSafariButton];
		
		return ;
	}
	
	
	for (NSDictionary *row in [dictContacts objectForKey:@"Contacts"])
	{
		
		ABContact *newContact =  [ABContact contact];
	
		newContact.firstname = [[row valueForKey:@"FirstName"] stringByDecodingHTMLEntities];
	
		newContact.lastname =		[[row valueForKey:@"LastName"] stringByDecodingHTMLEntities];

		newContact.note =				[[NSString stringWithFormat:@"%@\nImportedBy %@ \n YourRefUniqueID:%@",
																			[row valueForKey:@"Notes"],self.kappShortName, 
																			[row valueForKey:@"YourRefUniqueID"],nil] stringByDecodingHTMLEntities];


		newContact.organization = [[row valueForKey:@"Company"] stringByDecodingHTMLEntities];
		newContact.jobtitle  = [[row valueForKey:@"JobTitle"] stringByDecodingHTMLEntities];
		newContact.department = [[row valueForKey:@"Department"] stringByDecodingHTMLEntities];	
		
		//Address
		NSMutableArray *addrs = [NSMutableArray array];
		NSDictionary *Addr1 = [ABContact addressWithStreet:	[[row valueForKey:@"Street"] stringByDecodingHTMLEntities]
																							withCity: [[row valueForKey:@"City"] stringByDecodingHTMLEntities]
																						 withState:	 [[row valueForKey:@"State"] stringByDecodingHTMLEntities]	 
																							 withZip:	 [[row valueForKey:@"Zip"] stringByDecodingHTMLEntities]
																					 withCountry:	[[row valueForKey:@"Country"] stringByDecodingHTMLEntities]	 
																							withCode:nil];
		[addrs addObject:[ABContact dictionaryWithValue:Addr1 andLabel:kABWorkLabel]];
		
		newContact.addressDictionaries = addrs;
		
/*
 // Addresses
 NSMutableArray *addies = [NSMutableArray array];
 NSDictionary *whaddy = [ABContact addressWithStreet:@"1600 Pennsylvania Avenue" withCity:@"Arlington" withState:@"Virginia" withZip:@"20202" withCountry:nil withCode:nil];
 [addies addObject:[ABContact dictionaryWithValue:whaddy andLabel:kABWorkLabel]];
 NSDictionary *bpaddy = [ABContact addressWithStreet:@"1 Main Street" withCity:@"Westmoreland" withState:@"Virginia" withZip:@"20333" withCountry:nil withCode:nil];
 [addies addObject:[ABContact dictionaryWithValue:bpaddy andLabel:kABHomeLabel]];
 peep.addressDictionaries = addies;
		
		
	*/
		
		// Emails
		NSMutableArray *emailarray = [NSMutableArray array];
		NSString *sEmail =[row valueForKey:@"Email_Home"];
		if (sEmail != nil) {		
			[emailarray addObject:[ABContact dictionaryWithValue:sEmail andLabel:kABHomeLabel]];
		}
		newContact.emailDictionaries = emailarray;

		

		// Phones
		NSMutableArray *phonearray = [NSMutableArray array];
		NSString *snumberM =[row valueForKey:@"Telephone_Home"];
		NSString *snumberH =[row valueForKey:@"Telephone_Mobile"];	

		if (snumberH != nil) {
			[phonearray addObject:[ABContact dictionaryWithValue:snumberH andLabel:kABPersonPhoneMainLabel]];
		}	
		if (snumberM != nil)
		{
			[phonearray addObject:[ABContact dictionaryWithValue:snumberM andLabel:kABPersonPhoneMobileLabel]];
		}

		newContact.phoneDictionaries = phonearray;
		
		
		
		
		
		
		
		
		

	//	if ([self urlExists:[NSURL URLWithString:[row valueForKey:@"ImageURL"]]])
			//	 {
		NSData *mydata = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[row valueForKey:@"ImageURL"]]];
		NSLog(@"Anoher Loop Got URL");
		newContact.image = [[UIImage alloc] initWithData:mydata];
		[mydata release];
		//		 }
		// URLS
		NSMutableArray *urls = [NSMutableArray array];
		
		
		NSString *idURL1   =[row valueForKey:@"HomePageURL"];	
		//NSLog(idURL1);
		if (idURL1 != NULL)
		{
		[urls addObject:[ABContact dictionaryWithValue:idURL1  andLabel:kABPersonHomePageLabel]];		
		}
														
		NSString *idURL2 = [NSString 
											 stringWithFormat:@"contactloader.toflidium.com/id/%@/%@",
											 guidString,
											 [newGroup.groupDesc  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], nil];	
		
		
		
		[urls addObject:[ABContact dictionaryWithValue:idURL2  andLabel:@"ContactGroupID"]];
		newContact.urlDictionaries = urls;	
	//	[idURL1 release];
	//	[idURL2 release];
		NSError *error;
		if (![ABContactsHelper addContact:newContact withError:&error]) // save to address book
			NSLog(@"Error: %@", [error localizedDescription]);	

		[self progressUpdate:[NSString stringWithFormat:@"Importing  %@ %@", newContact.firstname,newContact.lastname ,nil]];
		
		
	
	}//for
	
	
	if ([abortImport isEqualToString:@"Yes"] ) 
	{ 
		finalMessage = @"Not Complete. Import Aborted";
		//NSArray *groupMembers = newGroup.members;
		
		/*for (ABContact *aContact in groupMembers)
		 {
		 [aContact removeSelfFromAddressBook:nil];
		 }*/
		
		
		//[newGroup removeSelfFromAddressBook:nil]; 
		
	}

	self.appDelegate.groupChanged = TRUE;

  [self progressUpdate:finalMessage];	

	[self toggleActivityView ];

	//[newGroup release];
	
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
	//NSLog( @"updateLabel %@",self.currentProgress, nil);	
	
}


@end








@implementation NSString (ParsingExtensions)

//http://localhost:8080/Server/zingby/bcsstudents/temp001/reports/asset_studentcontactdetails.csv.php?courseid=100058
//http://192.168.2.109:8080/Server/zingby/bcsstudents/temp001/reports/asset_studentcontactdetails.csv.php?courseid=100058

- (NSString *)asDocumentDirectoryFile{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	
	NSString *DocsDir = [paths objectAtIndex:0];
	return [DocsDir stringByAppendingPathComponent:self];
}

@end



