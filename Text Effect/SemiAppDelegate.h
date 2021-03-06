//
//  SemiAppDelegate.h
//  Text Effect
//
//  Created by Caylan Larson on 6/1/13.
//  Copyright (c) 2013 Caylan Larson. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class SemiTextView;

@interface SemiAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property NSString *inputString;
@property NSColor *textColor;

@property NSNumber *shadowDistance;
@property NSNumber *shadowDirection;
@property NSNumber *shadowBlur;
@property NSColor *shadowColor;

@property NSNumber *shadowDistanceOuter;
@property NSNumber *shadowDirectionOuter;
@property NSNumber *shadowBlurOuter;
@property NSColor *shadowColorOuter;

@property IBOutlet SemiTextView *first;
@property IBOutlet SemiTextView *second;
@property IBOutlet SemiTextView *third;
@property IBOutlet SemiTextView *final;

@property IBOutlet NSTextField *inputField;

@end
