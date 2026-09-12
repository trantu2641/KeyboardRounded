#import "KRRootListController.h"
#import <Preferences/PSControlTableCell.h>
#import <spawn.h>

@interface KRRespringCell : PSControlTableCell
@end

@implementation KRRespringCell

- (void)controlTapped:(id)sender
{
    pid_t pid;
    const char *args[] = {
        "/usr/bin/killall",
        "SpringBoard",
        NULL
    };

    posix_spawn(
        &pid,
        args[0],
        NULL,
        NULL,
        (char * const *)args,
        NULL
    );
}

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

@end
