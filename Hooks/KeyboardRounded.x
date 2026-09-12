#import <UIKit/UIKit.h>
#import <objc/message.h>

#pragma mark - Settings

static CGFloat KRKeyRadius(void) {
    NSNumber *value = [[NSUserDefaults standardUserDefaults]
        objectForKey:@"KeyRadius"];

    if (value) {
        CGFloat radius = [value doubleValue];

        if (radius < 1.0)
            radius = 1.0;

        if (radius > 16.0)
            radius = 16.0;

        return radius;
    }

    // Giá trị mặc định
    return 10.0;
}

#pragma mark - Keyboard Geometry

@interface UIKBRenderGeometry : NSObject
@property(nonatomic) double roundRectRadius;
@property(nonatomic) int roundRectCorners;
@end

#pragma mark - Keyboard Traits

@interface UIKBRenderTraits : NSObject
@end

#pragma mark - iPhone Keyboard Factory

@interface UIKBRenderFactoryiPhone : NSObject

- (id)_traitsForKey:(id)key
       onKeyplane:(id)keyplane;

@end

%hook UIKBRenderFactoryiPhone

- (id)_traitsForKey:(id)key
       onKeyplane:(id)keyplane
{
    id traits = %orig(key, keyplane);

    if (!traits)
        return traits;

    SEL geometrySelector = @selector(geometry);

    if (![traits respondsToSelector:geometrySelector])
        return traits;

    id geometry =
        ((id (*)(id, SEL))objc_msgSend)(
            traits,
            geometrySelector
        );

    if (!geometry)
        return traits;

    SEL radiusSetter = @selector(setRoundRectRadius:);

    if ([geometry respondsToSelector:radiusSetter]) {
        ((void (*)(id, SEL, double))objc_msgSend)(
            geometry,
            radiusSetter,
            (double)KRKeyRadius()
        );
    }

    SEL cornersSetter = @selector(setRoundRectCorners:);

    if ([geometry respondsToSelector:cornersSetter]) {
        ((void (*)(id, SEL, int))objc_msgSend)(
            geometry,
            cornersSetter,
            0xF
        );
    }

    return traits;
}

%end


#pragma mark - iPhone Landscape

@interface UIKBRenderFactoryiPhoneLandscape : NSObject

- (id)_traitsForKey:(id)key
       onKeyplane:(id)keyplane;

@end

%hook UIKBRenderFactoryiPhoneLandscape

- (id)_traitsForKey:(id)key
       onKeyplane:(id)keyplane
{
    id traits = %orig(key, keyplane);

    if (!traits)
        return traits;

    SEL geometrySelector = @selector(geometry);

    if (![traits respondsToSelector:geometrySelector])
        return traits;

    id geometry =
        ((id (*)(id, SEL))objc_msgSend)(
            traits,
            geometrySelector
        );

    if (!geometry)
        return traits;

    SEL radiusSetter = @selector(setRoundRectRadius:);

    if ([geometry respondsToSelector:radiusSetter]) {
        ((void (*)(id, SEL, double))objc_msgSend)(
            geometry,
            radiusSetter,
            (double)KRKeyRadius()
        );
    }

    SEL cornersSetter = @selector(setRoundRectCorners:);

    if ([geometry respondsToSelector:cornersSetter]) {
        ((void (*)(id, SEL, int))objc_msgSend)(
            geometry,
            cornersSetter,
            0xF
        );
    }

    return traits;
}

%end
