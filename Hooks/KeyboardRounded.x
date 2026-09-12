#import <UIKit/UIKit.h>
#import <objc/message.h>

#pragma mark - Settings

static CGFloat KRKeyRadius(void) {
    CFPropertyListRef pref =
        CFPreferencesCopyAppValue(
            CFSTR("KeyRadius"),
            CFSTR("com.tutu.keyboardrounded")
        );

    CGFloat radius = 8.0;

    if (pref && CFGetTypeID(pref) == CFNumberGetTypeID()) {
        double value = 8.0;

        if (CFNumberGetValue(
                (CFNumberRef)pref,
                kCFNumberDoubleType,
                &value)) {
            radius = (CGFloat)value;
        }
    }

    if (pref) {
        CFRelease(pref);
    }

    if (radius < 0.0) {
        radius = 0.0;
    }

    if (radius > 20.0) {
        radius = 20.0;
    }

    return radius;
}

#pragma mark - Keyboard Geometry

@interface UIKBRenderGeometry : NSObject
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

    if (!traits) {
        return traits;
    }

    /*
     * Không gọi [traits geometry] trực tiếp.
     * Dùng objc_msgSend để tránh lỗi:
     * no known instance method for selector 'geometry'
     */

    SEL geometrySelector = @selector(geometry);

    if (![traits respondsToSelector:geometrySelector]) {
        return traits;
    }

    id geometry =
        ((id (*)(id, SEL))objc_msgSend)(
            traits,
            geometrySelector
        );

    if (!geometry) {
        return traits;
    }

    /*
     * Lấy radius từ Settings.
     * Giá trị được giới hạn trong khoảng 0 - 20.
     */

    SEL radiusSetter = @selector(setRoundRectRadius:);

    if ([geometry respondsToSelector:radiusSetter]) {

        CGFloat radius = KRKeyRadius();

        ((void (*)(id, SEL, double))objc_msgSend)(
            geometry,
            radiusSetter,
            (double)radius
        );
    }

    /*
     * Bo cả 4 góc của phím.
     */

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

    if (!traits) {
        return traits;
    }

    /*
     * Lấy geometry bằng objc_msgSend.
     */

    SEL geometrySelector = @selector(geometry);

    if (![traits respondsToSelector:geometrySelector]) {
        return traits;
    }

    id geometry =
        ((id (*)(id, SEL))objc_msgSend)(
            traits,
            geometrySelector
        );

    if (!geometry) {
        return traits;
    }

    /*
     * Áp dụng radius từ Settings.
     */

    SEL radiusSetter = @selector(setRoundRectRadius:);

    if ([geometry respondsToSelector:radiusSetter]) {

        CGFloat radius = KRKeyRadius();

        ((void (*)(id, SEL, double))objc_msgSend)(
            geometry,
            radiusSetter,
            (double)radius
        );
    }

    /*
     * Bo cả 4 góc.
     */

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
