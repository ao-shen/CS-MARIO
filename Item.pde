


class Item
{
  float x;
  float y;
  float xvel;
  float yvel;
  
  boolean onGround;
  
  int itemType;

  Animation movingAnimation;

  Item(int x1, int y1, int t1)
  {
    itemType = t1;
    
    int s1 = 0;
    
    if(itemType == 1)
    {
      movingAnimation = new Animation("Items/SuperMushroom/", "gif", 1, 100);
      s1 = 5;
    }
    else if(itemType == 2)
    {
      movingAnimation = new Animation("Items/FireFlower/", "gif", 2, 3);
    }
    else if(itemType == 3)
    {
      movingAnimation = new Animation("Items/CapeFeather/", "gif", 1, 100);
    }
    else if(itemType == 4)
    {
      movingAnimation = new Animation("Items/SuperStar/", "gif", 4, 2);
      s1 = 7;
    }
    else
    {
      movingAnimation = new Animation("Items/SuperMushroom/", "gif", 1, 100);
    }
    
    x = x1;
    y = y1;
    xvel = s1;
    yvel = 20;
    
    onGround = false;
  }
  
  void update()
  {
    if (!onGround)
    {
      yvel -= 3.5;
    }
    yvel = constrain(yvel, -60, 60);

    x += xvel;
    y -= yvel;

    if ((int)(x/gridSize-1)<0||(int)(x/gridSize+2)>=1280||(int)(y/gridSize-1)<0||(int)(y/gridSize+4)>=100)
      return;

    float boundingBoxLeft = x;
    float boundingBoxRight = x+2*gridSize;
    float boundingBoxTop = y;
    float boundingBoxBottom = y+2*gridSize;

    if (yvel<=0)
    {
      onGround = false;
      if (gridAtLocation(boundingBoxLeft, boundingBoxBottom)==1) {
        //drawGrid(gridify(boundingBoxLeft),gridify(boundingBoxBottom));
        yvel = 0;
        y = gridify(boundingBoxBottom)*gridSize-2*gridSize;
        onGround = true;
      } else if (gridAtLocation((boundingBoxLeft+boundingBoxRight)/2, boundingBoxBottom)==1) {
        //drawGrid(gridify((boundingBoxLeft+boundingBoxRight)/2),gridify(boundingBoxBottom));
        yvel = 0;
        y = gridify(boundingBoxBottom)*gridSize-2*gridSize;
        onGround = true;
      } else if (gridAtLocation(boundingBoxRight, boundingBoxBottom)==1) {
        //drawGrid(gridify(boundingBoxRight),gridify(boundingBoxBottom));
        yvel = 0;
        y = gridify(boundingBoxBottom)*gridSize-2*gridSize;
        onGround = true;
      }
      if (gridAtLocation(boundingBoxLeft, boundingBoxBottom-gridSize)==1) {
        //drawGrid(gridify(boundingBoxLeft),gridify(boundingBoxBottom)-1);
        yvel = 0;
        y = gridify(boundingBoxBottom)*gridSize-3*gridSize;
        onGround = true;
      } else if (gridAtLocation((boundingBoxLeft+boundingBoxRight)/2, boundingBoxBottom-gridSize)==1) {
        //drawGrid(gridify((boundingBoxLeft+boundingBoxRight)/2),gridify(boundingBoxBottom)-1);
        yvel = 0;
        y = gridify(boundingBoxBottom)*gridSize-3*gridSize;
        onGround = true;
      } else if (gridAtLocation(boundingBoxRight, boundingBoxBottom-gridSize)==1) {
        //drawGrid(gridify(boundingBoxRight),gridify(boundingBoxBottom)-1);
        yvel = 0;
        y = gridify(boundingBoxBottom)*gridSize-3*gridSize;
        onGround = true;
      }
    }
    
    boundingBoxTop = y;
    boundingBoxBottom = y+2*gridSize;
    
    if (xvel<0)
    {
      for (int i=0; i<2; i++)
      {
        if (gridAtLocation(boundingBoxLeft, boundingBoxTop+i*gridSize)==1)
        {
          //drawGrid(gridify(boundingBoxLeft),gridify(boundingBoxTop)+i);
          xvel *= -1;
          x = (gridify(boundingBoxLeft)+1)*gridSize+boundingBoxWidth;
          break;
        }
      }
    }
    if (xvel>0)
    {
      for (int i=0; i<2; i++)
      {
        if (gridAtLocation(boundingBoxRight, boundingBoxTop+i*gridSize)==1)
        {
          //drawGrid(gridify(boundingBoxRight),gridify(boundingBoxTop)+i);
          xvel *= -1;
          x = (gridify(boundingBoxRight)-2)*gridSize-boundingBoxWidth;
          break;
        }
      }
    }
  }
  
  void display()
  {
    pushMatrix();

    translate(x, y);

    movingAnimation.display(0, 5);
      
    popMatrix();
  }
}
