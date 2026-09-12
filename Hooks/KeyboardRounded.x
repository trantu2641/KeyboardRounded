#import <UIKit/UIKit.h>
#import <objc/message.h>

#pragma mark - Settings

static CGFloat KRKeyRadius(void) {
    NSNumber *value = nil;

    CFPropertyListRef pref =
        CFPreferencesCopyAppValue(
            CFSTR("KeyRadius"),
            CFSTR("com.tutu.keyboardrounded")
        );

    if (pref && CFGetTypeID(pref) == CFNumberGetTypeID()) {
        value = [(NSNumber *)pref autorelease];
    }

    if (!value) {
        value = @8.0;
    }

    CGFloat radius = [value doubleValue];

    if (radius < 0.0)
        radius = 0.0;

    if (radius > 20.0)
        radius = 20.0;

    return radius;
}

#pragma mark - Keyboard Geometry

@interface UIKBRenderGeometry : NSObject
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

        CGFloat radius = KRKeyRadius();

        ((void (*)(id, SEL, double))objc_msgSend)(
            geometry,
            radiusSetter,
            (double)radius
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

        CGFloat radius = KRKeyRadius();

        ((void (*)(id, SEL, double))objc_msgSend)(
            geometry,
            radiusSetter,
            (double)radius
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
