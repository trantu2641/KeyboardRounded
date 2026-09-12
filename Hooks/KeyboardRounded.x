#import <UIKit/UIKit.h>
#import <objc/message.h>

static CGFloat KRKeyRadius(void) {
    return 12.0;
}

#pragma mark - UIKBRenderFactory10Key

@interface UIKBRenderFactory10Key : NSObject
- (int)roundCornersForKey:(id)key onKeyplane:(id)keyplane;
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
- (int)roundCornersForKey:(id)key onKeyplane:(id)keyplane;
- (void)_customizeGeometry:(id)geometry
                    forKey:(id)key
                  contents:(id)contents
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

- (void)_customizeGeometry:(id)geometry
                    forKey:(id)key
                  contents:(id)contents
               onKeyplane:(id)keyplane {

    %orig(geometry, key, contents, keyplane);

    if (geometry &&
        [geometry respondsToSelector:@selector(setRoundRectRadius:)]) {

        ((void (*)(id, SEL, CGFloat))objc_msgSend)(
            geometry,
            @selector(setRoundRectRadius:),
            KRKeyRadius()
        );
    }
}

%end
