//両側に建物がある道の中を歩いていると花火が打ち上がるイメージです。
//赤い箱は車をイメージしています。マウスを横に動かすと、赤い箱も動きます（ビルにぶつからないように設定しています）
//花火が開いた後の球体たちは一色で塗られますが、花火の開きがある一定値に達すると、球体ごとにランダムの色になります。
//1回目の花火は勝手に打ち上がりますが、2回目以降は何らかのキーを押すと花火が打ち上がります。
//マウスでクリックすると、花火が開いた時の色が変化します。
//道を進んでいくと、ある一定のところでカメラが止まり、最後に花火が打ち上がります。
//最後の花火は今までの花火とは少し違う動きをします。カメラが止まった後は、キーを押しても花火は打ち上がりません。
//各クラスの大まかな説明→axis3Dはxyz軸、buildingsは建物、movingDotは打ち上げるときの球体、shootingDotはmovingDotがある一定値に達した時に花火が開く様子を表します
//kadai2クラスでは、カメラなどの初期設定や、上記4つのクラスへ指示を出して物体を書かせる、マウスやキーの動作に対する分岐などを書いています
movingDot md;
shootingDot sd[];
buildings builds;
int shootingDotNum = 90;//打ち上がった後に撒き散らす球体の数
int keyJudge = 1;//キーを押した時、花火を書くかどうか格納する変数
int drawFinalcheck = 1;//最後の花火を書くかどうか格納する変数
float z = 400;//地面のz軸方向の長さ（緑や灰色の四角）
PVector vvp;//カメラ位置
float temp;//マウスクリック時の色変化を格納しておく変数
void setup(){
  size(1028, 550, P3D);//P3D: processingの3Dレンダラを起動してください
  frameRate(30);
  colorMode( HSB, 360, 100, 100, 100 ); 
  rectMode(RADIUS);
  vvp = new PVector(0 , -20, 128);
  md = new movingDot(vvp.z);
  sd = new shootingDot[shootingDotNum];//shootingDot型のインスタンスが入る箱を作る
  for(int i = 0; i < shootingDotNum; i++){
      sd[i] = new shootingDot();//shootingDot型の箱に生成したインスタンスを入れる
  }
  builds = new buildings();
}

void draw(){
  background(0);
  directionalLight(0, 0, 100, -1, 1, -1);//建物のライトはbuildingsクラスでlights()に指定しています。
  camera(
  vvp.x , vvp.y, vvp.z, //カメラをどこで構えるか0 , -64, 128 128 , -128, 512
  0, -40, vvp.z-128, //焦点をどこに置くか
  0, 1, 0 //カメラをどう構えるか　0, 1, 0はオーソドックス
  );
  noStroke();
  
  //緑の地面
  pushMatrix();//元々の座標系のコピー、保存
  //コピーされた座標系で色々動かす
  rotateX(radians(90));//X軸を中心にして90度回す x軸を無限遠から見て時計回りに〇〇度回す
  fill( color( 100,100,100,100 ));
  translate(96, 0, 0);
  rect( 0, 0, 64, z);
  popMatrix();//コピーしたものを破棄して、保存していた座標系に戻す
  
  pushMatrix();
  rotateX(radians(90));
  fill( color( 100,100,100,100 ));
  translate(-96, 0, 0);
  rect( 0, 0, 64, z);
  popMatrix();
  
  //灰色の地面
  pushMatrix();
  rotateX(radians(90));
  fill( color( 0,0,50,100 ));
  rect( 0, 0, 32, z);
  popMatrix();
  
  
  //赤い箱（車）
  pushMatrix();
  fill( color( 0,100,100,100 ));
  if(mouseX - width / 2 < -10){
    translate(-10 , -10, vvp.z - 48);
  }else if(mouseX - width / 2 > 10){
    translate(10 , -10, vvp.z - 48);
  }else{
    translate(mouseX - width / 2 , -10, vvp.z - 48);
  }
  box( 15, 2, 5);
  popMatrix();
  
  //花火
  if(vvp.z > -300 && (keyJudge > 0 || keyJudge < 0)){
    md.draw();//打ち上げ
    //打ち上げ後
    if(md.pos.y < -95){
      for(int i = 0; i < shootingDotNum; i++){
        sd[i].draw(md.pos.z);
      }
    }
  }
  
  //最後の打ち上げ花火
  if(drawFinalcheck < 0){
    md.draw();
    if(md.pos.y < -95){
      for(int i = 0; i < shootingDotNum; i++){
        sd[i].draw(md.pos.z);
       }
    }
  }
  //建物
  builds.draw();
  
  //xyz軸
  //axis3D(250, 3);
  
  //カメラ移動
  if(vvp.z > -300){
    vvp.z--;
    finalCheck();
  }
}

void keyPressed(){//キーを押すと、花火が打ち上がる
  if(vvp.z > -300){
  md.init(vvp.z);//初期化
  for(int i = 0; i < shootingDotNum; i++){
    sd[i].init();//初期化
    sd[i].hue =  temp;//現在の花火の色代入
   }
  keyJudge *= -1;//通常の花火を打ち上げていいことを記録する
  }
}

void mousePressed(){//マウスクリックすると花火の色がランダムに変わる
  temp = random(0, 360); 
  for(int i = 0; i < shootingDotNum; i++){
      sd[i].hue =  temp;//花火の色代入
   }
}

 void finalCheck(){
  if(vvp.z <= -300){
    //vvp.zは-300になったらデクリメントをしなくなるので、if文の中は一度しか処理されない
    //→drawFinalcheck<0となるのも1回しかないので、最後の打ち上げ花火は一回しか実行されない
    md.init(vvp.z);
  for(int i = 0; i < shootingDotNum; i++){
    sd[i].init();
   }
   drawFinalcheck *= -1;
  }
}
