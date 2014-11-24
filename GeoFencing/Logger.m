//
//  Logger.m
//  GeoFencing
//
//  Created by Lei on 11/20/14.
//  Copyright (c) 2014 Lei. All rights reserved.
//

#import "Logger.h"
#import <CocoaLumberjack/CocoaLumberjack.h>

@implementation Logger

+ (void)configureLogger {
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
                                                          NSUserDomainMask,
                                                          YES)
                      objectAtIndex:0];
    path = [path stringByAppendingPathComponent:@"/Caches/Logs"];
    DDLogFileManagerDefault *fileManager = [[DDLogFileManagerDefault alloc] initWithLogsDirectory:path];
    DDFileLogger *fileLogger = [[DDFileLogger alloc] initWithLogFileManager:fileManager];
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    
    [DDLog addLogger:fileLogger];
    
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
}

@end
