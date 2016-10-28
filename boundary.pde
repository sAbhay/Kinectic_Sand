class Boundary extends Entity
{
  Boundary(float _x, float _y, PImage _img, color _bodyColour, boolean _isAlive)
  {
    super(_x, _y, _img, "Boundary", _bodyColour, _isAlive);
    super.createBody(BodyType.STATIC, 0, 1000);
  }
}