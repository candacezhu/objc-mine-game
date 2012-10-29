#import <UIKit/UIKit.h>
#import "MineModel.h"

@interface ViewController : UIViewController {
    int _numberOfMarkedBombs;
    MineModel *_mineModel;
    NSTimer *_countdownTimer;
}

@property(nonatomic,retain) IBOutlet UILabel *countDownLabel;
@property(nonatomic,retain) IBOutlet UILabel *countMarkedMineLabel;

-(IBAction)longPressHandler:(UITapGestureRecognizer *)sender;
-(IBAction)btnClick:(id)sender;
-(IBAction)newGameClicked:(id)sender;

@end
