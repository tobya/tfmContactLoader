//
//  InstructionsViewController.m
//  tfmContacts3
//
//  Created by Toby Allen on 04/08/2010.
//  Copyright Toby Allen Toflidium Software 2010. All rights reserved.
//

#import "InstructionsViewController.h"
#import "tfmContacts3AppDelegate.h"


@implementation InstructionsViewController
@synthesize webView;
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

	//[webView loadHTMLString:@"<html><body>Instructions</body></html>" baseURL:nil];
  [webView loadRequest:[NSURLRequest requestWithURL:
												[NSURL fileURLWithPath:
												 [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"]isDirectory:NO]]];
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request 
				navigationType:(UIWebViewNavigationType)navigationType
{

  if (navigationType == UIWebViewNavigationTypeLinkClicked )
	{
	  [self performSelectorInBackground:@selector(openURLinSafari:) withObject:[request URL] ];
		//Change to correct tab
		tfmContacts3AppDelegate *appDelegate = (tfmContacts3AppDelegate *)[[UIApplication sharedApplication] delegate] ;
		appDelegate.tabBarController.selectedIndex = TAB_IMPORT;
		appDelegate = nil;
		return NO;
	}
	else
	{
		return YES;
	}
}

- (void) openURLinSafari:(id)data
{
	NSURL *url = (NSURL *)data;
  [[UIApplication sharedApplication] openURL:url];

}

@end
