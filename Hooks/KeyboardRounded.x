#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <objc/message.h>

#pragma mark - Settings

static CGFloat KRKeyRadius(void)
{
    CGFloat radius = 8.0;

    CFPropertyListRef pref =
        CFPreferencesCopyAppValue(
            CFSTR("KeyRadius"),
            CFSTR("com.tutu.keyboardrounded")
        );

    if (pref)
    {
        CFTypeID type = CFGetTypeID(pref);

        // PSEditTextCell có thể lưu giá trị thành CFString
        if (type == CFStringGetTypeID())
        {
            NSString *stringValue =
                [(__bridge NSString *)pref copy];

            radius = [stringValue doubleValue];
        }
        // Nếu được lưu thành CFNumber
        else if (type == CFNumberGetTypeID())
        {
            double numberValue = 8.0;

            if (CFNumberGetValue(
                    (CFNumberRef)pref,
                    kCFNumberDoubleType,
                    &numberValue))
            {
                radius = (CGFloat)numberValue;
            }
        }

        CFRelease(pref);
    }

    // Giới hạn 0 - 20
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

    CGFloat radius = KRKeyRadius();

    SEL radiusSetter = @selector(setRoundRectRadius:);

    if ([geometry respondsToSelector:radiusSetter])
    {
        ((void (*)(id, SEL, double))objc_msgSend)(
            geometry,
            radiusSetter,
            (double)radius
        );
    }

    SEL cornersSetter = @selector(setRoundRectCorners:);

    if ([geometry respondsToSelector:cornersSetter])
    {
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

    CGFloat radius = KRKeyRadius();

    SEL radiusSetter = @selector(setRoundRectRadius:);

    if ([geometry respondsToSelector:radiusSetter])
    {
        ((void (*)(id, SEL, double))objc_msgSend)(
            geometry,
            radiusSetter,
            (double)radius
        );
    }

    SEL cornersSetter = @selector(setRoundRectCorners:);

    if ([geometry respondsToSelector:cornersSetter])
    {
        ((void (*)(id, SEL, int))objc_msgSend)(
            geometry,
            cornersSetter,
            0xF
        );
    }

    return traits;
}

%end
