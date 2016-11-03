class SettingsMenu
{
  Button[] b = new Button[1];

  SettingsMenu()
  {
    b[0] = new Button(200, 200, 30, 30, "Chords", chords);
  }

  void display()
  {
    fill(255);
    rect(width/2, height/2, width, height);

    for (Button button : b)
    {
      button.display();
    }
  }

  void track()
  {
    for (Button button : b)
    {
      button.change();
    }
  }
}