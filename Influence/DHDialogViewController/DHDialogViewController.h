/**
 Simple Popup Dialog Controller
 
 Copyright (c) 2012 Doba Duc
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

 */

#import <UIKit/UIKit.h>
#import "CPPickerView.h"
//------------------------------------------------------
// DHNoBubblingViewDelegate
//------------------------------------------------------

// Simple custom view to prevent default event bubbling
@class DHNoBubblingView;
@protocol DHNoBubblingViewDeleage <NSObject>
- (void)didBeginTouchInsideView:(DHNoBubblingView*)view event:(UIEvent*)ev;
- (void)didEndTouchInsideView:(DHNoBubblingView*)view event:(UIEvent*)ev;
@end

@interface DHNoBubblingView : UIView
@property (nonatomic) id<DHNoBubblingViewDeleage> delegate;
@end

//------------------------------------------------------
// DHDialogViewController
//------------------------------------------------------
@class DHDialogViewController;
@protocol DHDialogViewControllerDelegate <NSObject>
- (void)dialog:(DHDialogViewController*)dialog didChangeVisibility:(BOOL)visibleFlag;
- (void)presentDatetimePicker;
- (void)hideDatetimePicker;
@end


@interface DHDialogViewController : UIViewController<DHNoBubblingViewDeleage, UITextViewDelegate> {
    BOOL _touchedBackground;
	NSDateFormatter *dateFormatter;
	BOOL visible;
}

@property BOOL touchOusideToClose;
@property (strong, nonatomic) UIButton* datetimeButton;
@property (strong, nonatomic) UIView * contentView;
@property (strong, nonatomic) UIButton * logButton;
@property (nonatomic) id<DHDialogViewControllerDelegate, CPPickerViewDelegate, CPPickerViewDataSource> delegate;
@property (strong, nonatomic) CPPickerView* pickerView;
@property (strong, nonatomic) UITextView* textView;

- (id)initWithContentSize:(CGSize)size forFrame:(CGRect)rect delegate:(id)delegate;

- (void)show:(BOOL)visibleFlag inContainer:(UIView*) container;
- (void)hide;
- (BOOL)isVisible;
- (void)presentDatatimePicker;
- (void)dateChanged:(UIDatePicker*)datetimePicker;
- (void)loadContentFromView:(UIView*)view withFrame:(CGRect)frame;
- (void)loadContentFromURL:(NSString*)url withFrame:(CGRect)frame;
@end
