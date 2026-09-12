#import <UIKit/UIKit.h>

static CGFloat KRKeyRadius(void) {
    return 8.0;
}

#pragma mark - UIKBRenderFactory10Key_Round

@interface UIKBRenderFactory10Key_Round : NSObject
- (double)keyCornerRadius;
- (BOOL)shouldUseRoundCornerForKey:(id)key;
- (int)roundCornersForKey:(id)key onKeyplane:(id)keyplane;
@end

%hook UIKBRenderFactory10Key_Round

- (double)keyCornerRadius {
    return KRKeyRadius();
}

- (BOOL)shouldUseRoundCornerForKey:(id)key {
    return YES;
}

- (int)roundCornersForKey:(id)key onKeyplane:(id)keyplane {
    return 0xF;
}

%end


#pragma mark - UIKBRenderFactory_Monolith

@interface UIKBRenderFactory_Monolith : NSObject
- (double)keyRoundRectRadius;
- (void)configureCornersOnGeometry:(id)geometry forKey:(id)key;
@end

%hook UIKBRenderFactory_Monolith

- (double)keyRoundRectRadius {
    return KRKeyRadius();
}

- (void)configureCornersOnGeometry:(id)geometry
                            forKey:(id)key {

    %orig(geometry, key);
}

%end
