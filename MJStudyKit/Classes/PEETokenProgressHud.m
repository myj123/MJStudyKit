//
//  PEETokenProgressHud.m
//  EToken
//
//  Created by Relly on 2018/4/11.
//  Copyright © 2018年 Relly. All rights reserved.
//

#import "PEETokenProgressHud.h"

static const CGFloat kPadding = 4.0f;
static const CGFloat kLabelFontSize = 16.0f;
static const CGFloat kmargin = 20.0f;

@interface PEETokenProgressHud()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailsLabel;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, assign) CGSize showZoneSize;

@end

@implementation PEETokenProgressHud

+ (PEETokenProgressHud *) CHProgressViewHUDWithTitle:(NSString *)titleString toView:(UIView *)view
{
    PEETokenProgressHud *chProgressView = [[PEETokenProgressHud alloc] initWithTitle:titleString andFrame:view.bounds];
    
    chProgressView.backgroundColor = [UIColor clearColor];
    
    [view addSubview:chProgressView];
    
    [view bringSubviewToFront:chProgressView];
    
    return chProgressView;
}

- (id)initWithTitle:(NSString *)titleString andFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.yOffset = 0.0f;
        self.xOffset = 0.0f;
        
        [self installLabels:titleString];
        
        [self installIndicators];
    }
    return self;
}

- (void)installLabels:(NSString *)titleString{
    
    _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _titleLabel.adjustsFontSizeToFitWidth = NO;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.opaque = NO;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:kLabelFontSize];
    _titleLabel.text = titleString;
    [self addSubview:_titleLabel];
    
}

- (void)installIndicators {
    
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [_indicator startAnimating];
    [self addSubview:_indicator];
    
}
- (void)layoutSubviews {
    
    UIView *parent = self.superview;
    if (parent) {
        self.frame = parent.bounds;
    }
    CGRect bounds = self.bounds;
    
    CGFloat maxWidth = bounds.size.width - 4 * kmargin;
    
    CGSize totalSize = CGSizeZero;
    
    CGRect indicatorFrame = _indicator.bounds;
    
    indicatorFrame.size.width = MIN(indicatorFrame.size.width, maxWidth);
    
    totalSize.width = MAX(totalSize.width, indicatorFrame.size.width);
    
    totalSize.height += indicatorFrame.size.height;
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineBreakMode:NSLineBreakByCharWrapping];
    
    NSDictionary *_titleLabelAttributes = @{ NSFontAttributeName : _titleLabel.font, NSParagraphStyleAttributeName : style };
    
    CGSize labelSize = [_titleLabel.text sizeWithAttributes:_titleLabelAttributes];
    
    labelSize.width = MIN(labelSize.width, maxWidth);
    
    totalSize.width = MAX(totalSize.width, labelSize.width);
    
    totalSize.height += labelSize.height;
    
    if (labelSize.height > 0.f && indicatorFrame.size.height > 0.f) {
        totalSize.height += kPadding;
    }
    
    CGFloat remainingHeight = bounds.size.height - totalSize.height - kPadding - 4 * kmargin;
    
    CGSize maxSize = CGSizeMake(maxWidth, remainingHeight);
    
    NSStringDrawingOptions opts = NSStringDrawingUsesLineFragmentOrigin |
    
    NSStringDrawingUsesFontLeading;
    
    NSDictionary *_detailsLabelAttributes = @{NSParagraphStyleAttributeName : style };
    
    CGRect detailsLabelRect = [_detailsLabel.text boundingRectWithSize:maxSize options:opts attributes:_detailsLabelAttributes context:nil];
    
    CGSize detailsLabelSize = detailsLabelRect.size;
    
    totalSize.width = MAX(totalSize.width, detailsLabelSize.width);
    
    totalSize.height += detailsLabelSize.height;
    
    if (detailsLabelSize.height > 0.f && (indicatorFrame.size.height > 0.f || labelSize.height > 0.f)) {
        totalSize.height += kPadding;
    }
    
    totalSize.width += 2 * kmargin;
    
    totalSize.height += 2 * kmargin;
    
    CGFloat yPos = roundf(((bounds.size.height - totalSize.height) / 2)) + kmargin + self.yOffset;
    
    CGFloat xPos = self.xOffset;
    
    indicatorFrame.origin.y = yPos;
    
    indicatorFrame.origin.x = roundf((bounds.size.width - indicatorFrame.size.width) / 2) + xPos;
    
    _indicator.frame = indicatorFrame;
    
    yPos += indicatorFrame.size.height;
    
    if (labelSize.height > 0.f && indicatorFrame.size.height > 0.f) {
        yPos += kPadding;
    }
    CGRect labelFrame;
    labelFrame.origin.y = yPos;
    labelFrame.origin.x = roundf((bounds.size.width - labelSize.width) / 2) + xPos;
    labelFrame.size = labelSize;
    _titleLabel.frame = labelFrame;
    yPos += labelFrame.size.height;
    
    if (detailsLabelSize.height > 0.f && (indicatorFrame.size.height > 0.f || labelSize.height > 0.f)) {
        yPos += kPadding;
    }
    CGRect detailsLabelFrame;
    detailsLabelFrame.origin.y = yPos;
    detailsLabelFrame.origin.x = roundf((bounds.size.width - detailsLabelSize.width) / 2) + xPos;
    detailsLabelFrame.size = detailsLabelSize;
    _detailsLabel.frame = detailsLabelFrame;
    
    self.showZoneSize = totalSize;
}

- (void) show
{
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    
    CGRect allRect = self.bounds;
    CGRect boxRect = CGRectMake(roundf((allRect.size.width - self.showZoneSize.width) / 2) + self.xOffset,
                                roundf((allRect.size.height - self.showZoneSize.height) / 2) + self.yOffset, self.showZoneSize.width, self.showZoneSize.height);
    float radius = 10.0f;
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, CGRectGetMinX(boxRect) + radius, CGRectGetMinY(boxRect));
    CGContextAddArc(context, CGRectGetMaxX(boxRect) - radius, CGRectGetMinY(boxRect) + radius, radius, 3 * (float)M_PI / 2, 0, 0);
    CGContextAddArc(context, CGRectGetMaxX(boxRect) - radius, CGRectGetMaxY(boxRect) - radius, radius, 0, (float)M_PI / 2, 0);
    CGContextAddArc(context, CGRectGetMinX(boxRect) + radius, CGRectGetMaxY(boxRect) - radius, radius, (float)M_PI / 2, (float)M_PI, 0);
    CGContextAddArc(context, CGRectGetMinX(boxRect) + radius, CGRectGetMinY(boxRect) + radius, radius, (float)M_PI, 3 * (float)M_PI / 2, 0);
    CGContextClosePath(context);
    CGContextFillPath(context);
    
    UIGraphicsPopContext();
}

- (void) hide
{
    [_indicator stopAnimating];
    [self removeFromSuperview];
}


@end
