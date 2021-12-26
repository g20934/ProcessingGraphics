//音ゲーを作りました。曲はチャイコフスキー作曲の『バレエ組曲「くるみ割り人形」より「金平糖の精の踊り」』です。起動に時間がかかります。
//なお、github上には著作権上の問題が発生するのを避けるため、音源やイラストは載せていません。
//実行するパソコンによっては音ズレが発生する場合があります。
//音とノーツのズレがひどい場合はクラスPlayScreenの78行目の数値を変更していただけると幸いです。
//クラスnoteの45~47行目を使うと、notev.x=0でタンバリンが鳴るので、調整しやすいです。
//クラスPlayScreenの8５~89行目をコメントアウトすると、hpが0以下になってもゲームが終了しないので、調整がしやすいと思います。
//【操作方法 】
//・音楽に合わせて流れるノーツ（直方体）をタイミング良くキーボードで叩くゲームです。最初に出てきた画面に水色線で囲われたSTARTがあります。水色線の中をマウスクリックしていただくと、ゲームが開始します。
//・使うキーはS, D, F, J, K, Lです。大文字・小文字どちらでも入力可能です。ノーツが流れてきたレーンに書いてあるキーを押してください。
//【判定について】
//・ガイドとして2色の線を引いています。黄色線の間でキーを押せるとPERFECT、緑線の間だとGOOD、それ以外の場所でキーを押すとBAD、キーを押さないとMISSという評価になります。
//・PERFECTやGOODが続いた回数がCOMBOです。評価がBAD、MISSの時HPが減り、COMBOが0になります。ゲームが終了したら、結果が表示されます。リトライする場合はRETRYボタンを、ホーム画面に戻る場合はRETURN HOME SCREENボタンを押してください
//【スコア計算方法】
//総スコア=PERFECTの個数 * 50 + GOODの個数 * 10 + BADの個数  * (-5) + MISSの個数  * (-10)

import processing.sound.*;//インストールしたライブラリをコードで使うとき import:持ち込む
SoundFile piano, sound1, sound2, sound3;//ピアノ、効果音
PlayScreen ps;
PImage imgBallerina;//バレリーナの画像

void setup(){
  size(1028, 550, P3D);
  frameRate(120);//１秒あたり120回draw()を呼び出す 金平糖の精の踊りをテンポ60としたため、フレームレートは計算しやすい値である120にした。
  colorMode(HSB, 360, 100, 100, 100);
  piano = new SoundFile(this, "konpeitoVer2.mp3");//チャイコフスキー作曲の『バレエ組曲「くるみ割り人形」より「金平糖の精の踊り」』です。JASRACで著作権が切れていることを確認しました。GarageBandに打ち込んだものを使用しています。
  sound1 =  new SoundFile(this, "tambVer3.mp3");
  sound2 =  new SoundFile(this, "cowBell3.mp3");
  sound3 =  new SoundFile(this, "strangeSound.mp3");
  ps = new PlayScreen(piano, sound1, sound2, sound3);

  PFont font = createFont("Osaka",50);
  textFont(font);
  
   imgBallerina = loadImage("ballet_woman.png");//いらすとやのイラストを使用しました。　https://www.irasutoya.com/2018/10/blog-post_325.html
}

void draw(){
  if(ps.scene == -1){//ホーム画面
     background(256);//灰色
     camera(
      0, -50,  100,//カメラをどこに置くか
      0, -50, 0,//焦点をどこに置くか
      0, 1,  0);//カメラをどう構えるか    
     lights();//processingのおすすめ光源セット
     ps.drawHome();
  }
  else if(ps.scene == 0){//プレイ画面
    background(256);//灰色
    camera(
    60, -50, 0,
    -50, 0, 0,
    0, 1, 0
    );
    pointLight(0, 0, 100, 0, -256, 0);// pointLight(色1, 色2, 色3, x, y, z)
    noStroke();//輪郭・外縁を描かない
    if(!piano.isPlaying()){//もし金平糖の精の踊りが流れていなかったら
      ps.init();//様々な変数の初期化
      piano.amp(0.05);//音量調整
      for(int i = 0; i< ps.notes.length; i++){
        ps.notes[i].init(ps.base_time);//ノーツの変数初期化
      }
       ps.base_time = millis();//金平糖の精の踊りが流れ始める時間測定
       piano.play();//金平糖の精の踊りを流す
    }
    ps.draw1();//プレイ画面描写
  }else if(ps.scene == 1){//結果画面
    background(360);//白
    camera(
    0, -50,  100,
    0, -50, 0,
    0, 1,  0);    
    lights();
    if(ps.count == 0){//パーフェクトやグッドなどの数を数えるのを一回のみ行いたいので、このように書きました。
      ps.calcResult();//パーフェクトやグッドなどの数を数える。calcResult内でcountが1になるので、一回しか実行されない
    }
   ps.drawResult();//結果描写
  }
}

void keyPressed(){
}

void mousePressed(){
}
