class Sand extends Entity
{
 Sand(float _x, float _y, PImage _img, color _bodyColour, boolean _isAlive)
 {
  super(_x, _y, _img, "Box", _bodyColour, _isAlive);
  super.createBody(BodyType.DYNAMIC, 0, 1);
 }
}