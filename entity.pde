class Entity
{
  float x;
  float y;
  int entityWidth, entityHeight;
  String type;

  Body body;
  boolean isAlive;

  int imgH;
  int imgW;
  
  
  color bodyColour;

  Entity(float _x, float _y, int _entityWidth, int _entityHeight, String _type, color _bodyColour, boolean _isAlive)
  {
    x = _x;
    y = _y;
    entityHeight = _entityHeight;
    entityWidth = _entityWidth;
    type = _type;
    isAlive = _isAlive;
    bodyColour = _bodyColour;
    rect(_x, _y, _entityWidth, _entityHeight); 
  }

  private void createBody(BodyType _bType, float _restitution, float _density)
  {
    imgH = entityHeight;
    imgW = entityWidth;

    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(imgW/2);
    float box2dH = box2d.scalarPixelsToWorld(imgH/2);
    sd.setAsBox(box2dW, box2dH);

    FixtureDef fd = new FixtureDef();
    fd.shape = sd;

    fd.density = _density;
    fd.friction = 1;
    fd.restitution = _restitution;

    BodyDef bd = new BodyDef();
    bd.type = _bType;

    bd.position.set(box2d.coordPixelsToWorld(x, y));
    body = box2d.createBody(bd);
    body.createFixture(fd);
  }

  public void display()
  {
    PVector pos = box2d.getBodyPixelCoordPVector(body);
    fill(bodyColour);
    rect(pos.x, pos.y, imgW, imgH);
  }

  private void killBody()
  {
    box2d.destroyBody(body);
  }

  boolean done()
  {
    Vec2 pos = box2d.getBodyPixelCoord(body);

    if (pos.y > height + imgH || pos.x < -imgW || pos.x > width + imgW)
    {
      killBody();
      return true;
    }
    return false;
  }
}