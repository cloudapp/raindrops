//
//  CLScreenshotsRaindrop.m
//  Screenshots
//
//  Created by Nick Paulson & Matthias Plappert on 1/28/11.
//  Copyright 2011 Linebreak. All rights reserved.
//

#import "CLScreenshotsRaindrop.h"
#import "CLRaindropHelperProtocol.h"


@interface CLScreenshotsRaindrop()

- (void)_pasteboardTimerDidFire:(NSTimer *)timer;

@end


@implementation CLScreenshotsRaindrop

@synthesize helper = _helper;

- (id)initWithHelper:(id <CLRaindropHelperProtocol>)theHelper
{
	if ((self = [super init])) {
		self.helper = theHelper;
        
        _pasteboardChangeCount = [[NSPasteboard generalPasteboard] changeCount];
        _pasteboardTimer = [[NSTimer timerWithTimeInterval:0.5f
                                                    target:self
                                                  selector:@selector(_pasteboardTimerDidFire:)
                                                  userInfo:nil
                                                   repeats:YES] retain];
        [[NSRunLoop currentRunLoop] addTimer:_pasteboardTimer forMode:NSRunLoopCommonModes];
        
        _startDate = [[NSDate date] retain];
		
        // Setup query. Do not use KVO because it (for very odd reasons) retains the observer
		_metadataQuery = [[NSMetadataQuery alloc] init];
		[_metadataQuery setSearchScopes:[NSArray arrayWithObject:[self screenCaptureLocation]]];
		NSString *predicateFormat = @"kMDItemIsScreenCapture = YES";
		NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat, [NSDate date]];
		[_metadataQuery setPredicate:predicate];
		[_metadataQuery setNotificationBatchingInterval:0.1f];
        [_metadataQuery setDelegate:self];
		[_metadataQuery startQuery]; 
	}
	return self;
}

#pragma mark -
#pragma mark NSMetadataQueryDelegate

- (id)metadataQuery:(NSMetadataQuery *)query replacementObjectForResultObject:(NSMetadataItem *)result
{   
    if (!result) {
        return result;
    }
    
    // Check dates (NSPredicate fails to do so)
    NSDate *fsCreationDate   = [result valueForAttribute:@"kMDItemFSCreationDate"];
    NSDate *modificationDate = [result valueForAttribute:@"kMDItemContentModificationDate"];
    NSDate *creationDate     = [result valueForAttribute:@"kMDItemContentCreationDate"];
    NSDate *lastUsedDate     = [result valueForAttribute:@"kMDItemLastUsedDate"];
    if ([fsCreationDate timeIntervalSinceDate:_startDate] < 0.0f || modificationDate != nil || creationDate != nil || lastUsedDate != nil) {
        return result;
    }
    
    NSString *filename = [result valueForAttribute:@"kMDItemFSName"];
    if (filename != nil) {
        NSString *path = [[self screenCaptureLocation] stringByAppendingPathComponent:filename];
        if (path != nil && [[NSFileManager defaultManager] fileExistsAtPath:path]) {
            // Create pasteboard
            NSPasteboard *pasteboard = [NSPasteboard pasteboardWithUniqueName];
            
            NSPasteboardItem *item = [[NSPasteboardItem alloc] init];
            [item setString:[[NSURL fileURLWithPath:path] absoluteString] forType:(NSString *)kUTTypeFileURL];
            if ([pasteboard writeObjects:[NSArray arrayWithObject:item]]) {
                [self.helper handlePasteboardWithName:pasteboard.name];
            }
            [item release];
        }
    }
    
    return result;
}

#pragma mark -
#pragma mark Accessors

- (NSString *)screenCaptureLocation
{
	NSString *location = [[self screenCapturePrefs] objectForKey:@"location"];
	if (location) {
		location = [location stringByExpandingTildeInPath];
		if (![location hasSuffix:@"/"]) {
			location = [location stringByAppendingString:@"/"];
		}
		return location;
	}
	
	return [[@"~/Desktop" stringByExpandingTildeInPath] stringByAppendingString:@"/"];
}

- (NSDictionary *)screenCapturePrefs
{
	return [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.apple.screencapture"];
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc
{
	self.helper = nil;
	
    [_pasteboardTimer invalidate];
    [_pasteboardTimer release];
    [_startDate release];
	[_metadataQuery stopQuery];
	[_metadataQuery release];
	
	[super dealloc];
}

#pragma mark -
#pragma mark Private methods

- (void)_pasteboardTimerDidFire:(NSTimer *)timer
{
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    if ([pasteboard changeCount] == _pasteboardChangeCount) {
        return;
    }
    _pasteboardChangeCount = [pasteboard changeCount];
        
    if ([[pasteboard pasteboardItems] count] != 1) {
        return;
    }
        
    NSArray *types = [pasteboard types];
    if ([types count] != 4) {
        return;
    }
    if (![types containsObject:(NSString *)kUTTypePNG] || ![types containsObject:@"Apple PNG pasteboard type"] || ![types containsObject:(NSString *)kUTTypeTIFF] || ![types containsObject:@"NeXT TIFF v4.0 pasteboard type"]) {
        return;
    }
        
    // Create pasteboard
    NSPasteboard *uniquePasteboard = [NSPasteboard pasteboardWithUniqueName];
    NSPasteboardItem *item = [[NSPasteboardItem alloc] init];
    [item setData:[pasteboard dataForType:(NSString *)kUTTypePNG] forType:(NSString *)kUTTypePNG];
    
    if ([uniquePasteboard writeObjects:[NSArray arrayWithObject:item]]) {
        [self.helper handlePasteboardWithName:uniquePasteboard.name];
    }
    
    [item release];
}

@end
