//
//  ViewController.m
//  Influence
//
//  Created by Michal Mandrysz on 27/04/2013.
//  Copyright (c) 2013 Michal Mandrysz. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
@interface ViewController ()

@end

@implementation ViewController



-(void) addNew
{
	[(((self.appDelegate.controllerStack.count>0)?((MasterViewController*)[self.appDelegate.controllerStack peek]):self.appDelegate.mvc)) createEvent:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
	{
//		UIButton* b = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//		[b setTitle:@"ADD NEW EVENT" forState:UIControlStateNormal];
//		[b addTarget:self action:@selector(addNew) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:b];
        
        UINavigationBar* bar = [[UINavigationBar alloc] init];
		bar.frame = CGRectMake(0, 0, 320, 30);
		
		UIBarButtonItem* b = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNew)];
        UINavigationItem* item = [[UINavigationItem alloc] init];
        item.rightBarButtonItem = b;
        bar.items = @[item];
        
        BreadcrumbView* title = [[BreadcrumbView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
//        title.backgroundColor = [UIColor redColor];
        item.titleView = title;
        self.breadcrumb = title;
        self.breadcrumb.delegate = self;
        
		[self.view addSubview:bar];
    }
    return self;
}

-(void) removeOldViewControllers
{
	CGFloat xOffset = self.scrollView.contentOffset.x;
	while (xOffset /320.0 < [self.appDelegate.controllerStack count])
	{
		[((MasterViewController*)[self.appDelegate.controllerStack pop]).view removeFromSuperview];
		[self.appDelegate.parentStack pop];
		NSLog(@"POP!");
	}
    
    [self.breadcrumb showEventStack:self.appDelegate.parentStack];
}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	[self removeOldViewControllers];
}
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	[self removeOldViewControllers];
        
	Event* object;
	if ([self.appDelegate.controllerStack count]>0)
    	object = [self.appDelegate.controllerStack[self.appDelegate.controllerStack.count-1] selectedEvent:scrollView.panGestureRecognizer];
	else
	{
		object = [self.appDelegate.mvc selectedEvent:scrollView.panGestureRecognizer];
		NSLog(@"LESS");
	}
	
	
	NSLog(@"Selected event is %@", object.name);
	
    if (object == nil) return;
    
	MasterViewController * mvc  = [[MasterViewController alloc] init];
	
    [self.appDelegate.parentStack push:object];
	[self.appDelegate.controllerStack push:mvc];

    [self.breadcrumb showEventStack:self.appDelegate.parentStack];
    
//	NSLog(@"%@", self.appDelegate.parentStack);
//	NSLog(@"Parent stack contains %@", [self.appDelegate.parentStack peek]);

	mvc.view.frame = CGRectMake(320*self.appDelegate.controllerStack.count,0, 320,self.appDelegate.scrollView.frame.size.height);
	
	mvc.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    mvc.title = object.name;
    mvc.appDelegate = self.appDelegate;
	if (self.scrollView.contentSize.width < 320*(self.appDelegate.controllerStack.count+1))
		self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width*2, self.scrollView.contentSize.height*2);
	
	[self.scrollView addSubview:mvc.view];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self removeOldViewControllers];
}

-(void)scrollToPage:(int)page
{
    CGRect scrollFrame = self.scrollView.frame;
    CGRect targetRect = CGRectMake(page * scrollFrame.size.width, 0, scrollFrame.size.width, 1);
    [self.scrollView scrollRectToVisible:targetRect animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
