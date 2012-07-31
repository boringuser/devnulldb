
#import "MyViewController.h"

@interface MyViewController ()

@property (strong) EAGLContext *glContext;

@end

@implementation MyViewController

@synthesize glContext = _glContext;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!self.glContext) {
        NSLog(@"Unable to create OpenGL context");
        exit(1);
    }

    [EAGLContext setCurrentContext:self.glContext];
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.glContext;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(150.0/255.0, 200.0/255.0, 255.0/255.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
}

@end
