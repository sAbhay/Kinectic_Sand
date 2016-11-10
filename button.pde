class Button
{
  int x;
  int y;
  int h;
  float w;

  int textSize;
  String text;

  int number;

  String type;

  Button(int _x, int _y, int _h, int _textSize, String _text, String _type, int _number)
  {
    x = _x;
    y = _y;

    textSize = _textSize;
    text = _text;

    h = _h;
    w = text.length() * 13 * 1.5384615385 * textSize/30;

    type = _type;

    number = _number;
  }

  void display(boolean statement)
  { 
    if (statement)
    {
      stroke(0);
      fill(255);
    } else 
    {
      stroke(255);
      fill(0);
    }

    rect(x, y, w, h);

    if (statement)
    {
      fill(0);
    } else 
    {
      fill(255);
    }

    textSize(textSize);
    text(text, x, y + h/4);
  }

  void change()
  {
    if (mouseX >= x - w/2 && mouseX <= x + w/2 && mouseY >= y - h/2 && mouseY <= y + h/2)
    {
      if (type == "Octave")
      {
        selectedOctave += number;
      } else if (type == "Chords")
      {
        if (chords == false)
        {
          chords = true;
        } else
        {
          chords = false;
        }
      } else if (type == "KinectControl")
      {
        if (kinectControl) 
        {
          kinectControl = false;
        } else if (!kinectControl) 
        {
          kinectControl = true;
        }
      } else if (type == "NextScale")
      {
        nextScale += number;
      } else if (type == "Record")
      {
        if (recorder.isRecording())
        {
          recorder.endRecord(); 
          println("Recorded.");
        } else
        {
          recorder.beginRecord();
        }
      } else if (type == "Save")
      {
        recorder.save();
        println("Saved.");
      } else if (type == "Mode")
      {
        mode += number;
      } else if(type == "verticalGravity")
      {
       verticalGravity += number;
       
       box2d.setGravity(horizontalGravity, verticalGravity);
      } else if(type == "horizontalGravity")
      {
       horizontalGravity += number;
       
       box2d.setGravity(horizontalGravity, verticalGravity);
      }
    }
  }
}