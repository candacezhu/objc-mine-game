#import <UIKit/UIKit.h>

typedef enum {
    GameStatePlaying,
    GameStateWon,
    GameStateHitBomb,
    GameTimeout
} GameState;

@interface MineModel : NSObject {
    NSMutableArray *_initBombSetting;
    NSMutableDictionary *_openCells;
    int _numberOfCorrectBombs;
    int _remainingTime;
    GameState _gameState;
}

@property(nonatomic,readonly) GameState gameState;
@property(nonatomic,readonly) NSMutableArray *initBombSetting;
@property(nonatomic,readonly) NSMutableDictionary *openCells;
@property(nonatomic,readonly) int remainingTime;

-(id)initWithPositions:(NSSet*)positions;
-(void)openMine:(int)position;
-(void)markMine:(int)position;
-(void)countDownTime;

@end
