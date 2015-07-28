//
//  LocationManager.m
//  GeoFencing
//
//  Created by Lei on 11/20/14.
//  Copyright (c) 2014 Lei. All rights reserved.
//

#import "LocationManager.h"
#import "SLLocation.h"
#import "CLCircularRegion+Distance.h"
#import <Realm.h>
#import <CoreLocation/CoreLocation.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

@interface LocationManager() <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *clManager;
@property (strong, nonatomic) RLMRealm *realm;

@end

static const DDLogLevel ddLogLevel = DDLogLevelVerbose;

@implementation LocationManager

- (id)init {
    if (self = [super init]) {
        _realm = [RLMRealm defaultRealm];
        _clManager = [[CLLocationManager alloc] init];
        _clManager.delegate = self;
    }
    return self;
}

+ (instancetype)sharedLocationManager {
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)startTracking {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [_clManager requestAlwaysAuthorization];
    } else {
        [_clManager startUpdatingLocation];
    }
}

- (CLCircularRegion *)regionFromLocations:(NSArray *)locations radius:(CLLocationDistance)radius {
    CLLocation *center = [self centerLocationInLocations:locations];
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:center.coordinate
                                                                 radius:radius
                                                             identifier:[[NSDate date] description]];
    return region;
}

- (CLLocation *)centerLocationInLocations:(NSArray *)locations {
    if (locations.count == 1) {
        return locations[0];
    }
    
    CLLocation *result = [[CLLocation alloc] init];
    
    double minTotalDistance = MAXFLOAT;
    
    for (int i = 0; i < locations.count; i++) {
        CLLocationDistance totalDistance = 0;
        CLLocation *location = locations[i];
        for (int j = 0; j < locations.count; j++) {
            totalDistance += [location distanceFromLocation:locations[j]];
        }
        
        if(totalDistance <= minTotalDistance) {
            result = location;
            minTotalDistance = totalDistance;
        }
    }
    return result;
}

- (BOOL)hasMonitoredRegionsWithin:(CLLocationDistance)radius
                       fromRegion:(CLCircularRegion *)region {
    NSSet *monitoredRegions = [_clManager monitoredRegions];
    for (CLCircularRegion *monitoredRegion in monitoredRegions) {
        if ([region distanceFromRegion:monitoredRegion] < radius) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    DDLogInfo(@"location manager didUpdateLocation - count:%lu", (unsigned long)locations.count);
    
    NSMutableArray *sllocationArray = [[NSMutableArray alloc] init];
    for (CLLocation *location in locations) {
        SLLocation *sllocation = [[SLLocation alloc] initWithCLLocation:location];
        [sllocationArray addObject:sllocation];
    }
    
    // write locations to Realm
    [_realm beginWriteTransaction];
    [_realm addObjects:sllocationArray];
    [_realm commitWriteTransaction];
    
    CLCircularRegion *region = [self regionFromLocations:locations radius:50.0];
    if (![self hasMonitoredRegionsWithin:50.0 fromRegion:region]) {
        DDLogInfo(@"start monitoring for region: %@", region);
        [_clManager startMonitoringForRegion:region];
    }
    
    [_clManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedAlways) {
        [_clManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    DDLogInfo(@"locationManager didExitRegion: %@", region);
    [_clManager stopMonitoringForRegion:region];
    [_clManager startUpdatingLocation];
}

@end
