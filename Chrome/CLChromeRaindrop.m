//
//  CLChromeRaindrop.m
//  Chrome
//
//  Created by Matthias Plappert on 20.02.11.
//  Copyright 2011 phaps. All rights reserved.
//

#import "CLChromeRaindrop.h"
#import "Chrome.h"


@implementation CLChromeRaindrop

- (NSString *)pasteboardNameForTriggeredRaindrop
{
    ChromeApplication *chrome = [SBApplication applicationWithBundleIdentifier:@"com.google.Chrome"];
	if (chrome == nil) {
		return nil;
	}
	
	// Get frontmost window
	ChromeWindow *frontmostWindow = nil;
	SBElementArray *windows = [chrome windows];
	if (windows == nil) {
		return nil;
	}
	
	for (ChromeWindow *window in windows) {
		if (frontmostWindow == nil) {
			frontmostWindow = window;
		} else if (frontmostWindow.index > window.index) {
			frontmostWindow = window;
		}
	}
	
	if (frontmostWindow == nil) {
		return nil;
	}
	
	// Get active tab
	ChromeTab *tab = [frontmostWindow activeTab];
	if (tab == nil || tab.URL == nil) {
		return nil;
	}
	
	// Write to pasteboard
	NSPasteboardItem *item = [[NSPasteboardItem alloc] init];
	[item setString:tab.title != nil ? tab.title : tab.URL forType:@"public.url-name"];
	[item setString:tab.URL forType:(NSString *)kUTTypeURL];
	NSPasteboard *pasteboard = [NSPasteboard pasteboardWithUniqueName];
	[pasteboard writeObjects:[NSArray arrayWithObject:item]];
	[item release];
	
	return pasteboard.name;
}

@end
