PImage [] img = new PImage[9];

float cameraXpos = 0;
float cameraXvel = 0;

int time;

int score = 0;
int FinalScore = 0;

MarioActions mainPlayer;

Animation coinSpin;

ArrayList<Effect> effects = new ArrayList<Effect>();

ArrayList<PVector> coins = new ArrayList<PVector>();
ArrayList<Item> items = new ArrayList<Item>();

float imgScale = 1;

ArrayList<PVector> distroyedBlocks = new ArrayList<PVector>();

ArrayList<QuadBlock> distroyedQuadBlocks = new ArrayList<QuadBlock>();

ArrayList<Goomba> goombaEnemies = new ArrayList<Goomba>();

char [][] grid = new char[1280][100];
int gridHeight = 0;
int gridWidth = 0;
int gridSize = 25;

boolean [] keyHeldDown = new boolean[255];

void setup() {
  size(1280, 720, P2D);
  for(int i=0;i<9;i++)
  {
    img[i] = loadImage("map/LevelPiece"+(i+1)+".png");
  }
  
  coinSpin = new Animation("Coin/", "gif", 4, 2);
  
  PFont font;
  // The font must be located in the sketch's 
  // "data" directory to load successfully
  font = createFont("Super-Mario-World.ttf",32);
  textFont(font, 32);
  
  //println(img.length);
  
  noStroke();
  frameRate(40);

  gridWidth = (int)(width*imgScale);
  gridHeight = (int)(height*imgScale);

  for (int i=0; i<gridWidth/gridSize; i++)
  {
    for (int j=0; j<gridHeight/gridSize; j++)
    {
      grid[i][j] = 0;
    }
  }
  
  initEffects();
  initGuns();
  
  loadLevel();
  
  mainPlayer = new MarioActions(500,525);
}

void loadLevel()
{
  score = 0;
  FinalScore = 0;
  time = 230;
  
  items.clear();
  
  String[] MarioLevelFile = loadStrings("map/MarioLevel1.txt");
  for (int i=0; i<MarioLevelFile.length; i++)
  {
    String[] line = split(MarioLevelFile[i],':');
    int col = int(line[0]);
    int [] blocks = int(split(line[1],','));
    for (int j=0; j<blocks.length-1; j++)
    {
      grid[col][blocks[j]] = 1;
    }
  }
  
  distroyedBlocks.clear();
  distroyedQuadBlocks.clear();
  String[] QuadBlocksFile = loadStrings("map/QuadBlocks.txt");
  for (int i=0; i<QuadBlocksFile.length; i++)
  {
    String[] line = split(QuadBlocksFile[i],':');
    int QuadBlockX = int(line[0]);
    int QuadBlockY = int(line[1]);
    int QuadBlockType = int(line[2]);
    distroyedQuadBlocks.add(new QuadBlock(QuadBlockX,QuadBlockY,QuadBlockType));
  }
  
  goombaEnemies.clear();
  String[] GoombaFile = loadStrings("map/GoombaRanges.txt");
  for (int i=0; i<GoombaFile.length; i++)
  {
    String[] line = split(GoombaFile[i],':');
    int GoombaX = int(line[0]);
    int GoombaY = int(line[1]);
    int rangeL = int(line[2]);
    int rangeR = int(line[3]);
    
    Goomba newGoomba = new Goomba(GoombaX,GoombaY);
    newGoomba.setPath(rangeL,rangeR);
    goombaEnemies.add(newGoomba);
  }
  
  coins.clear();
  String[] CoinFile = loadStrings("map/Coins.txt");
  for (int i=0; i<CoinFile.length; i++)
  {
    String[] line = split(CoinFile[i],':');
    int CoinX = int(line[0]);
    int CoinY = int(line[1]);
    
    PVector newCoin = new PVector(CoinX,CoinY);
    coins.add(newCoin);
  }
}

void keyPressed()
{
  if(keyCode=='G'&&keyHeldDown['G']==false)
  {
    int x1 = quadify(mouseX+cameraXpos)*gridSize;
    int y1 = (quadify(mouseY+gridSize)-1)*gridSize;
    println(x1 + ":" + y1);
    
    Effect newEffect = new Effect(1,x1-120,y1-50);
    effects.add(newEffect);
  }
  else if(keyCode=='1'&&keyHeldDown['1']==false)
  {
    equipedWeapon = 1;
  }
  else if(keyCode=='2'&&keyHeldDown['2']==false)
  {
    equipedWeapon = 2;
  }
  
  if(keyCode=='B'&&keyHeldDown['B']==false)
  {
    println((gridify((int)(mouseX+cameraXpos))*gridSize) + ":" + (gridify((int)(mouseY))*gridSize));
  }
  
  keyHeldDown[keyCode] = true;
  
  if(keyCode=='R')
  {
    mainPlayer.resetMario(500,525);
    
    loadLevel();
  }
  else if (keyCode=='H')
  {
    for (int i=0; i<gridWidth/gridSize; i++)
    {
      String str = i + ":";
      int count = 0;;
      for (int j=0; j<gridHeight/gridSize; j++)
      {
        if (grid[i][j]==1)
        {
          count++;
          str += j + ",";
        }
      }
      if(count!=0)
        println(str);
    }
  }
}

