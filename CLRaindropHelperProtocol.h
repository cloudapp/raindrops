//
//  CLRaindropHelperProtocol.h
//  CloudRaindropHelper
//
//  Created by Nick Paulson on 1/28/11.
//  Copyright 2011 Linebreak. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol CLRaindropHelperProtocol <NSObject>
- (void)handlePasteboardWithName:(NSString *)pasteboardName;
@end
