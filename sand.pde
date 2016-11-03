class Sand extends Entity
{
 Sand(float _x, float _y, int _entityWidth, int _entityHeight, color _bodyColour)
 {
  super(_x, _y, _entityWidth, _entityHeight, _bodyColour);
  super.createBody(BodyType.DYNAMIC, 0, 1);
 }
}