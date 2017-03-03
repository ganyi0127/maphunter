//
//  GradientPolylineRenderer.h
//  MapHunter
//
//  Created by YiGan on 15/11/2016.
//  Copyright © 2016 ganyi. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface GradientPolylineRenderer : MKOverlayPathRenderer
@property (nonatomic,assign) CGFloat maxSpeed;
@property (nonatomic,assign) CGFloat minSpeed;
- (id) initWithOverlay:(id<MKOverlay>)overlay andMaxSpeed:(CGFloat)maxSpeed andMinSpeed:(CGFloat)minSpeed;
@end
