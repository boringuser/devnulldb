
#import "AppDelegate.h"
#import "OpenALHelper.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [OpenALHelper cleanUpOpenAL];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [OpenALHelper initOpenAL];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
