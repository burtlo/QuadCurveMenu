//
//  AGMedallionView.m
//  AGMedallionView
//
//  Created by Artur Grigor on 1/23/12.
//  Copyright (c) 2012 Artur Grigor. All rights reserved.
//  
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//  
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//  
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#import "AGMedallionView.h"

#define DEGREES_2_RADIANS(x) (0.0174532925 * (x))

@interface AGMedallionView (){
    CGGradientRef alphaGradient;
}

- (void)setup;

@end

@implementation AGMedallionView

#pragma mark - Properties

@synthesize image, highlightedImage;
@synthesize highlighted;
@synthesize borderColor, borderWidth, shadowColor, shadowOffset, shadowBlur;

@synthesize progressColor;
@synthesize progress;

#pragma mark - Property Setters

- (void)setImage:(UIImage *)aImage {
    
    if (image != aImage) {
        image = aImage;
        
        [self setNeedsDisplay];
    }
}

- (void)setBorderColor:(UIColor *)aBorderColor {
    if (borderColor != aBorderColor) {
        borderColor = aBorderColor;
        
        [self setNeedsDisplay];
    }
}

- (void)setBorderWidth:(CGFloat)aBorderWidth {
    if (borderWidth != aBorderWidth) {
        borderWidth = aBorderWidth;
        
        [self setNeedsDisplay];
    }
}

- (void)setShadowColor:(UIColor *)aShadowColor {
    if (shadowColor != aShadowColor) {
        shadowColor = aShadowColor;
        
        [self setNeedsDisplay];
    }
}

- (void)setShadowOffset:(CGSize)aShadowOffset {
    if (!CGSizeEqualToSize(shadowOffset, aShadowOffset)) {
        shadowOffset.width = aShadowOffset.width;
        shadowOffset.height = aShadowOffset.height;
        
        [self setNeedsDisplay];
    }
}

- (void)setShadowBlur:(CGFloat)aShadowBlur {
    if (shadowBlur != aShadowBlur) {
        shadowBlur = aShadowBlur;
        
        [self setNeedsDisplay];
    }
}

- (void)setProgress:(CGFloat)aProgress {
    
    if (progress != aProgress) {
        progress = aProgress;
        
        [self setNeedsDisplay];
    }
}

#pragma mark - Object Lifecycle

- (void)dealloc {
    // Release the alpha gradient
    CGGradientRelease(alphaGradient);
}

- (void)setup {
    alphaGradient = NULL;
    
    self.borderColor = [UIColor whiteColor];
    self.borderWidth = 5.f;
    self.shadowColor = [UIColor colorWithRed:0.25f green:0.25f blue:0.25f alpha:.75f];
    self.shadowOffset = CGSizeMake(0, 0);
    self.shadowBlur = 2.f;
    self.backgroundColor = [UIColor clearColor];
    self.progress = 0.0;
    self.progressColor = [UIColor grayColor];
}

- (id)init {
    self = [self initWithFrame:CGRectMake(0, 0, 128.f, 128.f)];
    return self;
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setup];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    
    return self;
}

#pragma mark - Drawing

- (CGGradientRef)alphaGradient
{
    if (NULL == alphaGradient) {
        CGFloat colors[6] = {1.f, 0.75f, 1.f, 0.f, 0.f, 0.f};
        CGFloat colorStops[3] = {1.f, 0.35f, 0.f};
        CGColorSpaceRef grayColorSpace = CGColorSpaceCreateDeviceGray();
        alphaGradient = CGGradientCreateWithColorComponents(grayColorSpace, colors, colorStops, 3);
        CGColorSpaceRelease(grayColorSpace);
    }
    
    return alphaGradient;
}

