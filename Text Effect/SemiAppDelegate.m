//
//  SemiAppDelegate.m
//  Text Effect
//
//  Created by Caylan Larson on 6/1/13.
//  Copyright (c) 2013 Caylan Larson. All rights reserved.
//

#import "SemiAppDelegate.h"
#import "SemiTextView.h"

@implementation SemiAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.final.first = self.first;
    self.final.second = self.second;
    self.final.third = self.third;
    
    // Probably not the best way to do this.
    
    // Inner
    [self addObserver:self forKeyPath:@"inputString" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self.final forKeyPath:@"inputString" options:NSKeyValueObservingOptionNew context:nil];
 
    [self addObserver:self forKeyPath:@"textColor" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self.final forKeyPath:@"textColor" options:NSKeyValueObservingOptionNew context:nil];
    
    [self addObserver:self forKeyPath:@"shadowDistance" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self.final forKeyPath:@"shadowDistance" options:NSKeyValueObservingOptionNew context:nil];
    
    [self addObserver:self forKeyPath:@"shadowDirection" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self.final forKeyPath:@"shadowDirection" options:NSKeyValueObservingOptionNew context:nil];
    
    [self addObserver:self forKeyPath:@"shadowBlur" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self.final forKeyPath:@"shadowBlur" options:NSKeyValueObservingOptionNew context:nil];
    
    [self addObserver:self forKeyPath:@"shadowColor" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self.final forKeyPath:@"shadowColor" options:NSKeyValueObservingOptionNew context:nil];
    
    // Outer
    [self addObserver:self forKeyPath:@"shadowDistanceOuter" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self.final forKeyPath:@"shadowDistanceOuter" options:NSKeyValueObservingOptionNew context:nil];
    
    [self addObserver:self forKeyPath:@"shadowDirectionOuter" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self.final forKeyPath:@"shadowDirectionOuter" options:NSKeyValueObservingOptionNew context:nil];
    
    [self addObserver:self forKeyPath:@"shadowBlurOuter" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self.final forKeyPath:@"shadowBlurOuter" options:NSKeyValueObservingOptionNew context:nil];
    
    [self addObserver:self forKeyPath:@"shadowColorOuter" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self.final forKeyPath:@"shadowColorOuter" options:NSKeyValueObservingOptionNew context:nil];
    
    self.inputString = @"Sample";
    self.textColor = [NSColor colorWithCalibratedRed:1.0 green:0 blue:0 alpha:0.5];
    
    self.shadowDistance = @5;
    self.shadowDirection = @135;
    self.shadowBlur = @4;
    self.shadowColor = [NSColor grayColor];

    self.shadowDistanceOuter = @2;
    self.shadowDirectionOuter = @135;
    self.shadowBlurOuter = @6;
    self.shadowColorOuter = [NSColor colorWithCalibratedWhite:0 alpha:0.7];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    self.final.inputString = self.inputString;
    self.final.textColor = self.textColor;
    
    self.final.shadowDistance = self.shadowDistance;
    self.final.shadowDirection = [NSNumber numberWithInt:[self.shadowDirection intValue]];  // Improper casting?  Defunct?
    self.final.shadowBlur = self.shadowBlur;
    self.final.shadowColor = self.shadowColor;
    
    self.final.shadowDistanceOuter = self.shadowDistanceOuter;
    self.final.shadowDirectionOuter = [NSNumber numberWithInt:[self.shadowDirectionOuter intValue]];  // Improper casting?  Defunct?
    self.final.shadowBlurOuter = self.shadowBlurOuter;
    self.final.shadowColorOuter = self.shadowColorOuter;

}

@end