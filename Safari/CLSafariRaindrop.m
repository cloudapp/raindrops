//
//  CLSafariRaindrop.m
//  Safari
//
//  Created by Nick Paulson on 2/10/11.
//  Copyright 2011 Linebreak. All rights reserved.
//

#import "CLSafariRaindrop.h"
#import "Safari.h"

@implementation CLSafariRaindrop

- (NSString *)pasteboardNameForTriggeredRaindrop {
    SafariApplication *safariApplication = [SBApplication applicationWithBundleIdentifier:@"com.apple.Safari"];
	
	if (safariApplication != nil) {
		
		SBElementArray *safariDocs = [safariApplication documents];
		
		if (safariDocs != nil && [safariDocs count] > 0) {
			
			NSString *docURL = (NSString *)[(SafariDocument *)[safariDocs objectAtIndex:0] URL];
			
			if ([docURL length] > 0) {
				NSString *docName = nil;
				
				SBElementArray *windows = [safariApplication windows];
				if ([windows count] > 0) {
					docName = [[windows objectAtIndex:0] name];
				}
				
				NSPasteboardItem *item = [[NSPasteboardItem alloc] init];
                [item setString:docName forType:@"public.url-name"];
                [item setString:docURL forType:(NSString *)kUTTypeURL];
                NSPasteboard *pasteboard = [NSPasteboard pasteboardWithUniqueName];
                [pasteboard writeObjects:[NSArray arrayWithObject:item]];
                [item release];
                return pasteboard.name;
			}
		}
	}
	return nil;
}

@end
