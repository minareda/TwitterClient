//
//  MEExpandableHeaderView.m
//  Expandable Header View
//
//  Created by Pablo Romero on 6/12/14.
//  Copyright (c) 2014 Microeditionbiz. All rights reserved.
//

#import "MEExpandableHeaderView.h"
#import "UIImage+ImageEffects.h"
#import <QuartzCore/QuartzCore.h>

@interface MEExpandableHeaderView()<UIScrollViewDelegate>

@property(nonatomic, strong) UIImage *originalBackgroundImage;
@property(nonatomic, assign) CGPoint previousContentOffset;
@property(nonatomic, assign) CGFloat originalHeight;

@property(nonatomic, strong, readwrite) UIImageView *backgroundImageView;

@end

@implementation MEExpandableHeaderView

#pragma mark - Init

- (void)commonInit
{
    _originalHeight = self.frame.size.height;
    _previousContentOffset = CGPointZero;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self commonInit];
}

#pragma mark - Resize

- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - Setup

- (void)setBackgroundImage:(UIImage*)backgroundImage
{
    assert(backgroundImage == nil || [backgroundImage isKindOfClass:[UIImage class]]);
    
    _backgroundImage = backgroundImage;
    _originalBackgroundImage = backgroundImage;
    
    if (backgroundImage != nil &&
        self.backgroundImageView == nil)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        imageView.clipsToBounds = YES;
        
        imageView.autoresizingMask =
        UIViewAutoresizingFlexibleHeight |
        UIViewAutoresizingFlexibleWidth;
        
        [self insertSubview:imageView atIndex:0];
        
        self.backgroundImageView = imageView;
    }
    
    self.backgroundImageView.image = backgroundImage;
}

#pragma mark - Public

- (void)offsetDidUpdate:(CGPoint)newOffset
{
    if (newOffset.y <= 0)
    {
        CGAffineTransform translate = CGAffineTransformMakeTranslation(0, newOffset.y / 2.0);
        
        CGFloat scaleFactor = (self.originalHeight - newOffset.y) / self.originalHeight;
        
        CGAffineTransform translateAndZoom = CGAffineTransformScale(translate, scaleFactor, scaleFactor);
        
        float radius = -newOffset.y / 40.0;
        self.backgroundImageView.image = [self.originalBackgroundImage applyBlurWithRadius:radius
                                                                                 tintColor:nil
                                                                     saturationDeltaFactor:1.0
                                                                                 maskImage:nil];
        self.backgroundImageView.transform = translateAndZoom;
    }
    
    self.previousContentOffset = newOffset;
}

@end
