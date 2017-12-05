


int equipedWeapon = 2;

Gun AK47;

PImage [] MuzzleFlashes = new PImage[3];

void initGuns()
{
  AK47 = new Gun(-35, -10, "Weapons/AK47.png");

  for (int i=0; i<3; i++)
  {
    MuzzleFlashes[i] = loadImage("Weapons/MuzzleFlash"+i+".png");
  }

  strokeWeight(4);
  rectMode(CORNERS);
  stroke(#FFDE64);
}

void updateWeapon()
{
  AK47.rotation = atan((mouseY-mainPlayer.y - 65)/((cameraXpos+mouseX)-mainPlayer.x  - 25));
  if ((cameraXpos+mouseX)>mainPlayer.x)
    AK47.flipl = 1;
  else
    AK47.flipl = -1;
}

void mouseMoved()
{
  //updateWeapon();
}
void mouseDragged()
{
  //updateWeapon();
}

class Gun
{
  float x;
  float y;
  PImage gunTexture;

  int fireRate;
  int frameLastFired;
  int Damage;
  int firing;

  float rotation;

  int flipl;

  int MuzzleFlashRandomNumber;

  Gun(float x1, float y1, String TextureName)
  {
    x = x1;
    y = y1;
    gunTexture = loadImage(TextureName);

    fireRate = 2;
    Damage = 120;

    rotation = 0;
    flipl = 1;

    MuzzleFlashRandomNumber = 0;

    frameLastFired = frameCount;
  }

  void display()
  {
    updateWeapon();

    if (mousePressed && mouseButton==LEFT && frameCount-frameLastFired>fireRate)
    {
      frameLastFired = frameCount;

      firing = 1;

      MuzzleFlashRandomNumber = (int)random(3);
      
      float lineX1 = mainPlayer.x + 25;
      float lineY1 = mainPlayer.y + 65;
      float lineX2 = mainPlayer.x + 25 + 1000*cos(rotation)*flipl;
      float lineY2 = mainPlayer.y + 65 + 1000*sin(rotation)*flipl;
      
      boolean hitSomething = false;
      for (int i=0; i<goombaEnemies.size (); i++)
      {
        if (abs(mainPlayer.x-goombaEnemies.get(i).x)<1200)
        {
          //rect(goombaEnemies.get(i).x,goombaEnemies.get(i).y,goombaEnemies.get(i).x+50,goombaEnemies.get(i).y+50);
          
          if(SegmentIntersectRectangle(goombaEnemies.get(i).x,goombaEnemies.get(i).y,goombaEnemies.get(i).x+50,goombaEnemies.get(i).y+50,lineX1,lineY1,lineX2,lineY2))
          {
            //line(lineX1,lineY1,goombaEnemies.get(i).x+25,goombaEnemies.get(i).y+25);
            if (goombaEnemies.get(i).damage(60))
            {
              goombaEnemies.remove(i);
              score += 100;
              i--;
              continue;
            }
            hitSomething = true;
          }
        }
      }
      if(!hitSomething)
      {
        //line(lineX1,lineY1,lineX2,lineY2);
      }
    }

    pushMatrix();

    translate(mainPlayer.x + 25, mainPlayer.y + 65);

    rotate(rotation);

    scale(flipl, 1);

    if (firing>0)
    {
      firing--;

      line(0, 0, 1000, 0);

      pushMatrix();
      scale(0.25, 0.25);
      image(MuzzleFlashes[MuzzleFlashRandomNumber], 150, -MuzzleFlashes[MuzzleFlashRandomNumber].height/2);
      popMatrix();
    }

    translate(x, y);

    scale(0.5, 0.5);

    image(gunTexture, 0, 0);

    popMatrix();
  }
}

