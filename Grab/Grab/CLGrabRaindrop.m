//
//  CLGrabRaindrop.m
//  Grab
//
//  Created by Nick Paulson on 3/30/11.
//  Copyright 2011 Linebreak. All rights reserved.
//

#import "CLGrabRaindrop.h"
#import "NSPasteboard+NPStateRestoration.h"

@implementation CLGrabRaindrop

- (NSString *)pasteboardNameForTriggeredRaindrop
{
    NSData *imageData = nil;
    [[NSPasteboard generalPasteboard] savePasteboardState];
    {
        NSInteger origCount = [[NSPasteboard generalPasteboard] changeCount];
        
        CGEventRef cDown = CGEventCreateKeyboardEvent(NULL, (CGKeyCode)8, true);
        CGEventSetFlags(cDown, kCGEventFlagMaskCommand);
        CGEventPost(kCGSessionEventTap, cDown);
        
        CGEventRef cUp = CGEventCreateKeyboardEvent(NULL, (CGKeyCode)8, false);
        CGEventSetFlags(cUp, kCGEventFlagMaskCommand);
        CGEventPost(kCGSessionEventTap, cUp);
        
        CGEventRef commandUp = CGEventCreateKeyboardEvent(NULL, (CGKeyCode)55, false);
        CGEventPost(kCGSessionEventTap, commandUp);

        [NSThread sleepForTimeInterval:0.55];
        
        NSInteger newCount = [[NSPasteboard generalPasteboard] changeCount];
        
        if (newCount <= origCount)
            return nil;
        
        NSArray *pbTypes = [[NSPasteboard generalPasteboard] types];
        if (![pbTypes containsObject:NSTIFFPboardType])
            return nil;
        
        imageData = [[NSPasteboard generalPasteboard] dataForType:NSTIFFPboardType];

    }
    [[NSPasteboard generalPasteboard] restorePasteboardState];
    
    if (imageData == nil || [imageData length] == 0)
        return nil;
    
    NSBitmapImageRep *bitRep = [[[NSBitmapImageRep alloc] initWithData:imageData] autorelease];
    if (bitRep == nil)
        return nil;
    NSData *pngData = [bitRep representationUsingType:NSPNGFileType properties:nil];
    [bitRep release];
    
    NSPasteboard *pasteboard = [NSPasteboard pasteboardWithUniqueName];
    
    NSPasteboardItem *item = [[NSPasteboardItem alloc] init];
    [item setData:pngData forType:(NSString *)kUTTypePNG];
    [item setString:@"Grab.png" forType:(NSString *)@"public.url-name"];
    if (![pasteboard writeObjects:[NSArray arrayWithObject:item]]) {
        pasteboard = nil;
    }
    [item release];
    
    return pasteboard.name;
}

@end
