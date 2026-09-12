#import <UIKit/UIKit.h>
#import <objc/message.h>

static CGFloat KRKeyRadius(void) {
    return 12.0;
}

#pragma mark - UIKBRenderGeometry

@interface UIKBRenderGeometry : NSObject
@property(nonatomic) CGFloat roundRectRadius;
@property(nonatomic) int roundRectCorners;
@end

#pragma mark - UIKBRenderer

@interface UIKBRenderer : NSObject
- (void)renderBackgroundTraits:(id)traits allowCaching:(BOOL)allowCaching;
@end

%hook UIKBRenderer

- (void)renderBackgroundTraits:(id)traits
                  allowCaching:(BOOL)allowCaching {

    id geometry = nil;

    if (traits &&
        [traits respondsToSelector:@selector(geometry)]) {

        geometry =
            ((id (*)(id, SEL))objc_msgSend)(
                traits,
                @selector(geometry)
            );
    }

    if (geometry) {

        SEL radiusGetter = @selector(roundRectRadius);
        SEL radiusSetter = @selector(setRoundRectRadius:);

        SEL cornersGetter = @selector(roundRectCorners);
        SEL cornersSetter = @selector(setRoundRectCorners:);

        BOOL hasRadius =
            [geometry respondsToSelector:radiusGetter] &&
            [geometry respondsToSelector:radiusSetter];

        BOOL hasCorners =
            [geometry respondsToSelector:cornersGetter] &&
            [geometry respondsToSelector:cornersSetter];

        CGFloat oldRadius = 0.0;
        int oldCorners = 0;

        if (hasRadius) {
            oldRadius =
                ((CGFloat (*)(id, SEL))objc_msgSend)(
                    geometry,
                    radiusGetter
                );

            ((void (*)(id, SEL, CGFloat))objc_msgSend)(
                geometry,
                radiusSetter,
                KRKeyRadius()
            );
        }

        if (hasCorners) {
            oldCorners =
                ((int (*)(id, SEL))objc_msgSend)(
                    geometry,
                    cornersGetter
                );

            /*
             * 0xF = top-left + top-right +
             *       bottom-left + bottom-right
             */
            ((void (*)(id, SEL, int))objc_msgSend)(
                geometry,
                cornersSetter,
                0xF
            );
        }

        %orig(traits, allowCaching);

        if (hasRadius) {
            ((void (*)(id, SEL, CGFloat))objc_msgSend)(
                geometry,
                radiusSetter,
                oldRadius
            );
        }

        if (hasCorners) {
            ((void (*)(id, SEL, int))objc_msgSend)(
                geometry,
                cornersSetter,
                oldCorners
            );
        }

        return;
    }

    %orig(traits, allowCaching);
}

%end


#pragma mark - UIKBRenderFactory10Key

@interface UIKBRenderFactory10Key : NSObject

- (int)roundCornersForKey:(id)key
              onKeyplane:(id)keyplane;

- (BOOL)useRoundCorner;

@end

%hook UIKBRenderFactory10Key

- (BOOL)useRoundCorner {
    return YES;
}

- (int)roundCornersForKey:(id)key
              onKeyplane:(id)keyplane {

    return 0xF;
}

%end


#pragma mark - UIKBRenderFactory10Key_Round

@interface UIKBRenderFactory10Key_Round : NSObject

- (BOOL)shouldUseRoundCornerForKey:(id)key;

- (int)roundCornersForKey:(id)key
              onKeyplane:(id)keyplane;

@end

%hook UIKBRenderFactory10Key_Round

- (BOOL)shouldUseRoundCornerForKey:(id)key {
    return YES;
}

- (int)roundCornersForKey:(id)key
              onKeyplane:(id)keyplane {

    return 0xF;
}

%end


#pragma mark - UIKBRenderFactory_Monolith

@interface UIKBRenderFactory_Monolith : NSObject

- (double)keyRoundRectRadius;

@end

%hook UIKBRenderFactory_Monolith

- (double)keyRoundRectRadius {
    return KRKeyRadius();
}

%end
