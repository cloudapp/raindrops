//
//  CLFirefoxRaindrop.m
//  Firefox
//
//  Created by Nick Paulson on 2/27/11.
//  Copyright 2011 Linebreak. All rights reserved.
//

#import "CLFirefoxRaindrop.h"
#import "NSPasteboard+NPStateRestoration.h"

@implementation CLFirefoxRaindrop

- (NSString *)pasteboardNameForTriggeredRaindrop {
    
    NSInteger origCount = [[NSPasteboard generalPasteboard] changeCount];
	
    [[NSPasteboard generalPasteboard] savePasteboardState];
    
	ProcessSerialNumber psn;
	GetFrontProcess(&psn);
	CGEventRef lDown = CGEventCreateKeyboardEvent(NULL, (CGKeyCode)37, true);
	CGEventRef lUp = CGEventCreateKeyboardEvent(NULL, (CGKeyCode)37, false);
	
	CGEventSetFlags(lDown, kCGEventFlagMaskCommand);
	CGEventPostToPSN(&psn, lDown);
	CGEventPostToPSN(&psn, lUp);
	
	CFRelease(lDown);
	CFRelease(lUp);
	
	[NSThread sleepForTimeInterval:0.50];
	
	CGEventRef cDown = CGEventCreateKeyboardEvent(NULL, (CGKeyCode)8, true);
	CGEventRef cUp = CGEventCreateKeyboardEvent(NULL, (CGKeyCode)8, false);
	
	CGEventSetFlags(cDown, kCGEventFlagMaskCommand);
	CGEventPostToPSN(&psn, cDown);
	CGEventPostToPSN(&psn, cUp);
	
	CFRelease(cDown);
	CFRelease(cUp);
	
	[NSThread sleepForTimeInterval:0.30];
	
	NSInteger newCount = [[NSPasteboard generalPasteboard] changeCount];
    
	if (newCount == (origCount + 1)) {
        NSArray *pbTypes = [[NSPasteboard generalPasteboard] types];
        if ([pbTypes containsObject:NSStringPboardType]) {
            NSString *urlString = [[NSPasteboard generalPasteboard] stringForType:NSStringPboardType];
            
            NSPasteboardItem *item = [[[NSPasteboardItem alloc] init] autorelease];
            [item setString:urlString forType:(NSString *)kUTTypeURL];
            
            NSPasteboard *pasteboard = [NSPasteboard pasteboardWithUniqueName];
            if ([pasteboard writeObjects:[NSArray arrayWithObject:item]]) {
                [[NSPasteboard generalPasteboard] restorePasteboardState];
                return pasteboard.name;
            }
        }
    }
    [[NSPasteboard generalPasteboard] restorePasteboardState];
    return nil;
}

@end
