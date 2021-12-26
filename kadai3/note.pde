import processing.sound.*;
class note{
  //フィールド
  char keysS[] = {'l', 'k', 'j', 'f', 'd', 's'};//使用するキー小文字
  char keysB[] = {'L', 'K', 'J', 'F', 'D', 'S'};//使用するキー大文字
  double n_timing;//ノーツが流れるタイミング
  double n_z = 0;//ノーツのz軸の位置
  double score = 0;//ノーツに対するスコア
  float baseTime = 0;//金平糖の精の踊りが流れ始める時間
  PVector  notev, u;//ノーツのベクトル、ノーツが動いていくために加算していくベクトル
  char n_keyS;
  char n_keyB;
  String message ="";
  int n_alpha = 50;
  SoundFile n_tamb;
  
  //メソッド
  //コンストラクタ
  note(double timing, int z, float base_time, SoundFile tamb){
    n_timing = timing;
    n_z = z;
    n_keyS = keysS[z];//ノーツのレーンに割り当てられたキー小文字
    n_keyB = keysB[z];//ノーツのレーンに割り当てられたキー大文字
    n_tamb = tamb;
    baseTime = base_time;
    notev = new PVector(-480, -5, 25 * (z - 2) - 10);
    if(z >= 3){//計算上では25行目のみで良いのですが、カメラと焦点の設定より、レーンの中でも左側を流れるノーツが左側に寄ってしまったため、少し右側に寄せる調整を行いました
      notev.z = notev.z - 1.5*z;
    }
    u = new PVector(1, 0, 0);
  }
    
  void draw(){
      pushMatrix();
      fill(color(345, 77, 91, n_alpha));//n_alphaはキーが押されると0になり、ノーツは動き続けるが、透明になります
      translate(notev.x, notev.y, notev.z);
      box(10, 2, 20);
      popMatrix();
      //notev.x ++;
      notev.add(u);     
      //音ズレがひどい場合、下記をコメントではない状態にして、ノーツと音楽が合っているかどうかを確認できます。
      //合っていない場合は、クラスPlayScreenのメソッドdraw1内の数値（78行目）を調節していただきたいです。
      //クラスPlayScreenの85~89行目をコメントアウトすると、hpが0以下になってもゲームが終了しないので、調整がしやすいと思います。
      /*
      if(notev.x == 0){
        n_tamb.play();
      }
      */
      
     
  }
  
  void init(float base_time){//初期化処理
    score = 0;
    baseTime = base_time;
    notev.x = -480;
    message = "";
    n_alpha = 50;
  }
};
