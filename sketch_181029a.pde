
int rd_cnt=0;
void new_road() {
  for(int i=0;i<road.length;i++) {
    road[i][0] = i*road_scale;
    road[i][1] = height-int(random(road_oset-3, road_oset+4));
  }
}
void new_blocks() {
  for(int i=0;i<blocks.length;i++) {
    blocks[i][0] = int(random(1,20))+i;
    blocks[i][0] = blocks[i][0] *((160*4) + (scl*4));
    blocks[i][1] = int(random(70,160));
  }
}
boolean vis(int x[]) {
  if (((x[0] > 0) & (x[0]+x[2] < width)) & ((x[1] > 0) & (x[1]+x[3] < height)))
    return true;
  return false;
}
void setup() {
  fullScreen();
  frameRate(100);
  font = createFont("Arial",40);
  textFont(font);
  road = new int[width*4][2];
  blocks = new int[width/20][2];
  
  new_road();
  new_blocks();
  y=(height-road_oset)-(scl/2);
  clouds = new int[width*2][4];
  for(int i=0;i<clouds.length;i++) {
    clouds[i][0] = int(random(0,width*20)*20);
    clouds[i][1] = int(random(0,height-(road_oset*3.5)));
    clouds[i][2] = int(random(10,120));
    clouds[i][3] = int(random(10,50));
  }
  background(bg);
  fill(255-bg);
  text("Press SPACE to jump your bubble\nPress 'I' to invert the color\nPress 'R' to restart",(width/2)-150, height/3);
  freez = 500;
}
PFont font;
int touch(int bx[]) {
  if (((x+(scl/2) > bx[0]) & (x-(scl/2) < bx[0]+bx[2]) & ((y+(scl/2) > bx[1]) & (y-(scl/2) < bx[1]+bx[3]))))
    return 1;
  else if (((x+(scl/2) > bx[0]) & (x-(scl/2) < bx[0]+bx[2])))
    return 2;
  return 3;
}
boolean passed=false;
boolean touched = false;
int road[][];
int road_cntr=0;
int road_scale=3;
int road_oset=height+(height/2);

int jmp_flag=0;

int blocks[][];
int block_scl=30;
int scl=50;
int x_oset= 100;
int x=x_oset,y;

float acl=0.5;

int scores=0;
int life=5*15;
boolean game_over = false;
int freez=5;

int clouds[][];
void draw() {
  
  if (!game_over) {
    if (freez == 0) {
      acl=55;
      background(bg);
      text("\t\thigh score: "+high_score+"\nlife: "+life/15+"\nscore: "+scores,50,100);
      for(int i=road.length-9;i>9;i-=10) {
        stroke(255-bg);
        line(road[i-10][0], road[i-10][1], road[i][0], road[i][1]);
        road[i][0] = road[i-10][0];
        rd_cnt++;
        if (rd_cnt > road.length) {
          rd_cnt=0;
          new_road();
        }
      }
      for (int i=0;i<clouds.length;i++) {
        stroke(255-bg);
        fill(bg);
        ellipse(clouds[i][0],clouds[i][1],clouds[i][2],clouds[i][3]);
        clouds[i][0]-=int(random(3,6));
      }
      fill(255-bg);
      scores++;
      for(int i=blocks.length-1;i>0;i--){
        int tmp[] = {
          blocks[i][0], (height-(road_oset+blocks[i][1])),
          block_scl, blocks[i][1]
        };
        rect(tmp[0],tmp[1],tmp[2],tmp[3]);
        blocks[i][0] -= 50;
        if (touch(tmp) == 1) {
          if (touched) {
            life-=15;
            touched = false; 
            fill(255,0,0);
            stroke(255,0,0);
            //y=330;
            freez = 30;
          }
          passed=true;
        } else if (touch(tmp) == 3) { touched = true; }
      }
      ellipse(x,y,scl,scl);
      if ((jmp_flag == 2)) {
        y+=0.6+(1*acl);
        if (y+(scl/2) > height-road_oset) {
          jmp_flag=0;
           y=(height-road_oset)-(scl/2);
        }
      }
      if (jmp_flag == 1) {
        y-=0.6+(1*acl);
        if (y < int((height-road_oset)-(scl*5.7))) {
          jmp_flag = 2;
        }
      }
      if (x < x_oset) x++;
      //acl+=1;
      if (scores%400 == 0) bg = 255-bg;
      if (life < 0) game_over=true;
    } else {
      freez --;
    }
  } else { 
    //background(bg);
    fill(255-bg);
    if (high_score < scores) high_scored=true;
    if (high_scored) {
      high_score = scores;
      text("Game over\n\nnew high score: "+high_score+"\n\n\npress 'R' to restart", (width/2) -200, height/3);
    } else {
      text("Game over\n\nscore: "+scores+"\nhigh score: "+high_score+"\n\n\npress 'R' to restart", (width/2) -200, height/3);
    }
  }
}
boolean high_scored=false;
void keyPressed() {
  if ((key == ' ') & (jmp_flag == 0)) {
    jmp_flag = 1;
    //y = int((height-road_oset)-(scl*5.7));
    acl=0.5;
  } else if ((key == 'i') | (key == 'I')) {
    bg = 255-bg;
  } else if ((key == 'r') | (key == 'R')) {
    game_over=false;
    new_road();
    new_blocks();

    y=(height-road_oset)-(scl/2);
    life=5*15;
    scores=0;
    jmp_flag=0;
    high_scored=false;
  }
}
int bg;
int high_score;
