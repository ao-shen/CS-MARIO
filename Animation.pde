// Class for animating a sequence of GIFs

class Animation {
  PImage[] images;
  int imageCount;
  int frame;
  int speed;
  
  Animation(String imagePrefix, String imageSuffix, int count, int s1) {
    imageCount = count;
    images = new PImage[imageCount];
    speed = s1;

    for (int i = 0; i < imageCount; i++) {
      // Use nf() to number format 'i' into four digits
      String filename = imagePrefix + nf(i, 4) + "." + imageSuffix;
      images[i] = loadImage(filename);
    }
  }
  
  void displayStill(float xpos, float ypos) {
    image(images[frame], xpos, ypos);
  }
  
  void displayFrame(int f, float xpos, float ypos) {
    image(images[f], xpos, ypos);
  }
  
  void increaseFrame()
  {
    if(frameCount%speed==0)
      frame = (frame+1) % imageCount;
  }
  
  void resetFrame()
  {
    frame = 0;
  }
  
  boolean doneRendering()
  {
    return (frame+1 == imageCount);
  }

  void display(float xpos, float ypos) {
    if(frameCount%speed==0)
      frame = (frame+1) % imageCount;
    image(images[frame], xpos, ypos);
  }
  
  int getWidth() {
    return images[0].width;
  }
}
