class Entity
{
  float x;
  float y;

  PImage img;
  String type;

  Body body;
  boolean isAlive;

  int imgH;
  int imgW;
  
  color bodyColour;

  Entity(float _x, float _y, PImage _img, String _type, color _bodyColour, boolean _isAlive)
  {
    x = _x;
    y = _y;

    img = _img;
    type = _type;
    isAlive = _isAlive;
    
    bodyColour = _bodyColour;
  }

  private void createBody(BodyType _bType, float _restitution, float _density)
  {
    imgH = img.height;
    imgW = img.width;

    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(imgW/2);
    float box2dH = box2d.scalarPixelsToWorld(imgH/2);
    sd.setAsBox(box2dW, box2dH);

    FixtureDef fd = new FixtureDef();
    fd.shape = sd;

    fd.density = _density;
    fd.friction = 0.3;
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

    imageMode(CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);
    tint(bodyColour);
    image(img, 0, 0);
    popMatrix();
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