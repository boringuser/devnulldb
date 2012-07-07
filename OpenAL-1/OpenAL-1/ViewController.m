
#import "ViewController.h"
#import "OpenALHelper.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [OpenALHelper loadSoundNamed:@"sosumi" withFileName:@"Sosumi" andExtension:@"caf"];
    [OpenALHelper loadSoundNamed:@"basso" withFileName:@"Basso" andExtension:@"caf"];
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)playSosumi:(id)sender {
    [OpenALHelper playSoundNamed:@"sosumi"];
}

- (IBAction)playBasso:(id)sender {
    [OpenALHelper playSoundNamed:@"basso"];
}

@end
