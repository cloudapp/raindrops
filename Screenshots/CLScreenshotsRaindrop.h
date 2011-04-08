//
//  CLScreenshotsRaindrop.h
//  Screenshots
//
//  Created by Nick Paulson & Matthias Plappert on 1/28/11.
//  Copyright 2011 Linebreak. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CLRaindropProtocol.h"
#import "CLRaindropHelperProtocol.h"


@interface CLScreenshotsRaindrop : NSObject <CLRaindropProtocol, NSMetadataQueryDelegate> {
	id <CLRaindropHelperProtocol> _helper;
    
    NSTimer *_pasteboardTimer;
    NSUInteger _pasteboardChangeCount;
    
    NSDate *_startDate;
	NSMetadataQuery *_metadataQuery;
}

@property (nonatomic, readwrite, retain) id <CLRaindropHelperProtocol> helper;

- (NSString *)screenCaptureLocation;
- (NSDictionary *)screenCapturePrefs;

@end
