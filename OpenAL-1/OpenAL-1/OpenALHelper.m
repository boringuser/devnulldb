
#import "OpenALHelper.h"

@implementation OpenALHelper

static ALCdevice *openALDevice;
static ALCcontext *openALContext;
static ALuint outputSource;
static NSMutableDictionary *soundBuffers;

+ (void)initialize {
    // we'll associate sound names to buffer ids using a dictionary
    soundBuffers = [[NSMutableDictionary alloc] init];
}

/**
 * A utility to log if there was an error with the last OpenAL operation.
 */
+ (void)checkOpenAlError:(NSString*)operation
{
    ALenum error = alGetError();
    if (AL_NO_ERROR != error) {
        NSLog(@"Error %d when attemping to %@", error, operation);
    }
}

+ (void)playSoundNamed:(NSString *)name {
    ALuint outputBuffer = (ALuint)[[soundBuffers objectForKey:name] intValue];
    
    // attach the buffer to the source
    alSourcei(outputSource, AL_BUFFER, outputBuffer);
    [self checkOpenAlError:@"attach buffer"];

    // play the sound
    alSourcePlay(outputSource);
    [self checkOpenAlError:@"play source"];
}

+ (void)initOpenAL {
    // devices are physical sound devices (sound cards).
    // create a device -- NULL indicates we should use the default output device,
    // which is probably what we always want
    openALDevice = alcOpenDevice(NULL);
    [self checkOpenAlError:@"open devcie"];
    
    // the context keeps track of current OpenAL state.
    // create one and associate it with the device.
    openALContext = alcCreateContext(openALDevice, NULL);
    [self checkOpenAlError:@"create context"];
    
    // make the context the current context and we're good to start using OpenAL.
    alcMakeContextCurrent(openALContext);
    [self checkOpenAlError:@"make context current"];
    
    // sources emit sound.
    // generate a single output source and note its numeric identifier.
    // this allocates memory.
    alGenSources(1, &outputSource);
    [self checkOpenAlError:@"gen source"];
    
    // set source parameters
    alSourcef(outputSource, AL_PITCH, 1.0f);
    [self checkOpenAlError:@"set pitch"];
    
    alSourcef(outputSource, AL_GAIN, 1.0f);
    [self checkOpenAlError:@"set gain"];
}

+ (void)loadSoundNamed:(NSString *)name withFileName:(NSString *)fileName andExtension:(NSString *)extension {    
    // don't load the sound if it's already been loaded
    if ([soundBuffers objectForKey:name]) return;
    
    //
    // open the audio file
    //
    
    // get a reference to the audio file.
    NSString* filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:extension];
    NSURL* fileUrl = [NSURL fileURLWithPath:filePath];
    
    // the AudioFileID is an opaque identifier that Audio File Services
    // uses to refer to the audio file
    AudioFileID afid;
    
    // open the file and get an AudioFileID for it. 0 indicates we're not
    // providing a file type hint because the file name extension will suffice.
    OSStatus openResult = AudioFileOpenURL((__bridge CFURLRef)fileUrl, kAudioFileReadPermission, 0, &afid);
    
    if (0 != openResult) {
        NSLog(@"An error occurred when attempting to open the audio file %@: %ld", filePath, openResult);
        return;
    }
    
    //
    // determine the size of the audio file
    //
    
    // when getting properties, you provide a reference to a variable
    // containing the size of the property value. this variable is then
    // set to the actual size of the property value.
    UInt64 fileSizeInBytes = 0;
    UInt32 propSize = sizeof(fileSizeInBytes);
    OSStatus getSizeResult = AudioFileGetProperty(afid, kAudioFilePropertyAudioDataByteCount, &propSize, &fileSizeInBytes);
    
    if (0 != getSizeResult) {
        NSLog(@"An error occurred when attempting to determine the size of audio file %@: %ld", filePath, getSizeResult);
    }
    
    UInt32 bytesRead = (UInt32)fileSizeInBytes;    
    
    //
    // read the audio data from the file and put it into the output buffer
    //
    
    // allocate memory to hold the file
    void* audioData = malloc(bytesRead);
    
    // false means we don't want the data cached. 0 means read from the beginning.
    // bytesRead will end up containing the actual number of bytes read.
    
    OSStatus readBytesResult = AudioFileReadBytes(afid, false, 0, &bytesRead, audioData);
    
    if (0 != readBytesResult) {
        NSLog(@"An error occurred when attempting to read data from audio file %@: %ld", filePath, readBytesResult);
    }
    
    // close the file
    AudioFileClose(afid);
    
    // buffers hold the audio data.
    // generate a single output buffer and note its numeric identifier.
    // this allocates memory.
    ALuint outputBuffer;
    alGenBuffers(1, &outputBuffer);
    [self checkOpenAlError:@"gen buffer"];
    
    // copy the data into the output buffer
    alBufferData(outputBuffer, AL_FORMAT_STEREO16, audioData, bytesRead, 44100);
    [self checkOpenAlError:@"buffer data"];
    
    // keep a reference to the buffer id
    [soundBuffers setObject:[NSNumber numberWithInt:outputBuffer] forKey:name];
    
    // clean up audio data
    if (audioData) {
        free(audioData);
        audioData = NULL;
    }
}

+ (void)cleanUpOpenAL {
    alDeleteSources(1, &outputSource);
    alcDestroyContext(openALContext);
    alcCloseDevice(openALDevice);

    for (NSString *name in soundBuffers) {
        ALuint outputBuffer = (ALuint)[soundBuffers objectForKey:name];
        alDeleteBuffers(1, &outputBuffer);
    }
}

@end