void keyReleased()
{
  keyHeldDown[keyCode] = false;
}

void mousePressed()
{
  /*if(mouseButton==LEFT)
  {
    grid[(int)((cameraXpos+mouseX)/gridSize)][(int)(mouseY/gridSize)] = 1;
  }
  else if(mouseButton==RIGHT)
  {
    grid[(int)((cameraXpos+mouseX)/gridSize)][(int)(mouseY/gridSize)] = 0;
    distroyedBlocks.add(new PVector((int)((cameraXpos+mouseX)/gridSize)*gridSize,(int)(mouseY/gridSize)*gridSize));
    //println(distroyedBlocks.size());
  }*/
}

void draw() {
  background(#5d94fb);

  cameraXpos += cameraXvel;
  if(cameraXpos<0)
    cameraXpos = 0;
  if(cameraXpos>9295)
    cameraXpos = 9295;
    
  cameraXvel = (mainPlayer.x-(cameraXpos+width/2))/10;
  //println((mainPlayer.x-(cameraXpos+width/2)));
  
  if (keyHeldDown['W'] || keyHeldDown[' '])
  {
    mainPlayer.jump();
  }
  pushMatrix();
  
  translate(-cameraXpos, 0);

  pushMatrix();

  scale(imgScale);
  
  int imageNumber1 = (int)(cameraXpos/(1280));
  int imageNumber2 = (int)(cameraXpos/(1280))+1;
  
  if(imageNumber1<=9&&imageNumber1>=0)
    image(img[imageNumber1], imageNumber1*1280, 0);
  if(imageNumber2<=9&&imageNumber2>=0)
    image(img[imageNumber2], imageNumber2*1280, 0);

  popMatrix();
  
  fill(#5d94fb);
  for (int i=0; i<distroyedQuadBlocks.size(); i++)
  {
    if(abs(mainPlayer.x-distroyedQuadBlocks.get(i).x)<1200)
    {
      distroyedQuadBlocks.get(i).display();
    }
  }
  
  for (int i=0; i<distroyedBlocks.size(); i++)
  {
    if(abs(mainPlayer.x-distroyedBlocks.get(i).x)<1200)
    {
      rect(distroyedBlocks.get(i).x, distroyedBlocks.get(i).y, gridSize, gridSize);
    }
  }
  
  for (int i=0; i<coins.size(); i++)
  {
    if(abs(mainPlayer.x-coins.get(i).x)<1200)
    {
      coinSpin.displayStill(coins.get(i).x, coins.get(i).y);
      
      if(abs(mainPlayer.x-coins.get(i).x)<2*gridSize&&coins.get(i).y-mainPlayer.y>=-23&&coins.get(i).y-mainPlayer.y<=112)
      {
        coins.remove(i);
        score += 100;
        i--;
        continue;
      }
    }
  }
  coinSpin.increaseFrame();
  
  for (int i=0; i<items.size(); i++)
  {
    if(abs(mainPlayer.x-items.get(i).x)<1200)
    {
      items.get(i).update();
      items.get(i).display();
      if(abs(mainPlayer.x-items.get(i).x)<2*gridSize&&items.get(i).y-mainPlayer.y>=-23&&items.get(i).y-mainPlayer.y<=112)
      {
        items.remove(i);
        score += 300;
        i--;
        continue;
      }
    }
  }
  
  boolean bounce = false;
  for (int i=0; i<goombaEnemies.size(); i++)
  {
    if(abs(mainPlayer.x-goombaEnemies.get(i).x)<1200)
    {
      if(abs(mainPlayer.x-goombaEnemies.get(i).x)<2*gridSize&&goombaEnemies.get(i).y-mainPlayer.y>=-23&&goombaEnemies.get(i).y-mainPlayer.y<=112)
      {
        if(goombaEnemies.get(i).y-mainPlayer.y>=25&&mainPlayer.yvel<0)
        {
          bounce = true;
          
          if(goombaEnemies.get(i).damage(120))
          {
            goombaEnemies.remove(i);
            score += 100;
            i--;
            continue;
          }
        }
        else
        {
          mainPlayer.health -= 100;
        }
      }
      goombaEnemies.get(i).display();
      goombaEnemies.get(i).update();
    }
  }
  if(bounce)
    mainPlayer.yvel = 30;
  
  for (int i=0; i<effects.size(); i++)
  {
    effects.get(i).display();
    if(effects.get(i).doneRendering())
    {
      effects.remove(i);
      score += 100;
      i--;
      continue;
    }
  }
 
  if(FinalScore==0) 
  {
    mainPlayer.update();
    mainPlayer.display();
    if(equipedWeapon == 1)
    {
      AK47.display();
    }
  }
  
  popMatrix();
  
  fill(255);
  text(nf(score,13),width-450,70);
  
  text("Time " + nf(time,3),70,70);
  
  if(FinalScore==0) 
  {
    if(frameCount%40==0)
    {
      time--;
      if(time<0)
        mainPlayer.health -= 100;
    }
    if(mainPlayer.x>=9925)
    {
      FinalScore = score + time*13;
      score = score + time*13;
    }
  }
  
  
}

