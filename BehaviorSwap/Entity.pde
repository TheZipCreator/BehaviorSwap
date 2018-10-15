class Entity {
  PVector pos;
  PVector vel;
  PImage img;
  ArrayList<String> behaviors;
  String type = "";
  boolean dir = false;
  boolean delete_flag = false;
  int offset = 0;
  Entity(PVector p, PImage i, String t) {
    pos = p;
    img = i;
    type = t;
    behaviors = new ArrayList<String>();
    vel = new PVector(0, 0);
  }
  void update() {
    image(img, pos.x, pos.y);
    PVector npos = new PVector(pos.x, pos.y);
    npos.add(vel);
    vel.mult(0.9);
    for(String b:behaviors) {
      if(b.equals("homing")) {
        PVector target = new PVector(chpos.x-(pos.x-(general[1].width/2)), chpos.y-(pos.y-(general[1].height/2)));
        target.normalize();
        target.mult(2.2);
        npos.x += target.x;
        npos.y += target.y;
        if(target.x > 0) {
          dir = true;
        } else {
          dir = false;
        }
      }
      if(b.equals("spitting")) {
        if((frameCount+offset)%60 == 1) {
          entities.add(new Entity(new PVector(pos.x, pos.y), general[8], "fireball"));
        }
      }
      if(b.equals("charging")) {
        PVector target = new PVector(chpos.x-(pos.x-(general[1].width/2)), chpos.y-(pos.y-(general[1].height/2)));
        target.normalize();
        target.mult(10);
        if((frameCount+offset)%60 == 1) {
          vel.x += target.x;
          vel.y += target.y;
        }
        if(target.x > 0) {
          dir = true;
        } else {
          dir = false;
        }
      }
    }
    if(type.equals("bullet")) {
        if(dir) {
          img = general[4];
        } else {
          img = general[5];
        }
      }
    if(type.equals("fireball")) {
        npos.y -= 3;
    }
    if(type.equals("charger")) {
      if(dir) {
          img = general[10];
      } else {
          img = general[11];
      }
    }
    if(npos.x > chpos.x && npos.x < chpos.x+general[1].width && npos.y > chpos.y && npos.y < chpos.y+general[1].height) {
      collideWithPlayer();
    }
    int collx = round(npos.x/16);
    int colly = round(npos.y/16);
    try {
      if(world[collx][colly] == 3) {
        world[collx][colly] = 4;
        for(int i = 0; i < wsx; i++) {
          for(int j = 0; j < wsy; j++) {
            if(world[i][j] == 5) {
              world[i][j] = 0;
            }
          }
        }
      }
      if(world[collx][colly] == 7) {
        world[collx][colly] = 0;
      }
      if(world[collx][colly] != 0) {
        if(type.equals("fireball")) {
          delete_flag = true;
          //println("hello");
        }
      }
      if(world[collx][colly] == 0) {
        pos = npos;
      } 
    } catch(Exception e) {
      
    }
    fill(255, 0, 0, 128);
    if(devmode) rect(npos.x, npos.y, 16, 16);
    fill(0, 0, 255, 128);
    if(devmode) rect(collx*16, colly*16, 16, 16);
    fill(255);
  }
  Entity addBehavior(String b) {
    behaviors.add(b);
    return this;
  }
  void collideWithPlayer() {
      if(type.equals("bullet") || type.equals("fireball") || type.equals("charger") || type.equals("spitter")) {
        Behaviors = new String[4];
        for(int i = 0; i < Behaviors.length; i++) {
          Behaviors[i] = "";
        }
        chpos = lsp;
        loadLevel("data/lvl/"+screenx+"+"+screeny+".png");
        int collx = round(pos.x/16);
        int colly = round(pos.y/16);
        world[collx][colly] = 2;
      }
  }
  Entity setOffset(int o) {
    offset = o;
    return this;
  }
}
