//
//  GradientPolylineOverlay.h
//  MapHunter
//
//  Created by YiGan on 14/11/2016.
//  Copyright © 2016 ganyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface GradientPolylineOverlay : NSObject <MKOverlay>{
    MKMapPoint *points;
    NSUInteger pointCount;
    NSUInteger pointSpace;
    
    MKMapRect boundingMapRect;
    pthread_rwlock_t rwLock;
}

-(id) initWithStartCoordinate:(CLLocationCoordinate2D)startCoord endCoordinate: (CLLocationCoordinate2D)endCoord startVelcity: (float)startVelcity endVelcity: (float)endVelcity;
-(id) initWithPoints:(CLLocationCoordinate2D*)_points velocity:(float*)_velocity count:(NSUInteger)_count;

-(MKMapRect)addCoordinate:(CLLocationCoordinate2D)coord velcity:(float)newVelcity;

-(void) lockForReading;

@property (assign) MKMapPoint *points;
@property (readonly) NSUInteger pointCount;
@property (assign) float *velocity;

-(void) unlockForReading;

@end
