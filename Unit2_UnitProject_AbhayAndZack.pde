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

boolean settings = false;

boolean kinectControl = false;

int numberOfButtons = 6;
Button[] buttons = new Button[numberOfButtons];

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

  buttons[0] = new Button(width/2 - 50, height/2 + 100, 20, 15, "-", "Octave", -1);
  buttons[1] = new Button(width/2 + 50, height/2 + 100, 20, 15, "+", "Octave", 1);
  buttons[2] = new Button(2*width/3 - 100, 2*height/3, 20, 15, "-", "NextScale", -1);
  buttons[3] = new Button(2*width/3 + 100, 2*height/3, 20, 15, "+", "NextScale", 1);
  buttons[numberOfButtons-2] = new Button(width/2 + 100, height/2 - 100, 20, 15, "Chords", "Chords", 1);
  buttons[numberOfButtons-1] = new Button(width/2 - 100, height/2 - 100, 20, 15, "Kinect Control", "KinectControl", 1);
}

void draw()
{
  if (selectedOctave < 1) selectedOctave = 1;
  if (selectedOctave > octave.length - 2) selectedOctave = octave.length - 2;
  
  if(nextScale < 0) nextScale = 24;
  if(nextScale > 24) nextScale = 0;

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

  if (settings)
  {
    settingsMenu();
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

void mousePressed()
{
  if (settings)
  {
    for (int i = 0; i < buttons.length; i++)
    {
      buttons[i].change();
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

  if (key == CODED)
  {
    if (keyCode == UP)
    {
      selectedOctave++;
    }

    if (keyCode == DOWN)
    {
      selectedOctave--;
    }
  }

  if (key == ESC)
  {
    key = 0;

    if (settings)
    {
      settings = false;
    } else if (!settings)
    {
      settings = true;
    }
  }
}

void settingsMenu()
{
  fill(255);
  rect(width/2, height/2, width, height);

  fill(0);
  text("Now Playing From: " + scaleName[scale], width/2, height/2);

  text("Octave: " + selectedOctave, width/2, height/2 + 100);

  for (int i = 0; i < buttons.length-2; i++)
  {
    buttons[i].display(true);
  }
  
  buttons[numberOfButtons-2].display(chords);
  buttons[numberOfButtons-1].display(kinectControl);
  
  if(nextScale != 0)
  {
    fill(0);
   text("Playing Next: " + scaleName[nextScale], 2*width/3, 2*height/3); 
  } else {
    fill(0);
   text("Playing Next: Random", 2*width/3, 2*height/3); 
  }
  
}