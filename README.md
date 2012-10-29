This is an Objective-C implementation of a classic "minesweeper" game. It targets the iPhone platform.

## How To Play
The target is finding 15 mines without hitting a mine.   


   * Click to open a cell.
   * Long-press to identify mines.
   * The player has 2 minutes to finish the game.


## MVC Pattern
The code is using MVC pattern:  

   * MineModel is the model, which implements the game logic and stores various game data, such as mine locations and remaining time. It also exposes the state of the game as a property: "win" or "lose",  "timeout" or "playing".  According to the location of the mines, the model decides what cells to open when the player clicks a cell. For example, clicking a cell recursively opens up the cells around it when there is no bomb next to this cell and this cell is not a mine, opens up only this cell when there are mines around it, and opens up all cells in the minefield when this cell is a mine.  
   * ViewController displays the view including of all the buttons and labels.
   * When the player clicks or long presses a button, ViewController takes the view actions and sends them to the model. The model updates its data, such as which cells are open, if the game is the over, or if the time has expired. Then the view updates itself according to the data in the MineModel.

