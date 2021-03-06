//
//  GradientPolylineRenderer.m
//  MapHunter
//
//  Created by YiGan on 15/11/2016.
//  Copyright © 2016 ganyi. All rights reserved.
//

#import "GradientPolylineRenderer.h"
#import <pthread.h>
#import "GradientPolylineOverlay.h"
#import "MapHunter-Swift.h"
//#import "Constant.h"

#define V_MAX 20.0
#define V_MIN 5.0
#define H_MAX 0.33
#define H_MIN 0.03

@implementation GradientPolylineRenderer{
    float* hues;
    pthread_rwlock_t rwLock;
    GradientPolylineOverlay* polyline;
}

- (id) initWithOverlay:(id<MKOverlay>)overlay{
    self = [super initWithOverlay:overlay];
    if (self){
        pthread_rwlock_init(&rwLock,NULL);
        polyline = ((GradientPolylineOverlay*)self.overlay);
        float *velocity = polyline.velocity;
        int count = (int)polyline.pointCount;
        [self velocity:velocity ToHue:&hues count:count];
        [self createPath];
    }
    return self;
}

- (void) velocity:(float*)velocity ToHue:(float**)_hue count:(int)count{
    *_hue = malloc(sizeof(float)*count);
    for (int i=0;i<count;i++){
        float curVelo = velocity[i];
        
        if(curVelo>0.){
            if (curVelo < V_MIN){
                curVelo = V_MIN;
            }else if (curVelo > V_MAX){
                curVelo = V_MAX;
            }
            (*_hue)[i] = H_MIN + ((curVelo - [OCVariable share].v_min) / ([OCVariable share].v_max - [OCVariable share].v_min)) * (H_MAX - H_MIN);
        }else{
            //暂停颜色
            (*_hue)[i] = 0.;
        }
    }
}

-(void) createPath{
    CGMutablePathRef path = CGPathCreateMutable();
    BOOL pathIsEmpty = YES;
    for (int i=0;i< polyline.pointCount;i++){
        CGPoint point = [self pointForMapPoint:polyline.points[i]];
        if (pathIsEmpty){
            CGPathMoveToPoint(path, nil, point.x, point.y);
            pathIsEmpty = NO;
        } else {
            CGPathAddLineToPoint(path, nil, point.x, point.y);
        }
    }
    
    pthread_rwlock_wrlock(&rwLock);
    self.path = path; ///<— don't forget this line.
    pthread_rwlock_unlock(&rwLock);
}

- (void) drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context{
    
    //put this blok into the canDraw method cause problem
    CGRect pointsRect = CGPathGetBoundingBox(self.path);
    CGRect mapRectCG = [self rectForMapRect:mapRect];
    if (!CGRectIntersectsRect(pointsRect, mapRectCG))return;
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    UIColor* pcolor,*ccolor;
    for (int i=0;i< polyline.pointCount;i++){
        CGPoint point = [self pointForMapPoint:polyline.points[i]];
        CGMutablePathRef path = CGPathCreateMutable();
        
        if(hues[i]==0.){
            //虚线
            if(i==0){
                CGPathMoveToPoint(path, nil, point.x, point.y);
            }else{
                //颜色
                CGContextSetRGBStrokeColor(context, 153.0 / 255.0, 153.0 / 255.0, 153.0 / 255.0, 1.0);
                //线宽
                CGFloat lineWidth = CGContextConvertSizeToUserSpace(context, (CGSize){self.lineWidth,self.lineWidth}).width;
                CGContextSetLineWidth(context, lineWidth);
                
                CGFloat lengths[] = {lineWidth*2,lineWidth*2};//设置虚线
                CGContextSetLineDash(context, lineWidth, lengths, 2);//设置虚线
                
                CGPoint prevPoint = [self pointForMapPoint:polyline.points[i-1]];
                CGPathMoveToPoint(path, nil, prevPoint.x, prevPoint.y);
                CGPathAddLineToPoint(path, nil, point.x, point.y);
                CGContextAddPath(context, path);
                CGContextStrokePath(context);
            }
        }else{
            //跑步渐变
            ccolor = [UIColor colorWithHue:hues[i] saturation:1.0f brightness:1.0f alpha:1.0f];
            if (i==0){
                CGPathMoveToPoint(path, nil, point.x, point.y);
                pcolor = [UIColor colorWithCGColor:ccolor.CGColor];
            } else {
                CGPoint prevPoint = [self pointForMapPoint:polyline.points[i-1]];
                CGPathMoveToPoint(path, nil, prevPoint.x, prevPoint.y);
                CGPathAddLineToPoint(path, nil, point.x, point.y);
                
                CGFloat pc_r,pc_g,pc_b,pc_a,
                cc_r,cc_g,cc_b,cc_a;
                
                [pcolor getRed:&pc_r green:&pc_g blue:&pc_b alpha:&pc_a];
                [ccolor getRed:&cc_r green:&cc_g blue:&cc_b alpha:&cc_a];
                
                CGFloat gradientColors[8] = {pc_r,pc_g,pc_b,pc_a,
                    cc_r,cc_g,cc_b,cc_a};
                
                CGFloat gradientLocation[2] = {0,1};
                CGContextSaveGState(context);
                CGFloat lineWidth = CGContextConvertSizeToUserSpace(context, (CGSize){self.lineWidth,self.lineWidth}).width;
                CGPathRef pathToFill = CGPathCreateCopyByStrokingPath(path, NULL, lineWidth, self.lineCap, self.lineJoin, self.miterLimit);
                CGContextAddPath(context, pathToFill);
                CGContextClip(context);
                CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
                CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradientColors, gradientLocation, 2);
                CGColorSpaceRelease(colorSpace);
                CGPoint gradientStart = prevPoint;
                CGPoint gradientEnd = point;
                CGContextDrawLinearGradient(context, gradient, gradientStart, gradientEnd, kCGGradientDrawsAfterEndLocation);
                CGGradientRelease(gradient);
                CGContextRestoreGState(context);
                pcolor = [UIColor colorWithCGColor:ccolor.CGColor];
            }

        }
    }
}

@end
