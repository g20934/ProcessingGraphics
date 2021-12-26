//花火を描くプログラムを作成しました。
//一回目は勝手に打ち上がりますが、2回目以降はマウスでクリックすると打ち上がります
//キーを押すと、花火の色が変化します

float kakudo = PI / 4;
float x0, y0, x, y; //花火初期位置と現在位置
float y2; //花火の最初
float x2 = 512/2;//打ち上げ場所
float t = 0;//時間
float g = 9.8;//重力加速度
float v0 = 30;//初速度
float count = 0; //花火場所変更
float ycount = 0; //打ち上げ高さ変更
float count2 = 0; //透明度調節
int mouse = -1;//マウスクリック
float firecolor = 0;//花火の色（ランダムにしたいので、浮動小数点型にした）
int rad = 4; //描く円の半径
int arraySize = 50;
float count3 = 0;
float posX[], posY[], vX[], vY[], hue[];

void setup(){//描画ウィンドウの設定、色などの設定
  size(512, 512);//描画ウィンドウの設定（変数は使えないので、数字で書く！)
  colorMode(HSB, 360, 100, 100, 100);
  noStroke();
  posX = new float[arraySize];
  posY = new float[arraySize];
  vX = new float[arraySize];
  vY = new float[arraySize];
  hue = new float[arraySize];
  for(int i = 0; i < arraySize; i++){
     //posX[i] = width/2.0;
     posX[i] = 0;
     posY[i] = height/2.0;
     vX[i] = random(-1,1); //x方向移動変化量
     vY[i] = random(-1,1);//y方向
     //hue[i] = random(0, 360);//色相
  }
  //frameRate(100);
}

//時間あったらやりたいこと：火花の本数増やす
void draw(){
  background(0);
 
  if(mouse > 0 || mouse< 0){
    //打ち上げる
    fill(color(firecolor, 100, 100, 300 - ycount));
    y2 = height - ycount;       
    ellipse(x2, y2, rad, rad);

    if(y2 < 200){
      //火花を撒き散らす
         for(int j = 1; j < 30; j++){
           for(int i = 0; i < 8; i++){
              x = j * cos(kakudo*i);
              y = j* sin(kakudo*i);
              x0 = x*2 + x2;
              y0 =  y * 2 + height/2 - 100;
               
               fill(color(firecolor, 100, 100, 100 - count2));
               //y = y0 + g * t * t / 2 + v0 * t * sin(radians(i*kakudo));
               if(i >= 3 && i <= 5){
                 x = x0 - count;
               }else if(i == 2 || i == 6){
                 x = x0;
               }else{
                 x = x0 + count;
               }
               
               
               if(i ==1 ||  i == 3){
                 y = count  + y0;
               }else if(i == 0 || i ==4){
                 y = y0;
               }else if(i == 5 || i == 7){
                 y = -count  + y0;
               }else if(i == 2){
                 y = y0 + g * t * t / 2 + v0 * t * sin(radians(i*kakudo));
               }else{
                 y =  y0 - count / sin(radians(45)) ;
               }
               
             
           ellipse(x, y , rad , rad );
          }//iのfor文
        }//jのfor文
        //kakudo += 15;
         for( int i=0;i<arraySize;i++ ){
            if((posX[i]  >=  - 150)&& (posX[i]  < 150)&&  posY[i]   >=  130 && posY[i]  <=  400){
              if( i % 2 == 0){
               hue[i] = random(40 , 80);
               fill( color( hue[i], 100,100, 50));   
               ellipse(x2 + posX[i] , posY[i] - 100, 3, 3 );        
             }else{
               fill( color( 0, 0,100, 50));
               ellipse(x2 + posX[i] , posY[i] - 100, 3, 3 );           
             }
           } 
         } 
          
          for( int i=0;i<arraySize;i++ ){
            posX[i] = posX[i] +3*vX[i];
            posY[i] = posY[i] + 3*vY[i];
            hue[i] = (hue[i] +2.0) % 360;
          }
  
    }//y2 < 200のif文
  }//mouseのif文
  count2 += 0.5; //透明度を上げる
  count += 0.5; //0.5
  t += 0.03; //0.03
  ycount += 4;
}

void mousePressed(){//クリックすると打ち上がる
  mouse *= -1;
  y2 = height;
  ycount = 0;
  count = 0;
  t = 0;
  count2 = 0;
  x2 = random(0, width);
  count3 = 0;
  for( int i=0; i<arraySize; i++ ){
    posX[i] = 0;
    posY[i] = height/2.0;
  }
 
}

void keyPressed(){//キーを押すとランダムに色が変わる
   firecolor = random(0, 360);
}
