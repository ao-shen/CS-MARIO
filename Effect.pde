
Animation blockBreak1;
Animation blockBounce1;
Animation GoombaDying;

PImage [] quadTextures = new PImage[3];

void initEffects()
{
  blockBreak1 = new Animation("Animations/MarioBlockBreak1/","png",33,1);
  blockBounce1 = new Animation("Animations/MarioBlockBounce/","png",10,1);
  GoombaDying = new Animation("Animations/GoombaDying/","png",50,1);
  
  quadTextures[0] = loadImage("Blocks/Block1.gif");
  quadTextures[1] = loadImage("Blocks/Block4.gif");
  quadTextures[2] = loadImage("Blocks/Block100.gif");
}

class Effect {
  int x;
  int y;
  int xvel;
  int yvel;
  
  int animationId;
  
  int frame;
  
  Effect(int a1, int x1, int y1)
  {
    animationId = a1;
    x = x1;
    y = y1;
  }
  
  void display() {
    
    if(animationId==1)
    {
      blockBreak1.displayFrame(frame, x, y);
    }
    else if(animationId==2)
    {
      blockBounce1.displayFrame(frame, x, y);
    }
    else if(animationId==3)
    {
      GoombaDying.displayFrame(frame, x, y);
    }
    frame++;
  }
  
  boolean doneRendering()
  {
    int iC = 0;
    if(animationId==1)
    {
      iC = blockBreak1.imageCount;
    }
    else if(animationId==2)
    {
      iC = blockBounce1.imageCount;
    }
    else if(animationId==3)
    {
      iC = GoombaDying.imageCount;
    }
    return (frame+1 == iC);
  }
}
