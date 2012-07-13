
#import "GLView.h"

#import <QuartzCore/QuartzCore.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>

@interface GLView ()
{    
    // The CAEAGLLayer is a backing layer for any view that wishes to display
    // OpenGL content. See: http://developer.apple.com/library/ios/#documentation/QuartzCore/Reference/CAEAGLLayer_Class/CAEGLLayer/CAEGLLayer.html
    CAEAGLLayer *glLayer;
    
    // All OpenGL ES commands are executed relative to a context, which manages
    // current state. See http://developer.apple.com/library/ios/#DOCUMENTATION/OpenGLES/Reference/EAGLContext_ClassRef/Reference/EAGLContext.html
    EAGLContext *glContext;
    
    // Identifer of the renderbuffer (where the current frame will be rendered).
    GLuint renderbuffer;
}

@end

@implementation GLView

/**
 * Overrides a method in UIView that specifies the backing layer class
 * for the view. UIView is responsible for managing an instance.
 */
+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

/**
 * Custom view initialization goes here. See http://developer.apple.com/library/ios/documentation/uikit/reference/uiview_class/uiview/uiview.html#//apple_ref/occ/instm/UIView/initWithFrame:
 */
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initGL];
        [self render];
    }
    
    return self;
}

/**
 * Clears the screen to a particular color.
 */
- (void)render
{
    // Set the clear color. Divide by 255 because the range for any given
    // channel is from 0 to 1, but with 8 bits per channel each one has
    // only 255 possible values.
    glClearColor(150.0/255.0, 200.0/255.0, 255.0/255.0, 1.0);
    
    // Clear the renderbuffer using the clear color.
    glClear(GL_COLOR_BUFFER_BIT);
    
    // Present the renderbuffer to the screen.
    [glContext presentRenderbuffer:GL_RENDERBUFFER];
}

/**
 * Sets up OpenGL.
 */
- (void)initGL
{    
    // First, set up our layer.
    // Get a reference to the layer instance from our superclass.
    glLayer = (CAEAGLLayer *)self.layer;
    
    // Note that for performance reasons the backing layer should be opaque.
    // Opacity is off by default, so we must change this.
    glLayer.opaque = YES;

    // Create the context that stores OpenGL state.
    glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!glContext) {
        NSLog(@"Unable to create EAGLContext");
        exit(1);
    }
    
    // Make the context the current context.
    if (![EAGLContext setCurrentContext:glContext]) {
        NSLog(@"Unable to set current EAGLContext");
        exit(1);
    }

    // Next we need to set up the renderbuffer. This is the memory where
    // the rendered image for the current frame will be stored.
    // Generate a single buffer and note its ID.
    glGenRenderbuffers(1, &renderbuffer);
    
    // Bind the renderbuffer to the GL_RENDERBUFFER target so that
    // commands against this target use this particular renderbuffer.
    glBindRenderbuffer(GL_RENDERBUFFER, renderbuffer);
    
    // Allocate storage for the renderbuffer.
    [glContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:glLayer];

    // Finally, we need to set up the framebuffer. This is a chunk of memory
    // that will be used by OpenGL when rendering the current frame.
    // Generate a single buffer and note its ID.
    GLuint framebuffer;
    glGenFramebuffers(1, &framebuffer);
    
    // Bind the framebuffer to the GL_FRAMEBUFFER target so that
    // commands against this target use this particular framebuffer.
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    
    // Attach our renderbuffer to the framebuffer. The slot GL_COLOR_ATTACHMENT0
    // is the attachment point for a renderbuffer. Note how renderbuffers are
    // sometimes refered to as "color buffers" or "color renderbuffers" because
    // the end result of a render is a color image.
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, renderbuffer);
}

@end
