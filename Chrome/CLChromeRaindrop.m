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
    NSLog(@"[raindrop:chrome] error creating application");
		return nil;
	}
	
	// Get frontmost window
	ChromeWindow *frontmostWindow = nil;
	SBElementArray *windows = [chrome windows];
	if (windows == nil) {
    NSLog(@"[raindrop:chrome] error getting windows");
		return nil;
	}
  
  NSLog(@"[raindrop:chrome] chrome windows: %@ - %d", windows, windows.count);
	
	for (ChromeWindow *window in windows) {
    NSLog(@"[raindrop:chrome] window: %@", window);
		if (frontmostWindow == nil) {
			frontmostWindow = window;
		} else if (frontmostWindow.index > window.index) {
			frontmostWindow = window;
		}
	}
	
	if (frontmostWindow == nil) {
    NSLog(@"[raindrop:chrome] error, no frontmost window");
		return nil;
	}
	
	// Get active tab
	ChromeTab *tab = [frontmostWindow activeTab];
	if (tab == nil || tab.URL == nil) {
    NSLog(@"[raindrop:chrome] error getting active tab");
		return nil;
	}
	
  NSLog(@"[raindrop:chrome] using tab: %@ - %@", tab.title, tab.URL);
  
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
