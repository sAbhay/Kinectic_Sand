import org.openkinect.freenect.*;
import org.openkinect.freenect2.*;
import org.openkinect.processing.*;
import org.openkinect.tests.*;

import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.dynamics.*;

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

Box2DProcessing box2d;

ArrayList<Sand> sand = new ArrayList<Sand>();
Boundary[] boundary = new Boundary[3];

int h, s, b;
int devices;
boolean colourSelectorShowing;

Kinect kinect;
KinectTracker tracker;

SettingsMenu menu;

Button settings;
boolean settingsShowing = false;

boolean kinectControl = false;

void setup()
{
  noStroke();
  fullScreen(P3D);

  kinect = new Kinect(this);
  tracker = new KinectTracker();

  colorMode(HSB, 255, 255, 255);

  rectMode(CENTER);
  textAlign(CENTER);

  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0, -15);
  box2d.setContinuousPhysics(true);

  boundary[0] = new Boundary(-2, height/2, 2, height, color(255));
  boundary[1] = new Boundary(width/2, height - 1, width, 2, color(255));
  boundary[2] = new Boundary(width - 1, height/2, 2, height, color(255));

  minim = new Minim(this);
  music = minim.getLineOut();
  recorder = minim.createRecorder(music, "Sweet Tunez.wav");
  time = millis();

  menu = new SettingsMenu();
  settings = new Button(100, 100, 60, 60, "Settings", settingsShowing);
}

void draw()
{
  if(selectedOctave < 1) selectedOctave = 1;
  if(selectedOctave > 5) selectedOctave = 5;
  
  if (time < millis())
  {
    GenerateMusic(60);
    time += 10000;

    h = (int) random(255);
    s = 255;
    b = 255;
  }

  box2d.step();

  background(255);

  for (int i = 0; i < boundary.length; i++)
  {
    boundary[i].display();
  }

  if (kinectControl)
  {
    tracker.track();
    tracker.display();

    PVector v1 = tracker.getPos();
    PVector v2 = tracker.getLerpedPos();
    fill(0, 128, 255);
    ellipse(v1.x, v1.y, 5, 5);

    fill(128, 255, 0);
    ellipse(v2.x, v2.y, 5, 5);

    sand.add(new Sand(v1.x, v1.y, 10, 10, color(h, s, b)));
  } else
  {
    sand.add(new Sand(mouseX, mouseY, 10, 10, color(h, s, b)));
  }

  for (int i = 0; i < sand.size(); i++)
  {
    sand.get(i).display();
  }

  if (colourSelectorShowing)
  {
    colourSelector();
  }
}

void colourSelector()
{
  for (int i = 0; i < 256; i++)
  {
    for (int j = 0; j < 256; j++)
    {
      fill(i, j, 255);
      ellipse(i * width/255, j * height/(2*255), 2 * width/255, 2 * height/255); 

      fill(i, 255, 255-j);
      ellipse(i * width/255, j * height/(2*255) + height/2, 2 * width/255, 2 * height/255);
    }
  }
}

void mouseClicked()
{
  menu.track();
  settings.change();
}

void mouseReleased()
{
  if (colourSelectorShowing)
  {
    if (mouseY <= height/2)
    {
      h = mouseX/(width/360);
      s = 2 * mouseY/(height/255);
      b = 255;
    } else if (mouseY >= height/2)
    {
      h = mouseX/(width/360);
      s = 255;
      b = 2 * mouseY/(height/255);
    }
  }
}

void keyPressed()
{
  if (key == ' ')
  {
    if (colourSelectorShowing) 
    {
      colourSelectorShowing = false;
    } else if (!colourSelectorShowing) 
    {
      colourSelectorShowing = true;
    }
  }

  if (key == 'r')
  {
    if (recorder.isRecording())
    {
      recorder.endRecord(); 
      println("Recorded.");
    } else
    {
      recorder.beginRecord();
    }
  }
  if (key == 'c')
  {
    if (chords == false)
    {
      chords = true;
    } else
    {
      chords = false;
    }
  } 

  if (key == 'z')
  {
    recorder.save();
    println("Saved.");
  }

  if (key == BACKSPACE)
  {
    for (Sand s : sand)
    {
      s.killBody();
    }
    sand.clear();
  }

  if (key == 'k')
  {
    if (kinectControl) 
    {
      kinectControl = false;
    } else if (!kinectControl) 
    {
      kinectControl = true;
    }
  }
  
  if(key == CODED)
  {
  if(keyCode == UP)
  {
    selectedOctave++;
  }
  
  if(keyCode == DOWN)
  {
    selectedOctave--;
  }
  }
}