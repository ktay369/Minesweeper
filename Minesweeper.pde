

import de.bezier.guido.*;
public static final int NUM_ROWS = 20; 
public static final int NUM_COLS = 20;
public static final int NUM_BOMBS = 15;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
  size(400, 400);
  textAlign(CENTER, CENTER);
  // make the manager
  Interactive.make( this );

  //your code to declare and initialize buttons goes here
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int r=0; r<buttons.length; r++)
  {
    for (int c=0; c<buttons[r].length; c++)
      buttons[r][c] = new MSButton(r, c);
  }
  setBombs();
}
public void setBombs()
{
  while (bombs.size()<NUM_BOMBS)
  {
    int row, col;
    row = (int)(Math.random()*NUM_ROWS);
    col = (int)(Math.random()*NUM_COLS);
    if (!bombs.contains(buttons[row][col])) {
      bombs.add(buttons[row][col]);
      System.out.println(row+","+col);
    }
  }
}

public void draw ()
{
  background( 0 );
  if (isWon())
    displayWinningMessage();
}
public boolean isWon()
{
  int mCount=0;
  int cCount=0;
  int bCount=0;
  for(int r=0; r<NUM_ROWS; r++){
    for(int c=0; c<NUM_COLS; c++){
      if(buttons[r][c].isMarked())
      mCount++;
      else if(buttons[r][c].isClicked())
      cCount++;
    }
  }
  for (int i=0; i<bombs.size(); i++) {  
    if (bombs.get(i).isMarked())
      bCount++;
  }
  if(cCount+mCount==NUM_ROWS*NUM_COLS&&bCount==NUM_BOMBS)
  return true;
  return false;
  //all bombs are marked, all are marked or clicked
}
public void displayLosingMessage()
{
  String[]lost=new String[] {"L","o","s","e","r"};
  for(int i=0; i<lost.length; i++){
    buttons[10][i+5].setLabel(lost[i]);
  }
  for(int i=0; i<NUM_BOMBS; i++){
    if(bombs.get(i).clicked==false)
    bombs.get(i).clicked=true;
  }
}
public void displayWinningMessage()
{
  String[]won=new String[] {"W","i","n","n","e","r"};
  for(int i=0; i<won.length; i++){
    buttons[10][i+5].setLabel(won[i]);
  }
}

public class MSButton
{
  private int r, c;
  private float x, y, width, height;
  private boolean clicked, marked;
  private String label;

  public MSButton ( int rr, int cc )
  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    r = rr;
    c = cc; 
    x = c*width;
    y = r*height;
    label = "";
    marked = clicked = false;
    Interactive.add( this ); // register it with the manager
  }
  public boolean isMarked()
  {
    return marked;
  }
  public boolean isClicked()
  {
    return clicked;
  }
  // called by manager

  public void mousePressed () 
  {
    clicked = true;
    //your code here
    if (mouseButton==RIGHT) {
      marked = !marked;
      if (marked == false)
        clicked=false;
    } else if (bombs.contains(this))
      displayLosingMessage();
    else if (countBombs(r, c)>0) {
      setLabel(""+countBombs(r, c));
    } else {
      if (isValid(r, c-1) && !buttons[r][c-1].isClicked())
        buttons[r][c-1].mousePressed();
      if (isValid(r, c+1) && !buttons[r][c+1].isClicked())
        buttons[r][c+1].mousePressed();
      if (isValid(r-1, c) && !buttons[r-1][c].isClicked())
        buttons[r-1][c].mousePressed();
      if (isValid(r+1, c) && !buttons[r+1][c].isClicked())
        buttons[r+1][c].mousePressed();
      //3 more recursive calls
    }
  }

 public void click8(int nr, int nc){
  if (isValid(nr, nc) && buttons[nr][nc].isMarked())
        buttons[nr][nc].mousePressed();
 }
  public void draw () 
  {    
    if (marked)
      fill(0);
    else if ( clicked && bombs.contains(this) ) 
      fill(255, 0, 0);
    else if (clicked)
      fill( 200 );
    else 
    fill( 100 );

    rect(x, y, width, height);
    fill(0);
    text(label, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    label = newLabel;
  }
  public boolean isValid(int r, int c)
  {
    if (r>=0&&r<NUM_ROWS&&c>=0&&c<NUM_COLS)
      return true;
    return false;
  }
  public int countBombs(int row, int col)
  {
    int numBombs = 0;
    if(isValid(row, col+1)==true&&bombs.contains(buttons[row][col+1]))
    numBombs++;
    if(isValid(row, col-1)==true&&bombs.contains(buttons[row][col-1]))
    numBombs++;
    if(isValid(row+1, col)==true&&bombs.contains(buttons[row+1][col]))
    numBombs++;
    if(isValid(row-1, col)==true&&bombs.contains(buttons[row-1][col]))
    numBombs++;
    if(isValid(row+1, col+1)==true&&bombs.contains(buttons[row+1][col+1]))
    numBombs++;
    if(isValid(row+1, col-1)==true&&bombs.contains(buttons[row+1][col-1]))
    numBombs++;
    if(isValid(row-1, col+1)==true&&bombs.contains(buttons[row-1][col+1]))
    numBombs++;
    if(isValid(row-1, col-1)==true&&bombs.contains(buttons[row-1][col-1]))
    numBombs++;
    //for (int a=-1; a<2; a++) {
    //  for (int b=-1; b<2; b++) {
    //    if (bombs.contains(buttons[row+a][col+b]))
    //      numBombs++;
    //  }
    //}
    return numBombs;
  }
}