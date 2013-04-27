/**
 Simple Popup Dialog Controller
 
 Copyright (c) 2012 Doba Duc
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

#import "DHDialogViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface DHDialogViewController ()

@end

@implementation DHNoBubblingView
@synthesize delegate;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([delegate respondsToSelector:@selector(didBeginTouchInsideView:event:)]) {
        [delegate didBeginTouchInsideView:self event:event];
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([delegate respondsToSelector:@selector(didEndTouchInsideView:event:)]) {
        [delegate didEndTouchInsideView:self event:event];
    }
}
@end

@implementation DHDialogViewController

@synthesize delegate, contentView, logButton, touchOusideToClose, textView, datetimeButton;

#pragma mark Initialization
- (id)initWithContentSize:(CGSize)size forFrame:(CGRect) rect delegate:(id)_delegate {
    self = [super init];
    if (self) {
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
		[dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        self.delegate = _delegate;
        [self customInitializationWithContentSize:size forFrame:rect];
    }
    return self;
}
-(void) hideAll
{
	[self.view endEditing:YES];
//	[delegate.controller.view endEditing:YES];
	[delegate hideDatetimePicker];
}
- (void)customInitializationWithContentSize:(CGSize)size forFrame:(CGRect)rect
{
	NSLog(@"Y: %d", (int)rect.origin.y);
    DHNoBubblingView *view = [[DHNoBubblingView alloc] initWithFrame:rect];
//	view.exclusiveTouch = YES;
    self.view = view;
    view.delegate = self;
   	 
    self.view.layer.zPosition = 99998;
    self.view.contentMode = UIViewContentModeScaleAspectFill;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.view.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.8];
    self.view.hidden = YES;
    
    // Default behavior
    self.touchOusideToClose = YES;

    
    // Create content view
    CGFloat left, top;
    left = (self.view.frame.size.width - size.width)/2;
    // Status bar height (20) is considered by default
    top  = (self.view.frame.size.height - size.height)/2-20;
    
    // Styling contentView
    self.contentView = [[DHNoBubblingView alloc] initWithFrame:CGRectMake(left, top, size.width, size.height)];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 6.0;
    self.contentView.layer.shadowRadius = 10.0;
    self.contentView.layer.shadowColor = [[UIColor grayColor] CGColor];
    self.contentView.layer.shadowOpacity = 1;
    [self.view addSubview:self.contentView];
    
    CGFloat bw = 30.0;
	
	self.datetimeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.datetimeButton.frame = CGRectMake(0, 0, self.contentView.frame.size.width, 40);
	[self.datetimeButton addTarget:self action:@selector(presentDatatimePicker) forControlEvents:UIControlEventTouchUpInside];
	[self dateChanged:nil];
	[self.contentView addSubview:self.datetimeButton];
	
    self.pickerView = [[CPPickerView alloc] initWithFrame:CGRectMake(bw, 60,self.contentView.frame.size.width-bw*2, 50)];
    self.pickerView.backgroundColor = [UIColor whiteColor];
    self.pickerView.peekInset = UIEdgeInsetsMake(0, 60, 0, 60);
    self.pickerView.dataSource = self.delegate;
    self.pickerView.delegate = self.delegate;
    [self.pickerView reloadData];
    [self.contentView addSubview:self.pickerView];
    
	self.textView = [[UITextView alloc] initWithFrame:CGRectMake(bw, self.contentView.frame.size.height-180, self.contentView.frame.size.width-bw*2, 60)];
	self.textView.backgroundColor = [UIColor grayColor];
	self.textView.delegate  =self;
	[self.contentView addSubview:self.textView];

    self.logButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.logButton.frame = CGRectMake(bw, self.contentView.frame.size.height-bw-60, self.contentView.frame.size.width-bw*2, 60);
	[self.logButton setTitle:@"LOG" forState:UIControlStateNormal];
	[self.logButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.logButton addTarget:self action:@selector(hideAndLog) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.logButton];
	UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAll)];
	[self.contentView addGestureRecognizer:tap];
}

// Release all elements
- (void)viewDidUnload
{
    self.contentView = nil;
    self.logButton = nil;
	self.pickerView = nil;
	self.textView = nil;
	self.datetimeButton = nil;
}

- (void)dateChanged:(UIDatePicker*)datetimePicker
{

	NSString* t= [dateFormatter stringFromDate:datetimePicker?[datetimePicker date]:[NSDate date]];
	[self.datetimeButton setTitle:t forState:UIControlStateNormal];
}

- (void)presentDatatimePicker
{
	[delegate presentDatetimePicker];
}
#pragma mark TextViewDelegate methods
-(void) textViewDidBeginEditing:(UITextView *)textView
{
	
}
-(void) textViewDidEndEditing:(UITextView *)textView
{
	[self.textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)txtView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [txtView resignFirstResponder];
    }
    return YES;
}

#pragma mark DHNoBubblingViewDelegate methods
- (void)didBeginTouchInsideView:(DHNoBubblingView *)view event:(UIEvent *)ev
{
    if (view == self.view) {
        _touchedBackground = YES;
    }
}
- (void)didEndTouchInsideView:(DHNoBubblingView *)view event:(UIEvent *)ev
{
    if (view == self.view && _touchedBackground) {
        if (self.touchOusideToClose) {
            [self hide];
        }
    }
}
- (BOOL)isVisible
{
	return visible;
}
#pragma mark Show/Hide methods
- (void)show:(BOOL)visibleFlag inContainer:(UIView*) container
{
//	
	NSLog(@"%@", container);
	if (visibleFlag)
	{
		self.view.userInteractionEnabled = YES;
		self.view.frame =  CGRectMake(0, 0, 320, container.frame.size.height);
		[container addSubview:self.view];
		self.contentView.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
		self.view.hidden = NO;
		[self.view setAlpha:0.1f];
		
		// Open animation
		[UIView animateWithDuration:0.3f
							  delay:0.05f
							options:UIViewAnimationOptionCurveEaseInOut
						 animations:^
						{
							 self.contentView.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
							 [self.view setAlpha:1.0f];
						 }
						 completion:^(BOOL completed)
						{
							 if (completed) {
								 // Shrink animation
								 [UIView animateWithDuration:0.1f
													   delay:0
													 options:UIViewAnimationOptionCurveEaseInOut
												  animations:^ {
													  self.contentView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
												  }
												  completion:nil];
							 }
						 }];
	}
	else
	{
		[container removeFromSuperview];
		// Close animation 
		[UIView animateWithDuration:0.3f
							  delay:0.05f
							options:UIViewAnimationOptionCurveEaseInOut
						 animations:^ {
							 self.contentView.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
						 }
						 completion:^(BOOL completed) {
							 if (completed) {
								 self.view.hidden = completed;
							 }
						 }];
	}
	visible = visibleFlag;
	[delegate dialog:self didChangeVisibility:visibleFlag];
}

- (void)hideAndLog
{
    [delegate log:self.pickerView.selectedItem withNote:self.textView.text];
    [self hide];
}

- (void)hide
{
    [self show:NO inContainer:nil];
}

@end