- (void)drawRect:(CGRect)rect
{
    // Image rect
    CGRect imageRect = CGRectMake((self.borderWidth), 
                                  (self.borderWidth) , 
                                  rect.size.width - (self.borderWidth * 2), 
                                  rect.size.height - (self.borderWidth * 2));
    
    // Start working with the mask
    CGColorSpaceRef maskColorSpaceRef = CGColorSpaceCreateDeviceGray();
    CGContextRef mainMaskContextRef = CGBitmapContextCreate(NULL,
                                                        rect.size.width, 
                                                        rect.size.height, 
                                                        8, 
                                                        rect.size.width, 
                                                        maskColorSpaceRef, 
                                                        0);
    CGContextRef shineMaskContextRef = CGBitmapContextCreate(NULL,
                                                             rect.size.width, 
                                                             rect.size.height, 
                                                             8, 
                                                             rect.size.width, 
                                                             maskColorSpaceRef, 
                                                             0);
    CGColorSpaceRelease(maskColorSpaceRef);
    CGContextSetFillColorWithColor(mainMaskContextRef, [UIColor blackColor].CGColor);
    CGContextSetFillColorWithColor(shineMaskContextRef, [UIColor blackColor].CGColor);
    CGContextFillRect(mainMaskContextRef, rect);
    CGContextFillRect(shineMaskContextRef, rect);
    CGContextSetFillColorWithColor(mainMaskContextRef, [UIColor whiteColor].CGColor);
    CGContextSetFillColorWithColor(shineMaskContextRef, [UIColor whiteColor].CGColor);
    
    // Create main mask shape
    CGContextMoveToPoint(mainMaskContextRef, 0, 0);
    CGContextAddEllipseInRect(mainMaskContextRef, imageRect);
    CGContextFillPath(mainMaskContextRef);
    // Create shine mask shape
    CGContextTranslateCTM(shineMaskContextRef, -(rect.size.width / 4), rect.size.height / 4 * 3);
    CGContextRotateCTM(shineMaskContextRef, -45.f);
    CGContextMoveToPoint(shineMaskContextRef, 0, 0);
    CGContextFillRect(shineMaskContextRef, CGRectMake(0, 
                                                      0, 
                                                      rect.size.width / 8 * 5, 
                                                      rect.size.height));
    
    CGImageRef mainMaskImageRef = CGBitmapContextCreateImage(mainMaskContextRef);
    CGImageRef shineMaskImageRef = CGBitmapContextCreateImage(shineMaskContextRef);
    CGContextRelease(mainMaskContextRef);
    CGContextRelease(shineMaskContextRef);
    // Done with mask context
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSaveGState(contextRef);
    
    UIImage *currentImage = (self.highlighted ? self.highlightedImage : self.image);
    
    CGImageRef imageRef = CGImageCreateWithMask(currentImage.CGImage, mainMaskImageRef);
    
    CGContextTranslateCTM(contextRef, 0, rect.size.height);
    CGContextScaleCTM(contextRef, 1.0, -1.0);
    
    CGContextSaveGState(contextRef);
    
    // Draw image
    CGContextDrawImage(contextRef, rect, imageRef);
    
    CGContextRestoreGState(contextRef);
    CGContextSaveGState(contextRef);
    
    // Clip to shine's mask
    CGContextClipToMask(contextRef, self.bounds, mainMaskImageRef);
    CGContextClipToMask(contextRef, self.bounds, shineMaskImageRef);
    CGContextSetBlendMode(contextRef, kCGBlendModeLighten);
    CGContextDrawLinearGradient(contextRef, [self alphaGradient], CGPointMake(0, 0), CGPointMake(0, self.bounds.size.height), 0);
    
    CGImageRelease(mainMaskImageRef);
    CGImageRelease(shineMaskImageRef);
    CGImageRelease(imageRef);
    // Done with image

    CGContextRestoreGState(contextRef);
    
    CGContextSetLineWidth(contextRef, self.borderWidth);
    CGContextSetStrokeColorWithColor(contextRef, self.borderColor.CGColor);
    CGContextMoveToPoint(contextRef, 0, 0);
    CGContextAddEllipseInRect(contextRef, imageRect);
    // Drop shadow
    CGContextSetShadowWithColor(contextRef, 
                                self.shadowOffset, 
                                self.shadowBlur, 
                                self.shadowColor.CGColor);
    CGContextStrokePath(contextRef);
    CGContextRestoreGState(contextRef);
    
    CGContextSaveGState(contextRef);
    
    // Progress Arc
    
    CGPoint centerPoint = CGPointMake(imageRect.origin.x + imageRect.size.width / 2,imageRect.origin.y + imageRect.size.height / 2);
    
    if (self.progress != 0.0f) {
        
        float radius = (imageRect.size.height / 2);
        float endAngle = DEGREES_2_RADIANS((self.progress*359.9)-90);
        float startAngle = DEGREES_2_RADIANS(270);
        
        CGMutablePathRef progressPath = CGPathCreateMutable();
        CGPathAddArc(progressPath, NULL, centerPoint.x, centerPoint.y, radius, startAngle, endAngle, NO);
        
        CGContextSetStrokeColorWithColor(contextRef, self.progressColor.CGColor);
        CGContextSetLineWidth(contextRef, 3.0);
        CGContextAddPath(contextRef, progressPath);
        CGContextStrokePath(contextRef);
        CGPathRelease(progressPath);
    }
    
    CGContextRestoreGState(contextRef);
}

@end
