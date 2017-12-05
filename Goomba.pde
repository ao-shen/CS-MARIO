class Goomba
{
  float x;
  float y;
  int facingDirection;
  float xvel;
  float yvel;
  
  float pathLeft;
  float pathRight;
  
  boolean onGround;
  
  int health;

  Animation walkAnimation;

  Goomba(int x1, int y1)
  {
    reset(x1,y1);
    
    pathLeft = x-20;
    pathRight = x+20;

    walkAnimation = new Animation("GoombaWalk/", "gif", 2, 3);
  }
  
  void reset(int x1, int y1)
  {
    x = x1;
    y = y1;
    xvel = 3;
    yvel = 0;
    onGround = false;
    
    health = 100;
    
    facingDirection = RIGHT;
    
    facingDirection = RIGHT;
  }
  
  void setPath(int l1, int r1)
  {
    pathLeft = l1;
    pathRight = r1;
  }
  
  void jump()
  {
    if(yvel==0&&onGround)
    {
      yvel = 40;
      onGround = false;
    }
  }
  
  boolean damage(int d1)
  {
    health -= d1;
    if(health<=0)
    {
      Effect newEffect = new Effect(3,(int)x-25,(int)y);
      effects.add(newEffect);
      
      return true;
    }
    return false;
  }
  
  void update()
  {
    x += xvel;
    
    if(x<pathLeft)
    {
      x = pathLeft;
      xvel = abs(xvel);
    }
    else if(x>pathRight)
    {
      x = pathRight;
      xvel = -abs(xvel);
    }
    
    y -= yvel;
  }

  void display()
  {
    pushMatrix();
    
    translate(0,0);
    translate(x,y);
    
    scale(0.6,0.6);

    if(facingDirection == LEFT)
    {
      translate(walkAnimation.images[0].width,0);
      scale(-1,1);
    }
    walkAnimation.display(0, 0);

    
    popMatrix();
  }
}
