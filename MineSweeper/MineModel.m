#define IS_MINE -1
#define NOT_MINE -2
#define TOTAL_MINE 15
#define GRID_SIZE 10

#import "MineModel.h"

@interface MineModel ()

-(NSMutableSet* )generateMinePositions;
-(void)openAllBombs;

@end

@implementation MineModel 

@synthesize initBombSetting= _initBombSetting;
@synthesize openCells=_openCells;
@synthesize remainingTime=_remainingTime;
@synthesize gameState=_gameState;

-(id)init {    
    NSSet *positions = [self generateMinePositions];
    return [self initWithPositions:positions];
}

-(id)initWithPositions:(NSSet*)positions {
    self = [super init];
    if(self) {
        [self newGame:positions];
    }
    return self;
}

-(void)newGame:(NSSet*)positions {
    _numberOfCorrectBombs = 0;
    _remainingTime = 120;
    _initBombSetting = [[NSMutableArray alloc] initWithCapacity:GRID_SIZE * GRID_SIZE];
    _openCells = [[NSMutableDictionary alloc] initWithCapacity:GRID_SIZE * GRID_SIZE];
    _gameState = GameStatePlaying;
        
    for(int i = 0; i < GRID_SIZE; i++) {
        for(int j = 0; j < GRID_SIZE; j++) {
            int number = i * GRID_SIZE + j;
            if([positions containsObject:[NSNumber numberWithInt: number]]) {
                [_initBombSetting addObject:[NSNumber numberWithInt:IS_MINE]];
            } else {
                [_initBombSetting addObject:[NSNumber numberWithInt:NOT_MINE]];
            }
        }
    }
    [self initializeCounts];
}

-(void)initializeCounts {
    for(int i = 0; i < GRID_SIZE; i++) {
        for(int j = 0; j < GRID_SIZE; j++) {
            int index = GRID_SIZE * i + j;
            if([[_initBombSetting objectAtIndex:index] intValue] == NOT_MINE) {
                int count = 0;
                for(int m = i - 1; m <= i + 1; m++) {
                    if(m >= 0 && m < GRID_SIZE) {
                        for (int n = j - 1; n <= j + 1; n++) {
                            if(n >= 0 && n < GRID_SIZE) {
                                if(m != i || n != j) {
                                    int mineArroundindex = m * GRID_SIZE + n;
                                    if( [[_initBombSetting objectAtIndex:mineArroundindex] intValue] == IS_MINE) {
                                        count++;
                                    }
                                }
                            }
                        }
                    }
                }
                [_initBombSetting replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:count]];
            }
        }
    }
    
    for(int i = 0; i < [_initBombSetting count]; i++) {
        printf("%d ", [[_initBombSetting objectAtIndex:i] intValue]);
        if(i % 10 == 9) {
            printf("\n");
        }
    }
}

-(void)countDownTime {
    if(_remainingTime > 0) {
        _remainingTime--;
    }  if(_remainingTime == 0) {
        _gameState = GameTimeout;
        [self openAllBombs];
    }      
}

-(void)markMine:(int)position {
    if([[_initBombSetting objectAtIndex:position] intValue] == -1) {
        _numberOfCorrectBombs++;
        if(_numberOfCorrectBombs == TOTAL_MINE) {
            _gameState = GameStateWon;
            [self openAllBombs];
        }
    }
}

-(void)openMine:(int)position {
    NSNumber *cellValue = [_initBombSetting objectAtIndex:position];
    int intCellValue = [cellValue intValue];
    if(intCellValue == -1) {
        _gameState = GameStateHitBomb;
        [self openAllBombs];
    } else if(intCellValue > 0){
        [_openCells setObject:cellValue forKey:[NSNumber numberWithInt:position]];
    } else if(intCellValue == 0){
        [self openAround:position];
    }
}

-(void)openAround:(int)position {
    NSNumber *numberOfBombsAround = [_initBombSetting objectAtIndex:position];
    int numberOFBombsAroundInt = [numberOfBombsAround intValue];
    
    NSNumber *positionNS = [NSNumber numberWithInt:position];
    if ([_openCells objectForKey:positionNS]) {
        return;
    } else {
        if(numberOFBombsAroundInt == -1) {
            return;
        } else if(numberOFBombsAroundInt > 0) {
            [_openCells setObject:numberOfBombsAround forKey:positionNS];
            return;
        } else if(numberOFBombsAroundInt == 0){
            [_openCells setObject:numberOfBombsAround forKey:positionNS];
        }
    }

    int i = position / GRID_SIZE;
    int j = position % GRID_SIZE;
       
    for(int m = i - 1; m <= i + 1; m++) {
        if(m >= 0 && m < GRID_SIZE) {
            for (int n = j - 1; n <= j + 1; n++){
                if(n >= 0 && n < GRID_SIZE) {
                    if(m != i || n != j) {
                        [self openAround: m * GRID_SIZE + n];
                    }
                }
            }
        }
    }  
}

-(void)openAllBombs {
    for(int i = 0; i < GRID_SIZE * GRID_SIZE; i++) {
        NSNumber *position = [NSNumber numberWithInt:i];
        if (![_openCells objectForKey:position]) {
            [_openCells setObject:[_initBombSetting objectAtIndex:i] forKey:position];
        }
    }
}

-(NSSet*)generateMinePositions {
    NSMutableSet *bombPositions = [[[NSMutableSet alloc] init] autorelease];
    while([bombPositions count] != TOTAL_MINE) {
        int numberInt = arc4random() % 100;
        [bombPositions addObject: [NSNumber numberWithInt:numberInt]];
    }
    NSSet *bombPositionsSet = [NSSet setWithSet:bombPositions];
    return bombPositionsSet;
}

@end
