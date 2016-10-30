class Boundary extends Entity
{
  Boundary(float _x, float _y, int _entityWidth, int _entityHeight, color _bodyColour, boolean _isAlive)
  {
    super(_x, _y, _entityWidth, _entityHeight, "Boundary", _bodyColour, _isAlive);
    super.createBody(BodyType.STATIC, 0, 1000);
  }
}