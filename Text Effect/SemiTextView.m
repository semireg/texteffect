//
//  SemiTextView.m
//  Text Effect
//
//  Created by Caylan Larson on 6/1/13.
//  Copyright (c) 2013 Caylan Larson. All rights reserved.
//

#import "SemiTextView.h"
#include <math.h>
#include <stdio.h>

@implementation SemiTextView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addObserver:self forKeyPath:@"imageToDraw" options:NSKeyValueObservingOptionNew context:nil];
        
        [[NSColorPanel sharedColorPanel] setShowsAlpha:YES];
    }

    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self setNeedsDisplay:YES];
}

- (NSImage*)blackSquareOfSize:(CGSize)size {
    NSImage *blackSquare = [[NSImage alloc] initWithSize:size];
    [blackSquare lockFocus];
    
    [[NSColor blackColor] setFill];
    CGContextFillRect([[NSGraphicsContext currentContext] graphicsPort], CGRectMake(0, 0, size.width, size.height));
    
    [blackSquare unlockFocus];
    return blackSquare;
}

- (CGImageRef)createMaskWithSize:(CGSize)size shape:(void (^)(void))block {
    NSImage *newMask = [[NSImage alloc] initWithSize:size];
    CGImageRef mask;
    
    CGContextSetShadow([[NSGraphicsContext currentContext] graphicsPort], CGSizeZero, 0.0);
    
    [newMask lockFocus];
    block();
    [newMask unlockFocus];

    struct CGImage *newMaskRef = [newMask CGImageForProposedRect:NULL context:[NSGraphicsContext currentContext] hints:nil];
    
    mask = CGImageMaskCreate(CGImageGetWidth(newMaskRef),
                             CGImageGetHeight(newMaskRef),
                             CGImageGetBitsPerComponent(newMaskRef),
                             CGImageGetBitsPerPixel(newMaskRef),
                             CGImageGetBytesPerRow(newMaskRef),
                             CGImageGetDataProvider(newMaskRef), NULL, false);
    return mask;
}


- (void)drawRect:(NSRect)rect
{
    if(self.imageToDraw)
    {
        [self.imageToDraw drawAtPoint:CGPointZero fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
        return;
    }

    float shadowY = [self.shadowDistance floatValue] * cos([self.shadowDirection intValue] * M_PI / 180.0);
    float shadowX = [self.shadowDistance floatValue] * sin([self.shadowDirection intValue] * M_PI / 180.0);
    
    float shadowYOuter = [self.shadowDistanceOuter floatValue] * cos([self.shadowDirectionOuter intValue] * M_PI / 180.0);
    float shadowXOuter = [self.shadowDistanceOuter floatValue] * sin([self.shadowDirectionOuter intValue] * M_PI / 180.0);
    
    NSString *text_ = self.inputString;
    
    CGPoint textLocation = CGPointMake(15,0);
    
    NSMutableParagraphStyle* textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    [textStyle setAlignment: NSLeftTextAlignment];
    NSFont* font = [NSFont fontWithName: @"Helvetica" size:120];
    
    NSDictionary* blackFontAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                         font, NSFontAttributeName,
                                         [NSColor blackColor], NSForegroundColorAttributeName,
                                         textStyle, NSParagraphStyleAttributeName, nil];
    
    NSDictionary* whiteFontAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                         font, NSFontAttributeName,
                                         [NSColor whiteColor], NSForegroundColorAttributeName,
                                         textStyle, NSParagraphStyleAttributeName, nil];
    
    NSDictionary* stringFontAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                        font, NSFontAttributeName,
                                        self.textColor, NSForegroundColorAttributeName,
                                        textStyle, NSParagraphStyleAttributeName, nil];
    
    
    // Create Initial Mask of White Text on Black Background
    CGImageRef mask = [self createMaskWithSize:rect.size shape:^{
        [[NSColor blackColor] setFill];
        CGContextFillRect([[NSGraphicsContext currentContext] graphicsPort], rect);
        [[NSColor whiteColor] setFill];
        [text_ drawAtPoint:textLocation withAttributes:whiteFontAttributes];
    }];
    
    //DEBUG - FIRST
    NSImage *maskImage = [[NSImage alloc] initWithCGImage:mask size:rect.size];
    self.first.imageToDraw = maskImage;
    
    NSImage *cutoutImage = [self blackSquareOfSize:rect.size];
    CGImageRef cutoutRawRef = [cutoutImage CGImageForProposedRect:NULL
                                                          context:[NSGraphicsContext currentContext]
                                                            hints:nil];

    CGImageRef cutoutRef = CGImageCreateWithMask(cutoutRawRef, mask);
    CGImageRelease(mask);
    
    NSImage *cutout = [[NSImage alloc] initWithCGImage:cutoutRef size:rect.size];
    
    CGImageRelease(cutoutRef);
    
    CGImageRef shadedMask = [self createMaskWithSize:rect.size shape:^{
        [[NSColor whiteColor] setFill];
        CGContextFillRect([[NSGraphicsContext currentContext] graphicsPort], rect);
        CGContextSetShadowWithColor([[NSGraphicsContext currentContext] graphicsPort],
                                    CGSizeMake(shadowX, shadowY),
                                    [self.shadowBlur floatValue],
                                    [self.shadowColor CGColor]);
        [cutout drawAtPoint:CGPointZero fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:0.9];
    }];
    
    //DEBUG - SECOND
    NSImage *shadedMaskImage = [[NSImage alloc] initWithCGImage:shadedMask size:rect.size];
    self.second.imageToDraw = shadedMaskImage;

    // create negative image
    NSImage *negativeImage = [[NSImage alloc] initWithSize:rect.size];
    [negativeImage lockFocus];
    [[NSColor blackColor] setFill];
    [text_ drawAtPoint:textLocation withAttributes:blackFontAttributes];
    [negativeImage unlockFocus];
    
    
    struct CGImage *negativeImageRef = [negativeImage CGImageForProposedRect:NULL
                                                                     context:[NSGraphicsContext
                                                                              currentContext]
                                                                       hints:nil];
    
    CGImageRef innerShadowRef = CGImageCreateWithMask(negativeImageRef, shadedMask);
    CGImageRelease(shadedMask);
    
    //DEBUG - THIRD
    NSImage *innerShadow = [[NSImage alloc] initWithCGImage:innerShadowRef size:rect.size];
    self.third.imageToDraw = innerShadow;
    
    CGImageRelease(innerShadowRef);
    
    CGContextSetShadowWithColor([[NSGraphicsContext currentContext] graphicsPort],
                                CGSizeMake(shadowXOuter, shadowYOuter),
                                [self.shadowBlurOuter floatValue],
                                [self.shadowColorOuter CGColor]);
    [text_ drawAtPoint:textLocation withAttributes:stringFontAttributes];
    CGContextSetShadow([[NSGraphicsContext currentContext] graphicsPort], CGSizeZero, 0.0);
    [text_ drawAtPoint:textLocation withAttributes:stringFontAttributes];
    
    //DEBUG - FOURTH
    [innerShadow drawAtPoint:CGPointZero fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:.8];
}

@end
