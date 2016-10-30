class Sand extends Entity
{
 Sand(float _x, float _y, int _entityWidth, int _entityHeight, color _bodyColour, boolean _isAlive)
 {
  super(_x, _y, _entityWidth, _entityHeight, "Box", _bodyColour, _isAlive);
  super.createBody(BodyType.DYNAMIC, 0, 1);
 }
}