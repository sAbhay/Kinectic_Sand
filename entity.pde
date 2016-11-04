class Entity
{
  private float x;
  private float y;
  private int entityWidth, entityHeight;

  private Body body;

  private color bodyColour;

  Entity(float _x, float _y, int _entityWidth, int _entityHeight, color _bodyColour)
  {
    x = _x;
    y = _y;
    entityHeight = _entityHeight;
    entityWidth = _entityWidth;
    bodyColour = _bodyColour;
    rect(_x, _y, _entityWidth, _entityHeight); 
  }

  private void createBody(BodyType _bType, float _restitution, float _density)
  {
    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(entityWidth/2);
    float box2dH = box2d.scalarPixelsToWorld(entityHeight/2);
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
    float a = body.getAngle();
    
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);
    fill(bodyColour);
    noStroke();
    rectMode(CENTER);
    rect(0, 0, entityWidth, entityHeight);
    popMatrix();
  }

  public void killBody()
  {
    box2d.destroyBody(body);
  }

  boolean done()
  {
    Vec2 pos = box2d.getBodyPixelCoord(body);

    if (pos.y > height + entityHeight || pos.x < -entityWidth || pos.x > width + entityWidth)
    {
      killBody();
      return true;
    }
    return false;
  }
}