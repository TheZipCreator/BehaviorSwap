boolean devmode = true;
int[][] world;
PImage[] tiles;
PImage[] general;
PImage[] bimg;
PImage[] antibimg;
int walkspeed = 2;
PVector chpos;
PVector chmove;
boolean dir;
PImage unk;
int wsx;
int wsy;
ArrayList<Entity> entities;
int screenx = 0;
int screeny = 0;
int lsx = 0;
int lsy = 0;
PVector lsp;
boolean has_swapper = false;
int slotspos = -80;
int tpos = width*1000;
PFont fnt;
String[] Behaviors;
int point = 0;
boolean screenskipping = false;

void setup() {
  if(devmode) {
    has_swapper = true;
    walkspeed = 5;
  }
  entities = new ArrayList<Entity>();
  wsx = width/16;
  wsy = height/16;
  world = new int[wsx][wsy];
  for(int i = 0; i < wsx; i++) {
    for(int j = 0; j < wsy; j++) {
      world[i][j] = 0;
    }
  }
  chpos = new PVector(width/2, height/2);
  chmove = new PVector(0, 0);
  tiles = new PImage[9];
  general = new PImage[12];
  Behaviors = new String[4];
  for(int i = 0; i < Behaviors.length; i++) {
    Behaviors[i] = "";
  }
  tiles[0] = loadImage("data/img/stone.png");
  tiles[1] = loadImage("data/img/wall.png");
  tiles[2] = loadImage("data/img/death.png");
  tiles[3] = loadImage("data/img/lever_off.png");
  tiles[4] = loadImage("data/img/lever_on.png");
  tiles[5] = loadImage("data/img/door.png");
  tiles[6] = loadImage("data/img/swapper.png");
  tiles[7] = loadImage("data/img/grass.png");
  tiles[8] = loadImage("data/img/inversion_machine.png");
  general[0] = loadImage("data/img/char.png");
  general[1] = loadImage("data/img/charw.png");
  general[2] = loadImage("data/img/charf.png");
  general[3] = loadImage("data/img/charfw.png");
  general[4] = loadImage("data/img/bullet.png");
  general[5] = loadImage("data/img/bulletf.png");
  general[6] = loadImage("data/img/slots.png");
  general[7] = loadImage("data/img/box.png");
  general[8] = loadImage("data/img/fireball.png");
  general[9] = loadImage("data/img/spitter.png");
  general[10] = loadImage("data/img/charger.png");
  general[11] = loadImage("data/img/chargerf.png");
  bimg = new PImage[2];
  antibimg = new PImage[2];
  bimg[0] = loadImage("data/img/homing.png");
  antibimg[0] = loadImage("data/img/antihoming.png");
  bimg[1] = loadImage("data/img/spitting.png");
  antibimg[1] = loadImage("data/img/antispitting.png");
  fnt = loadFont("monobit-32.vlw");
  textFont(fnt);
  unk = loadImage("data/img/unk.png");
  loadLevel("data/lvl/0+0.png");
  //entities.add(new Entity(new PVector(width/2, height/2), loadImage("data/img/char.png")));
  
}
void settings() {
  size(640, 640);
}
void draw() {
  for(int i = 0; i < wsx; i++) {
    for(int j = 0; j < wsy; j++) {
      if(world[i][j] >= 0 && world[i][j] < tiles.length) {
        image(tiles[world[i][j]], i*16, j*16);
      } else {
        image(unk, i*16, j*16);
      }
    }
  }
  for(int i = 0; i < entities.size(); i++) {
    entities.get(i).update();
  }
  PVector np = new PVector(chpos.x, chpos.y);
  np.x += chmove.x;
  np.y += chmove.y;
  int collx = floor(np.x/16);
  int colly = floor(np.y/16);
  if(world[collx+1][colly] == 6 || world[collx][colly+1] == 6 || world[collx-1][colly] == 6 || world[collx][colly-1] == 6) {
    world[collx][colly] = 0;
    world[collx+1][colly] = 0;
    world[collx][colly+1] = 0;
    world[collx-1][colly] = 0;
    world[collx][colly-1] = 0;
    has_swapper = true;
    tpos = 0;
  }
  if(world[collx+1][colly] == 8 || world[collx][colly+1] == 8 || world[collx-1][colly] == 8 || world[collx][colly-1] == 8) {
    String b = Behaviors[point-1];
    //println("hi");
    if(b.equals("homing")) {
      println("yes");
      Behaviors[point-1] = "antihoming";
    }
    if(b.equals("spitting")) {
      Behaviors[point-1] = "antispitting";
    }
  }
  if(world[collx][colly] == 0 && world[collx+1][colly] == 0 && world[collx][colly+1] == 0 && world[collx][colly+2] == 0 && world[collx+1][colly+1] == 0) {
    chpos = np;
  }
  if(chpos.x/16 > wsx-2) {
    lsx = screenx;
    screenx++;
    loadLevel("data/lvl/"+screenx+"+"+screeny+".png");
    chpos.x = 32;
    lsp = chpos;
  }
  if(chpos.x/16 < 2) {
    lsx = screenx;
    lsp = chpos;
    screenx--;
    loadLevel("data/lvl/"+screenx+"+"+screeny+".png");
    chpos.x = (wsx*16)-32;
    lsp = chpos;
  }
  if(chpos.y/16 > wsy-3) {
    lsy = screeny;
    lsp = chpos;
    screeny++;
    loadLevel("data/lvl/"+screenx+"+"+screeny+".png");
    chpos.y = 32;
    lsp = chpos;
  }
  if(chpos.y/16 < 2) {
    lsy = screeny;
    lsp = chpos;
    screeny--;
    loadLevel("data/lvl/"+screenx+"+"+screeny+".png");
    chpos.y = (wsy*16)-48;
    lsp = chpos;
  }
  if(dir) {
    if(frameCount%20 < 10 && (chmove.x != 0 || chmove.y != 0)) {
      image(general[1], chpos.x, chpos.y);
    } else {
      image(general[0], chpos.x, chpos.y);
    }
  } else {
    if(frameCount%20 < 10 && (chmove.x != 0 || chmove.y != 0)) {
      image(general[3], chpos.x, chpos.y);
    } else {
      image(general[2], chpos.x, chpos.y);
    }
  }
  image(general[6], 0, slotspos);
  if(has_swapper) slotspos = round(lerp(slotspos, 0, 0.1));
  textSize(32);
  textFont(fnt);
  tpos += 1;
  text("Left click to take behaviors, right click to give", tpos, height-32);
  for(int i = 0; i < 4; i++) {
    if(Behaviors[i].equals("homing")) {
      image(bimg[0], (i*64)+(8*i), 8);
    }
    if(Behaviors[i].equals("spitting")) {
      image(bimg[1], (i*64)+(8*i), 8);
    }
    if(Behaviors[i].equals("antihoming")) {
      image(antibimg[0], (i*64)+(8*i), 8);
    }
    if(Behaviors[i].equals("antispitting")) {
      image(antibimg[1], (i*64)+(8*i), 8);
    }
  }
  if(entities.size() != 0) {
    for(int i = entities.size()-1; i >= 0; i--) {
      if(entities.get(i).delete_flag) {
        entities.remove(i);
      }
    }
  }
}
void keyPressed() {
  if(key == 'w') {
    chmove.y = -walkspeed;
  }
  if(key == 's') {
    chmove.y = walkspeed;
  }
  if(key == 'a') {
    chmove.x = -walkspeed;
    dir = false;
  }
  if(key == 'd') {
    chmove.x = walkspeed;
    dir = true;
  }
  if(screenskipping) {
    if(key == 'w') {
      screeny--;
      loadLevel("data/lvl/"+screenx+"+"+screeny+".png");
    }
    if(key == 's') {
      screeny++;
      loadLevel("data/lvl/"+screenx+"+"+screeny+".png");
    }
    if(key == 'a') {
      screenx--;
      loadLevel("data/lvl/"+screenx+"+"+screeny+".png");
    }
    if(key == 'd') {
      screenx++;
      loadLevel("data/lvl/"+screenx+"+"+screeny+".png");
    }
  }
  if(keyCode == ALT) {
    if(devmode) screenskipping = true; 
  }
}
void keyReleased() {
  if(key == 'w') {
    chmove.y = -0;
  }
  if(key == 's') {
    chmove.y = 0;
  }
  if(key == 'a') {
    chmove.x = -0;
  }
  if(key == 'd') {
    chmove.x = 0;
  }
  if(key == 'k' && devmode) {
    if(walkspeed == 5) {
      walkspeed = 2;
    } else {
      walkspeed = 5;
    }
  }
  if(keyCode == ALT) {
    if(devmode) screenskipping = false; 
  }
}
void loadLevel(String path) {
  lsp = chpos;
  entities = new ArrayList<Entity>();
  PImage lvl = loadImage(path);
  for(int i = 0; i < wsx; i++) {
    for(int j = 0; j < wsy; j++) {
      color c = lvl.get(i, j);
      int type = 2000;
      if(c == color(64, 64, 64)) {
        type = 1;
      }
      if(c == color(128, 128, 128)) {
        type = 0;
      }
      if(c == color(255, 0, 0)) {
        type = 0;
        entities.add(new Entity(new PVector(i*16, j*16), general[4], "bullet").addBehavior("homing").addBehavior("bullet"));
      }
      if(c == color(127, 0, 0)) {
        type = 3;
      }
      if(c == color(255, 255, 255)) {
        type = 5;
      }
      if(c == color(0, 0, 0)) {
        if(!has_swapper) {
          type = 6;
        } else {
          type = 0;
        }
      }
      if(c == color(0, 0, 255)) {
        type = 0;
        entities.add(new Entity(new PVector(i*16, j*16), general[7], "box"));
      }
      if(c == color(0, 255, 0)) {
        type = 7;
      }
      if(c == color(255, 255, 0)) {
        type = 0;
        entities.add(new Entity(new PVector(i*16, j*16), general[9], "spitter").addBehavior("spitting").setOffset(i+j));
      }
      if(c == color(255, 128, 0)) {
        type = 0;
        entities.add(new Entity(new PVector(i*16, j*16), general[9], "charger").addBehavior("charging").setOffset(i+j));
      }
      if(c == color(0, 255, 128)) {
        type = 8;
      }
      if(c == color(255, 128, 0)) {
        type = 0;
        entities.add(new Entity(new PVector(i*16, j*16), general[9], "charger").addBehavior("charging").setOffset(i+j));
      }
      world[i][j] = type;
    }
  }
}
void mousePressed() {
  if(mouseButton == LEFT) {
    for(int i = 0; i < entities.size(); i++) {
      if(mouseX > entities.get(i).pos.x && mouseY > entities.get(i).pos.y && mouseX < entities.get(i).img.width+entities.get(i).pos.x && mouseY < entities.get(i).img.height+entities.get(i).pos.y) {
        if(entities.get(i).behaviors.size() > 0 && has_swapper) {
          boolean modify = false;
          for(String b: entities.get(i).behaviors) {
            if(b.equals("no_modify")) {
              modify = true;
            }
          }
          if(point != 4 && !modify) {
            Behaviors[point] = entities.get(i).behaviors.get(0);
            point++;
            entities.get(i).behaviors.remove(0);
          }
        }
      }
    }
  }
  if(mouseButton == RIGHT) {
    for(int i = 0; i < entities.size(); i++) {
      if(mouseX > entities.get(i).pos.x && mouseY > entities.get(i).pos.y && mouseX < entities.get(i).img.width+entities.get(i).pos.x && mouseY < entities.get(i).img.height+entities.get(i).pos.y) {
        if(has_swapper) {
          println(point);
          boolean modify = false;
          for(String b: entities.get(i).behaviors) {
            if(b.equals("no_modify")) {
              modify = true;
            }
          }
          if(point != 0 && !modify) {
            println("hi");
            entities.get(i).addBehavior(Behaviors[point-1]);
            Behaviors[point-1] = "";
            point--;
          }
        }
      }
    }
  }
}
