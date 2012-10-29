#define GRID_SIZE 10
#define AMOUNT_BOMB 15

#import "ViewController.h"
#import "MineModel.h"

@interface ViewController ()

-(void)newGame;
-(void)displayBombs;

@end

@implementation ViewController

@synthesize countDownLabel=_countDownLabel;
@synthesize countMarkedMineLabel=_countMarkedMineLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    for(int i = 0; i < GRID_SIZE; i++) {
        for(int j = 0; j < GRID_SIZE; j++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            button.frame = CGRectMake(10 + 30 * j , 60 + 30 * i, 30, 30);
            button.tag = i * GRID_SIZE + j + 500;
            button.enabled = YES;
            [button setTitle: @"" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHandler:)];
            longPressGesture.minimumPressDuration = 1;
            [button addGestureRecognizer:longPressGesture];
            [longPressGesture release];
            [self.view addSubview: button];
        }
    }
    [self newGame];
}

-(void) newGame {
    _mineModel = [[MineModel alloc] init];
    _numberOfMarkedBombs = AMOUNT_BOMB;    
    self.countMarkedMineLabel.text = [[NSNumber numberWithInt:AMOUNT_BOMB] stringValue];
    _countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerLabelDisplay:) userInfo:nil repeats:YES];
}

-(void)timerLabelDisplay:(id)sender {
    [_mineModel countDownTime];
    int remainingTime = _mineModel.remainingTime;
    int minute = remainingTime / 60;
    int second = remainingTime % 60;
    [self.countDownLabel setText:[NSString stringWithFormat:@"%02d : %02d", minute, second]];
    if(_mineModel.gameState == GameTimeout) {
        [self displayBombs];
        [_countdownTimer invalidate];
        self.countMarkedMineLabel.text = @"Time Out";
    }
}

-(IBAction)longPressHandler:(UITapGestureRecognizer *)sender {
    UIButton *btn = (UIButton *)sender.view;
	if (sender.state == UIGestureRecognizerStateBegan)
	{   
        self.countMarkedMineLabel.text = [[NSNumber numberWithInt: --_numberOfMarkedBombs] stringValue];
        [btn setTitle:@"*" forState:UIControlStateNormal];
        [_mineModel markMine:btn.tag - 500];
        if(_mineModel.gameState == GameStateWon) {
            self.countMarkedMineLabel.text = @"WIN";
            [self displayBombs];
            [_countdownTimer invalidate];
        }
	}
}

-(IBAction)btnClick:(id)sender {
    UIButton *buttonClicked = (UIButton *)sender;
    int cellIndex = buttonClicked.tag - 500;
    [_mineModel openMine:cellIndex];
    [self displayBombs];
    
    if(_mineModel.gameState == GameStateHitBomb){
        self.countMarkedMineLabel.text = @"Lose";
        [_countdownTimer invalidate];
    }
}

-(void)displayBombs {
    NSMutableDictionary *openCells = _mineModel.openCells;
    for (NSNumber *cellIndex in openCells)
    {
        NSNumber *numberOfBombsAround = [openCells objectForKey:cellIndex];
        UIButton *btn = (UIButton *)[self.view viewWithTag:[cellIndex intValue] + 500];
        if([[btn currentTitle] isEqualToString:@"*"]){
            self.countMarkedMineLabel.text = [[NSNumber numberWithInt: ++_numberOfMarkedBombs] stringValue];
        }
        [btn setTitle:[NSString stringWithFormat:@"%@", numberOfBombsAround] forState:UIControlStateNormal];
        btn.enabled = NO;
    }
}

-(IBAction)newGameClicked:(id)sender {
    if(_mineModel.gameState == GameStatePlaying) {
        [_countdownTimer invalidate];
    }
    [self newGame];
    
    for(int i = 0; i < GRID_SIZE * GRID_SIZE; i++) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:(i + 500)];
        btn.enabled = YES;
        [btn setTitle: @"" forState:UIControlStateNormal];
    }
}

-(void)dealloc {
    [_mineModel release];
    [_countdownTimer release];
    [super dealloc];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
