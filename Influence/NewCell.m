//
//  NewCell.m
//  Influence
//
//  Created by Michal Mandrysz on 17/03/2013.
//  Copyright (c) 2013 Michal Mandrysz. All rights reserved.
//

#import "NewCell.h"

@implementation NewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        UITextField *txtField=[[UITextField alloc]initWithFrame:CGRectMake(5, 5, self.frame.size.width-10, self.frame.size.height-10)];

        txtField.autoresizesSubviews=YES;
//        txtField.layer.cornerRadius=10.0;
        [txtField setBorderStyle:UITextBorderStyleLine];
        [txtField setPlaceholder:@"Type name here"];
        [self.contentView addSubview:txtField];
        txtField.delegate = self;
        [txtField becomeFirstResponder];
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
