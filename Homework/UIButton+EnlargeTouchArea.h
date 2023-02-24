//
//  UIButton+EnlargeTouchArea.h
//  Goccia
//

#import <UIKit/UIKit.h>

@interface UIButton (EnlargeTouchArea)
- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;
- (CGRect)enlargedRect;
@end
