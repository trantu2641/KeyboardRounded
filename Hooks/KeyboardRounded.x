#import <UIKit/UIKit.h>
#import <CoreFoundation/CoreFoundation.h>

#pragma mark - Settings

static CGFloat KRKeyRadius(void) {
    CFPropertyListRef value = CFPreferencesCopyAppValue(
        CFSTR("KeyRadius"),
        CFSTR("com.tutu.keyboardrounded")
    );

    CGFloat radius = 10.0;

    if (value && CFGetTypeID(value) == CFNumberGetTypeID()) {
        double number = 10.0;
        CFNumberGetValue(
            (CFNumberRef)value,
            kCFNumberDoubleType,
            &number
        );

        radius = (CGFloat)number;
    }

    if (value) {
        CFRelease(value);
    }

    // Giới hạn tuyệt đối 0 - 20
    if (radius < 0.0)
        radius = 0.0;

    if (radius > 20.0)
        radius = 20.0;

    return radius;
}

#pragma mark - UIKBRenderFactory10Key_Round

@interface UIKBRenderFactory10Key_Round : NSObject

- (double)keyCornerRadius;
- (BOOL)shouldUseRoundCornerForKey:(id)key;
- (int)roundCornersForKey:(id)key
             onKeyplane:(id)keyplane;

@end

%hook UIKBRenderFactory10Key_Round

- (double)keyCornerRadius {
    return KRKeyRadius();
}

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

- (void)configureCornersOnGeometry:(id)geometry
                            forKey:(id)key;

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
