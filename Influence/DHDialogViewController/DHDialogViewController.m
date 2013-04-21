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

@synthesize delegate, contentView, closeButton, animationEnabled, touchOusideToClose;

#pragma mark Initialization
- (id)initWithContentSize:(CGSize)size forFrame:(CGRect) rect delegate:(id)_delegate {
    self = [super init];
    if (self) {
        self.delegate = _delegate;
        [self customInitializationWithContentSize:size forFrame:rect];
    }
    return self;
}

- (void)customInitializationWithContentSize:(CGSize)size forFrame:(CGRect)rect
{
    // Init main view
    DHNoBubblingView *view = [[DHNoBubblingView alloc] initWithFrame:rect];
    self.view = view;
    view.delegate = self;
    
    self.view.layer.zPosition = 99999;
    self.view.contentMode = UIViewContentModeScaleAspectFill;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.view.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.8];
    self.view.hidden = YES;
    
    // Default behavior
    self.touchOusideToClose = YES;
    self.animationEnabled = YES;
    
    // Create content view
    CGFloat left, top;
    left = (self.view.frame.size.width - size.width)/2;
    // Status bar height (20) is considered by default
    top  = (self.view.frame.size.height - size.height)/2;
    
    // Styling contentView
    self.contentView = [[DHNoBubblingView alloc] initWithFrame:CGRectMake(left, top, size.width, size.height)];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 6.0;
    self.contentView.layer.shadowRadius = 10.0;
    self.contentView.layer.shadowColor = [[UIColor grayColor] CGColor];
    self.contentView.layer.shadowOpacity = 1;
    [self.view addSubview:self.contentView];
    
    
    self.pickerView = [[CPPickerView alloc] initWithFrame:CGRectMake(10, 40,self.contentView.frame.size.width-20, 40)];
    self.pickerView.backgroundColor = [UIColor whiteColor];
    self.pickerView.peekInset = UIEdgeInsetsMake(0, 60, 0, 60);
    self.pickerView.dataSource = self.delegate;
    self.pickerView.delegate = self.delegate;
    [self.pickerView reloadData];
    [self.contentView addSubview:self.pickerView];
    
    // Close button
    CGFloat bw = 30.0;
    self.closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.closeButton.frame = CGRectMake(bw, self.contentView.frame.size.height-bw-60, self.contentView.frame.size.width-bw*2, 60);
    self.closeButton.titleLabel.text = @"LOG";
    [self.closeButton addTarget:self action:@selector(hideAndLog) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.closeButton];
}

// Release all elements
- (void)viewDidUnload
{
    self.contentView = nil;
    self.closeButton = nil;
}

#pragma mark DHNoBubblingViewDelegate methods
- (void)didBeginTouchInsideView:(DHNoBubblingView *)view event:(UIEvent *)ev
{
    if (view == self.view) {
        _touchedBacground = YES;
    }
}
- (void)didEndTouchInsideView:(DHNoBubblingView *)view event:(UIEvent *)ev
{
    if (view == self.view && _touchedBacground) {
        if (self.touchOusideToClose) {
            [self hide];
        }
    }
}

#pragma mark Show/Hide methods
- (void)show:(BOOL)visibleFlag inContainer:(UIView*) container
{
    if (animationEnabled) {
        if (visibleFlag) {
            self.view.frame = container.frame;
            [container addSubview:self.view];
            self.contentView.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
            self.view.hidden = NO;
            [self.view setAlpha:0.1f];
            
            // Open animation
            [UIView animateWithDuration:0.3f
                                  delay:0.05f
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^ {
                                 self.contentView.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
                                 [self.view setAlpha:1.0f];
                             }
                             completion:^(BOOL completed) {
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
        } else {
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
    } else {
        self.view.hidden = !visibleFlag;
        self.contentView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    }
    if ([delegate respondsToSelector:@selector(dialog:didChangeVisibility:)]) {
        [delegate dialog:self didChangeVisibility:visibleFlag];
    }
}

- (void)hideAndLog
{
    [delegate log:self.pickerView.selectedItem withNote:@"" for:nil atTime:[NSDate date]];
    [self hide];
}


- (void)hide
{
    [self show:NO inContainer:nil];
}

@end
