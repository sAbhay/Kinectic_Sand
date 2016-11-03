class Button
{
  int x;
  int y;
  int h;
  float w;
  int textSize;
  String text;
  boolean statement;

  Button(int _x, int _y, int _h, int _textSize, String _text, boolean _statement)
  {
    x = _x;
    y = _y;

    textSize = _textSize;
    text = _text;

    h = _h;
    w = text.length() * 13 * 1.5384615385 * textSize/30;

    statement = _statement;
  }

  void display()
  {
    stroke(0);
    fill(255);
    rect(x, y, w, h);

    fill(0);
    textSize(textSize);
    text(text, x, y + h/4);
  }

  void change()
  {
    if (mouseX >= x - w/2 && mouseX <= x + w/2 && mouseY >= y - h/2 && mouseY <= y + h/2)
    {
      if (statement) 
      {
        statement = false;
      } else if (!statement)
      {
        statement = true;
      }
    }
  }
}