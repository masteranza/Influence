//
//  BreadcrumbView.m
//  Influence
//
//  Created by Blazej Stanek on 27.04.2013.
//  Copyright (c) 2013 Michal Mandrysz. All rights reserved.
//

#import "BreadcrumbView.h"

static const int TITLE_SPACING = 10;

@interface BreadcrumbView ()

@property (nonatomic, strong) NSMutableArray* titleViews;
@property (nonatomic, strong) UIScrollView* scroll;

@end

@implementation BreadcrumbView

- (id)init
{
    self = [super init];
    if (self) {
        [self initStuff];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initStuff];
    }
    return self;
}

-(void)initStuff
{
    self.titleViews = [NSMutableArray array];
    
    self.scroll = [UIScrollView new];
    _scroll.showsHorizontalScrollIndicator = _scroll.showsVerticalScrollIndicator = NO;
    [self addSubview:_scroll];
}

-(void)layoutSubviews
{
    CGRect frame = self.frame;
    frame.origin = CGPointZero;
    _scroll.frame = frame;
}

-(void)showEventStack:(NSArray*)parentStack
{
    NSMutableArray* titles = [NSMutableArray array];
    [titles addObject:@"Root"];
    
    for (int i = 0; i < [parentStack count]; i++)
    {
        Event* event = parentStack[i];
        [titles addObject:event.name];
    }

    NSMutableArray* toRemove = [NSMutableArray array];
    [UIView animateWithDuration:0.25f animations:^{
        int titleViewCount = [_titleViews count];
        for (int i = [titles count]; i < titleViewCount; i++)
        {
            UIView* title = [_titleViews lastObject];
//            [title removeFromSuperview];
            [_titleViews removeLastObject];
            [toRemove addObject:title];
            title.alpha = 0;
        }

    } completion:^(BOOL finished) {
        for (UIView* view in toRemove) {
            [view removeFromSuperview];
        }
    }];
    
    NSMutableArray* added = [NSMutableArray array];
    for (int i = [_titleViews count]; i < [titles count]; i++)
    {
        UILabel* title = [UILabel new];
        title.backgroundColor = [UIColor clearColor];
        title.textColor = [UIColor whiteColor];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToPage:)];
        [title addGestureRecognizer:tap];
        title.userInteractionEnabled = YES;
        [_scroll addSubview:title];
        [_titleViews addObject:title];
        title.alpha = 0;
        [added addObject:title];
    }
    [UIView animateWithDuration:0.25f animations:^{
        for (UIView* view in added) {
            view.alpha = 1;
        }
        
    } completion:^(BOOL finished) {

    }];
    
    for (int i = 0; i < [_titleViews count]; i++)
    {
        UILabel* title = _titleViews[i];
        title.text = titles[i];
    }
    
    CGPoint savedPosition = _scroll.contentOffset;
    [self updatePositions];
    [self showLastItem: savedPosition];
}

-(void)updatePositions
{
    CGRect scrollFrame = _scroll.frame;
    CGPoint origin = CGPointZero;
    
    for (int i = 0; i < [_titleViews count]; i++)
    {
        UILabel* title = _titleViews[i];
        CGSize titleSize = [title.text sizeWithFont:title.font];
        title.frame = CGRectMake(origin.x, origin.y, titleSize.width + TITLE_SPACING, scrollFrame.size.height);
        origin.x += titleSize.width + TITLE_SPACING;
    }
    
    _scroll.contentSize = CGSizeMake(origin.x, scrollFrame.size.height);
}

-(void)showLastItem:(CGPoint)savedPosition
{
    CGPoint end = CGPointZero;
    
    for (int i = 0; i < [_titleViews count]; i++)
    {
        UILabel* title = _titleViews[i];
        CGRect titleFrame = title.frame;
        end.x = fmaxf(end.x, titleFrame.origin.x + titleFrame.size.width);
    }
    
    _scroll.contentOffset = savedPosition;
    [UIView animateWithDuration:0.25f animations:^{
        _scroll.contentOffset = CGPointMake(fmaxf(end.x - _scroll.frame.size.width, 0), 0);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)goToPage:(UIGestureRecognizer*)tap
{
    id sender = tap.view;
    for (int i = 0; i < [_titleViews count]; i++)
    {
        UILabel* title = _titleViews[i];
        if (title == sender)
        {
            [self.delegate scrollToPage:i];
        }
    }
}

@end
