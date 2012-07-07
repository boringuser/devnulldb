
#import <OpenAl/al.h>
#import <OpenAl/alc.h>
#include <AudioToolbox/AudioToolbox.h>

@interface OpenALHelper : NSObject

+ (void)initOpenAL;
+ (void)cleanUpOpenAL;
+ (void)playSoundNamed:(NSString *)name;
+ (void)loadSoundNamed:(NSString *)name withFileName:(NSString *)fileName andExtension:(NSString *)extension;

@end
