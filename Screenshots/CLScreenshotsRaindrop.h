//
//  CLScreenshotsRaindrop.h
//  Screenshots
//
//  Created by Nick Paulson on 1/28/11.
//  Copyright 2011 Linebreak. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CLRaindropProtocol.h"

@protocol CLRaindropHelperProtocol;
@interface CLScreenshotsRaindrop : NSObject <CLRaindropProtocol> {
	id <CLRaindropHelperProtocol> _helper;
	dispatch_source_t _watcherSource;
	NSMutableSet *_currentFileSet;
}

@property (nonatomic, readwrite, retain) id <CLRaindropHelperProtocol> helper;

+ (NSString *)screenCaptureLocation;
+ (NSString *)screenCaptureType;
+ (NSDictionary *)screenCapturePrefs;

@end
