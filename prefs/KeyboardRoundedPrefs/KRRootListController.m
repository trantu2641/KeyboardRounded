#import "KRRootListController.h"
#import <Preferences/PSControlTableCell.h>
#import <spawn.h>

@interface KRRootListController ()
@end

@implementation KRRootListController

- (NSArray *)specifiers
{
    if (!_specifiers) {
        _specifiers =
            [self loadSpecifiersFromPlistName:@"Root"
                                        target:self];
    }

    return _specifiers;
}

- (void)respring
{
    pid_t pid;

    const char *args[] = {
        "/usr/bin/killall",
        "SpringBoard",
        NULL
    };

    posix_spawn(
        &pid,
        "/usr/bin/killall",
        NULL,
        NULL,
        (char * const *)args,
        NULL
    );
}

@end
