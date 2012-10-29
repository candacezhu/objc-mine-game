

#import "MineSweeperTest.h"
#import "MineModel.h"

@implementation MineSweeperTest

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{    
    [super tearDown];
}

- (void)testConstructMineModel {
    MineModel *model = [[MineModel alloc] init];
    STAssertNotNil(model, @"model should not be null");
    [model release];
}

-(void)testConstructMineModelWithPosition {
    NSSet* positions = [NSSet setWithObjects: [NSNumber numberWithInt:7], [NSNumber numberWithInt:8], nil];
    MineModel *model = [[MineModel alloc] initWithPositions:positions];
    STAssertNotNil(model, @"model should not be null");
    [model release];
}

-(void)testInitialBombsAround {
    NSSet* positions = [NSSet setWithObjects: [NSNumber numberWithInt:6], [NSNumber numberWithInt:7], [NSNumber numberWithInt:8],
                        [NSNumber numberWithInt:26], [NSNumber numberWithInt:27], [NSNumber numberWithInt:28], nil];
    MineModel *model = [[MineModel alloc] initWithPositions:positions];
    NSMutableArray *initialSetting = model.initBombSetting;
    STAssertEqualObjects([initialSetting objectAtIndex:17], [NSNumber numberWithInt:6], @"counting bombs is not correct");
    [model release];
}

- (void)testInitialNoBombAround {
    NSSet* positions = [NSSet setWithObjects: [NSNumber numberWithInt:6], [NSNumber numberWithInt:7], [NSNumber numberWithInt:8], nil];
    MineModel *model = [[MineModel alloc] initWithPositions:positions];
    NSMutableArray *initialSetting = model.initBombSetting;
    STAssertEqualObjects([initialSetting objectAtIndex:57], [NSNumber numberWithInt:0], @"counting bombs is not correct ");
    [model release];
}

- (void)testInitialBombAtThisPosition {
    NSSet* positions = [NSSet setWithObjects: [NSNumber numberWithInt:6], [NSNumber numberWithInt:7], [NSNumber numberWithInt:8], nil];
    MineModel *model = [[MineModel alloc] initWithPositions:positions];
    NSMutableArray *initialSetting = model.initBombSetting;
    STAssertEqualObjects([initialSetting objectAtIndex:7], [NSNumber numberWithInt:-1], @"counting bombs is not correct ");
    [model release];
}

-(void)testCountDownTime {
    MineModel *model = [[MineModel alloc] init];
    for(int i = 0; i < 10; i++) {
        [model countDownTime];
    }
    STAssertEquals(model.remainingTime, 110, @"Counting down time is not correct");
    [model release];
}

-(void)testCountDownTimeTimeOut{
    MineModel *model = [[MineModel alloc] init];
    for(int i = 0; i < 200; i++) {
        [model countDownTime];
    }
    STAssertEquals(model.remainingTime, 0, @"Time out is not correct");
    [model release];
}

- (void)testOpenMineHitABomb {
    NSSet* positions = [NSSet setWithObjects: [NSNumber numberWithInt:6], [NSNumber numberWithInt:7], [NSNumber numberWithInt:8], nil];
    MineModel *model = [[MineModel alloc] initWithPositions:positions];
    [model openMine:6];
    NSMutableDictionary *openCells = model.openCells;
    int count = [openCells count];
    STAssertEquals(count, 100, @"Hit a bomb, but did not open all cells");
}

- (void)testOpenMineHitABombGameState {
    NSSet* positions = [NSSet setWithObjects: [NSNumber numberWithInt:6], [NSNumber numberWithInt:7], [NSNumber numberWithInt:8], nil];
    MineModel *model = [[MineModel alloc] initWithPositions:positions];
    [model openMine:6];
    STAssertEquals(model.gameState, GameStateHitBomb, @"Hit a bomb, game state should be GameStateHitBomb ");
}

