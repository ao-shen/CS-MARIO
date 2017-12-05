
int gridAtLocation(float x1, float y1)
{
  return (int)(grid[(int)(x1/gridSize)][(int)(y1/gridSize)]);
}

int gridify(float x1)
{
  return (int)(x1/gridSize);
}

int quadify(float x1)
{
  return (int)(gridify(x1)/2)*2;
}

void drawGrid(int i1, int j1)
{
  fill(255, 255, 0);
  rect(i1*gridSize, j1*gridSize, gridSize, gridSize);
}

int lowerBoundQuad(int x1, int low, int high)
{
  while (low <= high) 
  {
    int mid = (low + high) / 2;
    long midVal = distroyedQuadBlocks.get(mid).x;

    if (midVal < x1)
      low = mid + 1;
    else if (midVal > x1)
      high = mid - 1;
    else if (low != mid) //Equal but range is not fully scanned
        high = mid;
    else
      return mid; // key found
  }
  return -1;
}

void breakQuadBlock(float x1, float y1)
{
  int gx = quadify(x1);
  int gy = quadify(y1)-1;

  int i = 0;
  i = lowerBoundQuad(gx*gridSize, 0, distroyedQuadBlocks.size()-1);

  if (i!=-1)
  {
    for (; i<distroyedQuadBlocks.size (); i++)
    {
      if (distroyedQuadBlocks.get(i).x != gx*gridSize)
      {
        i = distroyedQuadBlocks.size();
        break;
      }
      println(distroyedQuadBlocks.get(i).y);
      if (distroyedQuadBlocks.get(i).y == gy*gridSize)
      {
        if (distroyedQuadBlocks.get(i).blockType == 1)
        {
          distroyedQuadBlocks.get(i).blockType = 0;
          score += 100;
          Effect newEffect = new Effect(1,gx*gridSize-120,gy*gridSize-50-25);
          effects.add(newEffect);
        } 
        else if (distroyedQuadBlocks.get(i).blockType == 2)
        {
          distroyedQuadBlocks.get(i).blockType = 4;
          score += 100;
        } 
        else if (distroyedQuadBlocks.get(i).blockType >= 100)
        {
          if(distroyedQuadBlocks.get(i).blockType==100)
          {
            PVector newCoin = new PVector(distroyedQuadBlocks.get(i).x,distroyedQuadBlocks.get(i).y-1);
            coins.add(newCoin);
          }
          else
          {
            Item newItem = new Item(distroyedQuadBlocks.get(i).x,distroyedQuadBlocks.get(i).y-2*gridSize,distroyedQuadBlocks.get(i).blockType-100);
            items.add(newItem);
          }
          distroyedQuadBlocks.get(i).blockType = 4;
          score += 300;
          Effect newEffect = new Effect(2,gx*gridSize-25,gy*gridSize-50);
          effects.add(newEffect);
          distroyedQuadBlocks.get(i).disappearTime = 9;
        } 
        else if (distroyedQuadBlocks.get(i).blockType == 4)
        {
          return;
        }
        break;
      }
    }
    if (i == distroyedQuadBlocks.size())
      return;
  } else
  {
    return;
  }

  if (distroyedQuadBlocks.get(i).blockType == 0)
  {
    for (int k=0; k<2; k++)
    {
      for (int j=0; j<2; j++)
      {
        if (gx+k==constrain(gx+k, 0, 1279)&&gy+j==constrain(gy+j, 0, 99))
        {
          grid[gx+k][gy+j] = 0;
        }
      }
    }
  }
}

float boundingBoxWidth = -7;
float boundingBoxHeight = -17;
boolean movingLeftOrRight = false;

class MarioActions
{
  float x;
  float y;
  int facingDirection;
  float xvel;
  float yvel;

  PImage stillImg;
  PImage jumpImg;
  PImage fallImg;

  int livingState;

  int health;

  boolean onGround;

  Animation walkAnimation;
  Animation explodeAnimation;

