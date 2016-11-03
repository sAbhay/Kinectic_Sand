class KinectTracker
{
  int threshold = 500;

  PVector pos;
  PVector lerpedPos;

  int depth[];

  PImage img;

  KinectTracker()
  {
    kinect.initDepth();

    kinect.initVideo();
    kinect.enableMirror(true);

    img = createImage(kinect.width, kinect.height, ARGB);

    pos = new PVector(0, 0);
    lerpedPos = new PVector(0, 0);
  }

  void track()
  {
    depth = kinect.getRawDepth(); // assigns a depth value between 0 and 2048 for every pixel on the screen, as determined by the kinect's depth tracker

    if (depth == null) return; // to prevent a nullPointerException

    float sumX = 0;
    float sumY = 0;
    float count = 0;

    for (int x = 0; x < kinect.width; x++)
    {
      for (int y = 0; y < kinect.height; y++)
      {
        int index = x + y*kinect.width;
        int rawDepth = depth[index];

        if (rawDepth <= threshold)
        {
          sumX += x; // adds x value of pixel within threshold
          sumY += y; // adds y value of pixel within threshold
          count++; // adds 1 to number of points within threshold
        }
      }
    }

    if (count != 0) // otherwise, error - divide by 0 exception
    {
      pos = new PVector((sumX/count)*width/kinect.width, (sumY/count)*height/kinect.height); // average x and y values of all pixels within the threshold scaled to screen size
      //pos = new PVector(sumX/count, sumY/count); // average x and y values of all pixels within the threshold
    }

    lerpedPos.x = PApplet.lerp(lerpedPos.x, pos.x, 0.3f); // moves the x value by an interval so that it is not jittery
    lerpedPos.y = PApplet.lerp(lerpedPos.y, pos.y, 0.3f); // moves the y value by an interval so that it is not jittery
  }

  void display()
  {
    PImage backImg = kinect.getVideoImage();
    img.loadPixels();

    for (int x = 0; x < kinect.width; x++)
    {
      for (int y = 0; y < kinect.height; y++)
      {
        int index = x + y*kinect.width;
        int imgIndex = x + y*img.width;
        int rawDepth = depth[index];

        if (rawDepth < threshold)
        {
          img.pixels[imgIndex] = color(0, 255, 255);
        } else
        {
          img.pixels[imgIndex] = color(0, 0);
        }
      }
    }

    img.updatePixels();

    image(img, 0, 0, width, height);
  }

  PVector getPos()
  {
    return pos;
  }

  PVector getLerpedPos()
  {
    return lerpedPos;
  }
}