- (void)testOpenMineBombsAround {
    NSSet* positions = [NSSet setWithObjects: [NSNumber numberWithInt:6], [NSNumber numberWithInt:7], [NSNumber numberWithInt:8],
                         [NSNumber numberWithInt:16], [NSNumber numberWithInt:26], [NSNumber numberWithInt:36],
                         [NSNumber numberWithInt:19], [NSNumber numberWithInt:29], [NSNumber numberWithInt:39],
                         [NSNumber numberWithInt:37], [NSNumber numberWithInt:38], nil];
    MineModel *model = [[MineModel alloc] initWithPositions:positions];
    [model openMine:17];
    NSMutableDictionary *openCells = model.openCells;
    int count = [openCells count];
    STAssertEquals(count, 1, @"Hit a cell which has bombs around");
}

- (void)testOpenMineNoBombsAround {
    NSSet* positions = [NSSet setWithObjects: [NSNumber numberWithInt:2], [NSNumber numberWithInt:12], [NSNumber numberWithInt:22],
                        [NSNumber numberWithInt:20], [NSNumber numberWithInt:21], nil];
    MineModel *model = [[MineModel alloc] initWithPositions:positions];
    [model openMine:0];
    NSMutableDictionary *openCells = model.openCells;
    int count = [openCells count];
    STAssertEquals(count, 4, @"Hit a cell no bomb around");
}

- (void) testMarkMine {
    NSSet* positions = [NSSet setWithObjects: [NSNumber numberWithInt:6], [NSNumber numberWithInt:7], [NSNumber numberWithInt:8],
                        [NSNumber numberWithInt:16], [NSNumber numberWithInt:17], [NSNumber numberWithInt:18],
                        [NSNumber numberWithInt:26], [NSNumber numberWithInt:27], [NSNumber numberWithInt:28],
                        [NSNumber numberWithInt:36], [NSNumber numberWithInt:37], [NSNumber numberWithInt:38],
                        [NSNumber numberWithInt:46], [NSNumber numberWithInt:47], [NSNumber numberWithInt:48], nil];
    MineModel *model = [[MineModel alloc] initWithPositions:positions];
    [model markMine:6];
    [model markMine:7];
    [model markMine:8];
    [model markMine:16];
    [model markMine:17];
    [model markMine:18];
    [model markMine:26];
    [model markMine:27];
    [model markMine:28];
    [model markMine:36];
    [model markMine:37];
    [model markMine:38];
    [model markMine:46];
    [model markMine:47];
    [model markMine:48];
    STAssertEquals(model.gameState, GameStateWon, @"Marked all bombs. Game state is GameStateWon");
}

- (void) testMarkMineMarkedWrongBomb {
    NSSet* positions = [NSSet setWithObjects: [NSNumber numberWithInt:6], [NSNumber numberWithInt:7], [NSNumber numberWithInt:8],
                        [NSNumber numberWithInt:16], [NSNumber numberWithInt:17], [NSNumber numberWithInt:18],
                        [NSNumber numberWithInt:26], [NSNumber numberWithInt:27], [NSNumber numberWithInt:28],
                        [NSNumber numberWithInt:36], [NSNumber numberWithInt:37], [NSNumber numberWithInt:38],
                        [NSNumber numberWithInt:46], [NSNumber numberWithInt:47], [NSNumber numberWithInt:48], nil];
    MineModel *model = [[MineModel alloc] initWithPositions:positions];
    [model markMine:6];
    [model markMine:7];
    [model markMine:8];
    [model markMine:16];
    [model markMine:17];
    [model markMine:18];
    [model markMine:26];
    [model markMine:27];
    [model markMine:28];
    [model markMine:36];
    [model markMine:37];
    [model markMine:38];
    [model markMine:46];
    [model markMine:47];
    [model markMine:49];
    STAssertEquals(model.gameState, GameStatePlaying, @"Marked a wrong bomb, game state should be GameStatePlaying");
}
@end