  MarioActions(int x1, int y1)
  {
    resetMario(x1, y1);

    walkAnimation = new Animation("MarioWalk/", "gif", 4, 2);
    explodeAnimation = new Animation("MarioExplosion/", "gif", 5, 3);

    stillImg = loadImage("MarioStill.gif");
    jumpImg = loadImage("MarioJump.gif");
    fallImg = loadImage("MarioFall.gif");

    differenceBetweenTheSizeOfTheStillImgAndTheWalkingImg = walkAnimation.images[0].width - stillImg.width;
  }

  void resetMario(int x1, int y1)
  {
    x = x1;
    y = y1;
    xvel = 0;
    yvel = 0;
    onGround = false;

    livingState = 0;

    health = 100;

    facingDirection = RIGHT;
  }

  void jump()
  {
    if (yvel==0&&onGround)
    {
      yvel = 40;
      onGround = false;
    }
  }

  void update()
  {
    if (livingState==1)
    {
      return;
    }

    if (health<=0)
    {
      explodeAnimation.resetFrame();
      livingState = 1;
      //reset(500,525);
    }

    movingLeftOrRight = false;
    if (keyHeldDown['A'])
    {
      xvel -= 3;
      facingDirection = LEFT;
      movingLeftOrRight = true;
    }
    if (keyHeldDown['D'])
    {
      xvel += 3;
      facingDirection = RIGHT;
      movingLeftOrRight = true;
    }
    
    if(equipedWeapon == 1)
    {
      xvel = constrain(xvel, -7, 7);
    }
    else
    {
      xvel = constrain(xvel, -15, 15);
    }
    if (movingLeftOrRight==false)
    {
      xvel *= 0.6;
    }
    if (!onGround)
    {
      yvel -= 3.5;
    }
    yvel = constrain(yvel, -60, 60);

    x += xvel;
    y -= yvel;

    if ((int)(x/gridSize-1)<0||(int)(x/gridSize+2)>=1280||(int)(y/gridSize-1)<0||(int)(y/gridSize+4)>=100)
      return;

    float boundingBoxLeft = x-boundingBoxWidth;
    float boundingBoxRight = x+2*gridSize+boundingBoxWidth;
    float boundingBoxTop = y-boundingBoxHeight;
    float boundingBoxBottom = y+4*gridSize;

    if (xvel<0)
    {
      for (int i=0; i<4; i++)
      {
        if (gridAtLocation(boundingBoxLeft, boundingBoxTop+i*gridSize)==1)
        {
          //drawGrid(gridify(boundingBoxLeft),gridify(boundingBoxTop)+i);
          xvel = 0;
          x = (gridify(boundingBoxLeft)+1)*gridSize+boundingBoxWidth;
        }
      }
    } else if (xvel>0)
    {
      for (int i=0; i<4; i++)
      {
        if (gridAtLocation(boundingBoxRight, boundingBoxTop+i*gridSize)==1)
        {
          //drawGrid(gridify(boundingBoxRight),gridify(boundingBoxTop)+i);
          xvel = 0;
          x = (gridify(boundingBoxRight)-2)*gridSize-boundingBoxWidth;
        }
      }
    }

    boundingBoxLeft = x-boundingBoxWidth;
    boundingBoxRight = x+2*gridSize+boundingBoxWidth-1;

    if (yvel<=0)
    {
      onGround = false;
      if (gridAtLocation(boundingBoxLeft, boundingBoxBottom)==1) {
        //drawGrid(gridify(boundingBoxLeft),gridify(boundingBoxBottom));
        yvel = 0;
        y = gridify(boundingBoxBottom)*gridSize-4*gridSize;
        onGround = true;
      } else if (gridAtLocation((boundingBoxLeft+boundingBoxRight)/2, boundingBoxBottom)==1) {
        //drawGrid(gridify((boundingBoxLeft+boundingBoxRight)/2),gridify(boundingBoxBottom));
        yvel = 0;
        y = gridify(boundingBoxBottom)*gridSize-4*gridSize;
        onGround = true;
      } else if (gridAtLocation(boundingBoxRight, boundingBoxBottom)==1) {
        //drawGrid(gridify(boundingBoxRight),gridify(boundingBoxBottom));
        yvel = 0;
        y = gridify(boundingBoxBottom)*gridSize-4*gridSize;
        onGround = true;
      }
      if (gridAtLocation(boundingBoxLeft, boundingBoxBottom-gridSize)==1) {
        //drawGrid(gridify(boundingBoxLeft),gridify(boundingBoxBottom)-1);
        yvel = 0;
        y = gridify(boundingBoxBottom)*gridSize-5*gridSize;
        onGround = true;
      } else if (gridAtLocation((boundingBoxLeft+boundingBoxRight)/2, boundingBoxBottom-gridSize)==1) {
        //drawGrid(gridify((boundingBoxLeft+boundingBoxRight)/2),gridify(boundingBoxBottom)-1);
        yvel = 0;
        y = gridify(boundingBoxBottom)*gridSize-5*gridSize;
        onGround = true;
      } else if (gridAtLocation(boundingBoxRight, boundingBoxBottom-gridSize)==1) {
        //drawGrid(gridify(boundingBoxRight),gridify(boundingBoxBottom)-1);
        yvel = 0;
        y = gridify(boundingBoxBottom)*gridSize-5*gridSize;
        onGround = true;
      }
    } else
    {

      if (gridAtLocation((boundingBoxLeft+boundingBoxRight)/2, boundingBoxTop)==1) {
        //drawGrid(gridify((boundingBoxLeft+boundingBoxRight)/2),gridify(boundingBoxTop));
        breakQuadBlock((boundingBoxLeft+boundingBoxRight)/2, boundingBoxTop);
        yvel = 0;
        y = gridify(boundingBoxTop+gridSize)*gridSize+boundingBoxHeight;
      } else if (gridAtLocation(boundingBoxLeft, boundingBoxTop)==1) {
        //drawGrid(gridify(boundingBoxLeft),gridify(boundingBoxTop));
        breakQuadBlock(boundingBoxLeft, boundingBoxTop);
        yvel = 0;
        y = gridify(boundingBoxTop+gridSize)*gridSize+boundingBoxHeight;
      } else if (gridAtLocation(boundingBoxRight, boundingBoxTop)==1) {
        //drawGrid(gridify(boundingBoxRight),gridify(boundingBoxTop));
        breakQuadBlock(boundingBoxRight, boundingBoxTop);
        yvel = 0;
        y = gridify(boundingBoxTop+gridSize)*gridSize+boundingBoxHeight;
      }
    }

    /*fill(0,255,255);
     rectMode(CORNERS);
     rect(boundingBoxLeft,boundingBoxTop,boundingBoxRight,boundingBoxBottom);
     rectMode(CORNER);*/

  }

  void display()
  {
    pushMatrix();

    translate(-2, 8);
    translate(x, y);

    scale(0.78, 0.78);

    if (facingDirection == LEFT)
    {
      if (movingLeftOrRight==false&&onGround)
      {
        translate(stillImg.width, 0);
      } else
      {
        translate(walkAnimation.images[0].width, 0);
      }
      scale(-1, 1);
    } else
    {
      if (movingLeftOrRight||!onGround)
      {
        translate(-differenceBetweenTheSizeOfTheStillImgAndTheWalkingImg, 0);
      }
    }

    if (livingState==1)
    {
      explodeAnimation.display(0, 5);
      if (explodeAnimation.doneRendering())
      {
        resetMario(500, 525);
        loadLevel();
      }
    } else if (!onGround)
    {
      if (yvel<0)
      {
        image(fallImg, 0, 5);
      } else
      {
        image(jumpImg, 0, 5);
      }
    } else if (movingLeftOrRight==false)
    {
      image(stillImg, 0, 5);
    } else
    {
      walkAnimation.display(0, 5);
    }

    popMatrix();
  }
}

int differenceBetweenTheSizeOfTheStillImgAndTheWalkingImg = 0;

