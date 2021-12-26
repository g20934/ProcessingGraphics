import processing.sound.*;
class PlayScreen{
  //フィールド
  int rectL = 150;//レーンの横の長さ
  int rectW = 250;//レーンの縦の長さ
  SoundFile k_piano, k_sound1, k_sound2, k_sound3;//ピアノと効果音
  SoundFile[] k_sounds = { k_sound1, k_sound2, k_sound3};//効果音を入れておく配列
  //ノーツが流れるタイミングやレーンを2つに分けているのは、曲の最初の方と後半のところで同じフレーズが出てくるため、前半の数値を再利用して後半の最初の方の数値を決めていくほうが楽だと考えたからです。
  double[] time = {8.5, 8.75, 9, 9.5, 10, 10.5, 11, 11.25,  11.5, 12, 12.25, 12.5,  13, 13.25, 13.5, 14, 14.5, 15, 16.5, 16.75, 17, 17.5, 18, 18.5, 19, 19.25,  19.5, 20, 20.25, 20.5,  21, 21.25, 21.5, 22, 22.5, 23};//ノーツが流れるタイミング（前半）
  double[] time2 = {32.5, 32.75, 33, 33.5, 34.5, 34.75, 35, 35.5, 36.5, 36.75, 37, 37.5, 38.5, 39};//ノーツが流れるタイミング（後半最後の方）
  double[] timing = new double[54 + time2.length];//ノーツが流れるタイミングを保持する配列の箱を作る
  int[] k_notes_z1 = {0, 1, 0, 0, 1, 2, 3, 3, 3,  4, 4, 4, 5, 5, 5, 5, 2, 5, 4, 5,  4, 4, 3, 4, 0, 0, 0, 1, 1, 1, 2, 2, 2, 2, 0, 2};//ノーツの流れていくるレーン（前半）　0が左側、5が右側です
  int[] k_notes_z2 = {0, 1, 0, 2, 1, 2, 1, 3, 2, 3, 2, 4, 5, 2};//ノーツの流れていくるレーン（後半最後の方）
  int[] notes_z =new int[timing.length];//ノーツの流れていくるレーンの情報を保持する配列の箱を作る
  int Combo = 0;//コンボ数（ミスせず連続して音符を処理した回数、今回はPERFECTもしくはGOODの判定が続いた数）
  int maxCombo = 0;//コンボ数の中でも、曲中最も高いコンボ数
  int temp ;//一個前のnotesMaxNumを入れておく変数
  int notesMaxNum = 0;//基準線（notev.x=0）に一番近いノーツの配列の添字
  int hue = 60;//色相
  int sat = 0;//彩度
  int bri = 0;//明度
  int alpha = 100;//不透明度
  int judge1 = 8;//判定PERFECTに使われる数値
  int judge2 = 15;//判定GOODに使われる数値
  int totalScore = 0;//総スコア　全ノーツのスコアを集計したもの
  int pattern = 0;//ノーツに対して、キーを押さなかった（MISS）（pattern = 1)かそうでないか（pattern = 2)
  String showMessage ="";//画面に表示するノーツに対する評価（PERFECTなど）（一個前のノーツがMISSかどうかで分岐している）
  int temp2 = 0;//一個前のノーツがMISSだった場合、一個前のノーツの添字を覚えておく
  int hp = 100;//HPが0になると曲が強制的に終了する
  int perfectNum = 0;//ノーツに対する判定PERFECTの個数
  int goodNum = 0;//ノーツに対する判定GOODの個数
  int badNum = 0;//ノーツに対する判定BADの個数
  int missNum = 0;//ノーツに対する判定MISSの個数
  int highscore = -700;//実行中、最も高いスコア（ハイスコア）を記録する変数　ノーツが68個流れてきて、badが-10より、初期値は必ず下回ることのない-700とした。
  String result =  "";//HPが0になりましたorGAME CLEAR!!
  int count = 0;//パーフェクトやグッドなどの数を数えるのを一回のみ行いたいため、calcResult()が実行された回数を記録する変数を用意
  float base_time = 0;//金平糖の精の踊りが流れ始める時間測定
  note notes[];//note型の配列
  int scene = -1;//scene -1: ホーム画面　0:ゲーム画面　1:結果表示画面
  
  //メソッド
  //コンストラクタ
  PlayScreen(SoundFile piano, SoundFile sound1, SoundFile sound2, SoundFile sound3){
    for(int i = 0; i < timing.length; i++){//曲の最初の方と後半のところで同じフレーズが出てくるため、前半の数値を再利用して後半の最初の方の数値を決めていくほうが楽だと考え、以下のように計算しました
      if(i < time.length){//最初の方のフレーズには、timeとk_notes_z1を使う
        timing[i] = time[i];
        notes_z[i] = k_notes_z1[i];
      }else if ( i < 54){//time.length<i<54は、曲の最初の方で出てくるフレーズと同じものです。
        timing[i] = time[i - time.length] + 24.5 - time[0];//time[time.length]は、曲が始まってから24.5秒後。
        notes_z[i] = k_notes_z1[i - k_notes_z1.length];
      }else{//最後の方のフレーズには、time２とk_notes_z2を使う
        timing[i] = time2[i - 54];
        notes_z[i] = k_notes_z2[i -54];
      }
    }
    
    
    //コンストラクタからの情報をPlayScreenの変数に代入
    k_piano = piano;
    k_sounds[0] = sound1;
    k_sounds[1] = sound2;
    k_sounds[2] = sound3;
    for(int i = 0; i < k_sounds.length; i++){
       k_sounds[i].amp(0.05);//音量
    }

    notes = new note[notes_z.length];//note型のインスタンスが入る箱を作る
    for(int i = 0; i <notes.length ; i++){
      notes[i] = new note(timing[i], notes_z[i], base_time, k_sounds[0]);//ノーツのインスタンス生成
    }
  }
  
  void draw1(){//プレイ画面描写
    drawBackground();//背景を描くメソッドを呼び出す
    noStroke();
    for(int i = 0; i <notes.length; i++){
      //クラスPlayScreenの8５~89行目をコメントアウトすると、hpが0以下になってもゲームが終了しないので、調整がしやすいと思います。クラスnoteの45~47行目を使うと、notev.x=0でタンバリンが鳴るので、調整しやすいです。
      if(millis() >= base_time + timing[i]*1000 -4500){//4500と書かれているところを調節すると、ノーツが描き始められる時間が調節できます。4000が基準値（1秒で120ピクセル移動し（フレームレート120、notev.xは一ずつ増えていく）、480ピクセル移動する必要がある(notev.x=-480より)ので、4000ms必要）です。値が大きいほどノーツが描き始められるのが早くなり、値が小さいほどノーツが描き始められるのが遅くなります。
          notes[i].draw();//ノーツを描くメソッドを呼び出す
      }
    }
    calc();//判定するメソッドを呼び出す
    
    //HPが0以下になったらゲーム終了→結果画面へ遷移
    if(hp <= 0){
      scene = 1;
      k_piano.stop();
      result = "HPが0になりました";
    }
    
    //最後のノーツが通ったら、結果画面へ遷移
    if(notes[notes.length - 1].notev.x >= 240){//最後のノーツのnotev.xが0を通ってから２秒後
      scene = 1;
      result = "GAME CLEAR!!";
    }
  }
  
  void drawBackground(){//プレイ画面の背景を描くメソッド  
    //曲名表示
    pushMatrix();
    textSize(7);
    translate(-rectW/2, -50, rectL/2 + 95);
    rotateY(radians(90));
    rotateX(radians(15));
    text("Dance Of The Sugar Plum Fairy", 0, 0, 0);
    
    translate(0, 5, 0);
    textSize(5);
    text("バレエ組曲「くるみ割り人形」より「金平糖の精の踊り」", 0, 0, 0);
    
    translate(0, 5, 0);
    text("作曲者：チャイコフスキー", 0, 0, 0);
    popMatrix();
    
    
    //地面
    pushMatrix();
    rotateX(radians(90));
    translate(-rectW,-rectL/2, 0);
    fill(color(180, 100, 100, alpha - 40));
    rect(0, 0, rectW, rectL);
    popMatrix();
    
    //線
    //z軸に沿った線（白）
    strokeWeight(2);
    stroke( color(hue,sat, 100, alpha) );
    line(0,0,-rectL/2,0,0, rectL/2);
    
     //判定がPERFECTになる基準線（黄）
    stroke( color(hue,100, 100, alpha) );
    line(-judge1,0,-rectL/2,-judge1,0, rectL/2);
    line(judge1,0,-rectL/2,judge1,0, rectL/2);
    
    //判定がGOODになる基準線（緑）
    stroke( color(hue*2,100, 100, alpha) );
    line(-judge2,0,-rectL/2,-judge2,0, rectL/2);
    line(judge2,0,-rectL/2,judge2,0, rectL/2);
    
    //各レーンを識別するための線（白）
    stroke( color(hue,sat, 100, alpha) );
    for(int i = -1; i < 6; i++){
     line(0,0,25 * (i -2) ,-rectW,0, 25 * (i -2));
    }
    //各レーンの文字
    pushMatrix();
    noStroke();
    fill(color(180, 0, 100, alpha));
    textSize(10);
    translate(0, 0, -75-25/2);
    rotateY(radians(90));
     rotateX(radians(15));
    for(int i = 0; i < 6; i++){
      translate(-25, 0, 0);
      text(notes[0].keysB[i], 0, 0, 0);
    }
    popMatrix();
    
  }
  
  void calc(){//x座標でノーツの判定するメソッド
    float max = -500;//xの座標が-500よりも下回ることはない（notev.xの初期値-480より）ので、-500とした
    for(int i = 0; i < notes.length; i++){
      if((notes[i].notev.x < judge2) && (max < notes[i].notev.x)){//一番自分側（xが一番大きい)ノーツを調べる（GOOD判定ライン（正の方）x＝15を超えないノーツ）
        max = notes[i].notev.x;
        notesMaxNum = i;//一番自分側のノーツの添字を代入
      }
    }
    if(notesMaxNum != temp && notes[temp].score <= 0){//コンボ数処理 notesMaxNumより前のノーツがMISSだった場合
      if(maxCombo < Combo){//Comboがマックスコンボより大きいか
        maxCombo = Combo;
      }
      Combo = 0;
   }
    
    if(notes[temp].notev.x >= judge2 && notes[temp].score == 0){//ノーツに対して、キーを押さなかった時→MISS判定
      pattern = 1;
      notes[temp].score = -10;
      notes[temp].message = "  MISS  ";
      temp2 = temp;//キーを押さなかったノーツの添字を代入
      totalScore += notes[temp].score;//総スコアに加算
      hp -= 10;
      }
      temp = notesMaxNum;
    
    if(notes[notesMaxNum].score == 0 &&keyPressed && (key==notes[notesMaxNum].n_keyS || key==notes[notesMaxNum].n_keyB) ){//MISS以外の判定処理　ノーツのスコアが0　かつ　キーを押した時　かつ　キーのレーンのキーを押した時（大文字小文字どちらでも可）
     pattern = 2;
     notes[notesMaxNum].n_alpha = 0;//ノーツが透明になる
      if(notes[notesMaxNum].notev.x < judge1 &&notes[notesMaxNum].notev.x > -judge1){
        k_sounds[0].play();//効果音（タンバリン）を鳴らす
        notes[notesMaxNum].score = 50;
        notes[notesMaxNum].message = "PERFECT!";
        Combo++;
        if(maxCombo < Combo){
        maxCombo = Combo;
      }
      }else if(notes[notesMaxNum].notev.x < judge2 &&notes[notesMaxNum].notev.x > -judge2){
        k_sounds[1].play();//効果音（カウベル）を鳴らす
        notes[notesMaxNum].score = 10;
        notes[notesMaxNum].message = "  GOOD!  ";
        Combo++;
        if(maxCombo < Combo){
        maxCombo = Combo;
      }
      }else{
        k_sounds[2].play();//効果音（変な音）を鳴らす
        notes[notesMaxNum].score = -5;
        notes[notesMaxNum].message = "  BAD!  ";
        hp -= 5;
        if(maxCombo < Combo){
        maxCombo = Combo;
      }
        Combo = 0;//コンボ数を0にする
      }totalScore += notes[notesMaxNum].score;
    }
      if(pattern == 1){//もし判定がMISSなら
          showMessage = notes[temp2].message;//一個前のノーツの判定を代入
      }else{//それ以外の判定なら
        showMessage = notes[temp].message;//temp = notesMaxNumの判定を代入
      } 
      pushMatrix();
       fill(color(hue, sat, bri, alpha));//黒
       textSize(8);
       translate(-10, -45, 16);
       rotateY(radians(90));
       rotateX(radians(15));
       text(showMessage, 0, 0, 0);//ノーツに対する判定を表示
       popMatrix();  


    textSize(5);
    
    pushMatrix();
    fill(color(hue, sat, bri, alpha));
    translate(-rectW/2, -30, rectL/2 + 100);
    rotateY(radians(90));
    rotateX(radians(15));
    text("SCORE: " + totalScore, 0, 0, 0);//総スコア表示
 
    translate(0, 5, 0);
    text("COMBO: " + Combo, 0, 0, 0);//コンボ数表示
    
    translate(0, 5, 0);
    text("HP: " + hp, 0, 0, 0);//HP表示
    popMatrix();  

  }
  
  void calcResult(){//PERFECTなどの判定の数を計算するメソッド
    for(int i = 0; i < notes.length; i++){
      if(notes[i].score == 50){
        perfectNum++;
      }else if(notes[i].score == 10){
        goodNum++;
      }else if(notes[i].score == -5){
        badNum++;
      }else if(notes[i].score == -10){
        missNum++;
      }
    }
    count++;//このメソッドは一回のみ実行されれば良い
  }
  
  
  void drawResult(){//結果画面を描写するメソッド
    //結果
    pushMatrix();
    textSize(5);
    translate(-100, -100, 0);
    fill(color(210, 100, 0, 50));
    text("RESULT<バレエ組曲「くるみ割り人形」より「金平糖の精の踊り」>", 0, 0, 0);
    
    fill(color(210, 100, 100, 50));
    translate(4, 10, 0);
    text("Score（今回のスコア）:" + totalScore, 0, 0, 0);
    
    fill(color(210, 100, 0, 50));
    translate(0, 8, 0);
    if(highscore < totalScore){//もしハイスコアが総スコアより高ければ
      highscore = totalScore;
    }
    text("High Score（実行中最も高いスコア）:" + highscore, 0, 0, 0);
    
    fill(color(180, 100, 50, 50));
    translate(0, 8, 0);
    text("PERFECT: " + perfectNum, 0, 0, 0);//PERFECTの数　以下310行目まで各判定の数を表すためのコード
    
    translate(0, 8, 0);
    text("GOOD: " + goodNum, 0, 0, 0);
    
    translate(0, 8, 0);
    text("BAD: " + badNum, 0, 0, 0);
    
    translate(0, 8, 0);
    text("MISS: " + missNum, 0, 0, 0);
    
    fill(color(210, 100, 100, 50));
    translate(0, 8, 0);
    text("MAX COMBO: " + maxCombo + "/" + notes.length, 0, 0, 0);//マックスコンボ数　ノーツの全体数と比べると分かりやすいと思い、このように書きました
    
    popMatrix();
   
    //スコアなどを書く枠
    pushMatrix();
    stroke(color(210, 100, 100, 50) );
    noFill();
    translate(-103, -98, -5);
    rect(0, 0, 100, 60);
    popMatrix();
    
    //message
    fill(color(210, 100, 0, 50));
    text(result, -100, -30, 0);//HPが0になりましたorGAME CLEAR!!
    
    //リトライ、最初の画面に戻るボタン
    pushMatrix();
    textSize(3);
    stroke(color(210, 0, 0, 50));
    translate(-100, -25, 0);
    text("リトライ、ホーム画面に戻る場合は下の各ボタンをマウスでクリックしてください", 0, 0, 0);
    
    noFill();
    translate(0,-10, 0);
    translate(0, 15, 0);
    rect(0, 0, 45, 20);
    
    textSize(10);
    translate(7,13, 0);
    text("RETRY", 0, 0, 0);
 
    translate(55-7, -13, 0);
    rect(0, 0, 45, 20);
    
    textSize(6);
    translate(10,10, 0);
    text("RETURN", 0, 0, 0);
    
    translate(-7, 5, 0);
    text("HOME SCREEN", 0, 0, 0);
    popMatrix();
      
    pushMatrix();
    image(imgBallerina, 5, -100);
    popMatrix();
    
     if(mousePressed && (mouseY > 415 && mouseY < 515)){
      if(mouseX > 38 && mouseX < 251){//RETRYのボタン
        scene = 0;//プレイ画面に戻り、もう一度プレイする
      }else if(mouseX > 300 && mouseX < 515){//RETURN HOME SCREENのボタン
        scene = -1;//ホーム画面に戻る
      }
    }
  }
  
  void init(){//初期化処理
    Combo = 0;
    maxCombo = 0;
    temp = 0;
    notesMaxNum = 0;
     pattern = 0;
     showMessage ="";
     temp2 = 0;
     hp = 100;
     perfectNum = 0;
     goodNum = 0;
     badNum = 0;
     missNum = 0;
     count = 0;
     if(highscore < totalScore){//実行中最も高いスコアを記録する
       highscore = totalScore;
     }
     totalScore = 0;
  }
  
  void drawHome(){//ホーム画面の描写を行うメソッド
    fill(color(0, 0, 100, 100));
    pushMatrix();
    textSize(10);
    translate(-30,-90, 0);
    text("Sound Game", 0, 0, 0);
    
    textSize(4);
    translate(90, 1, 0);
    fill(color(0, 0, 0, 80));
    translate(-150,10, 0);
   text("音ゲーを作りました。曲はチャイコフスキー作曲の『バレエ組曲「くるみ割り人形」より「金平糖の精の踊り」』です。", 0, 0, 0);
   
   translate(0,5, 0);
   fill(color(240, 100, 100, 80));
   text("【操作方法 】", 0, 0, 0);
   
   fill(color(0, 0, 0, 80));
   translate(0,5, 0);
   text("・音楽に合わせて流れるノーツ（直方体）をタイミング良くキーボードで叩くゲームです。", 0, 0, 0);
   
    translate(0,5, 0);
    text("・使うキーはS, D, F, J, K, Lです。大文字・小文字どちらでも入力可能です。", 0, 0, 0);
    
    translate(0, 5, 0);
    text("　ノーツが流れてきたレーンに書いてあるキーを押してください。", 0, 0, 0);
    
     fill(color(240, 100, 100, 80));
    translate(0, 5, 0);
    text("【判定について】", 0, 0, 0);
    
    fill(color(0, 0, 0, 80));
    translate(0, 5, 0);
    text("・ガイドとして2色の線を引いています。", 0, 0, 0);
    
    translate(0, 5, 0);
    text("　黄色線の間でキーを押せるとPERFECT、緑線の間だとGOOD、", 0, 0, 0);
    
    translate(0, 5, 0);
    text("　それ以外の場所でキーを押すとBAD、キーを押さないとMISSという評価になります。", 0, 0, 0);
    
    translate(0, 5, 0);
    text("・PERFECTやGOODが続いた回数がCOMBOです。評価がBAD、MISSの時HPが減り、COMBOが0になります。", 0, 0, 0);
    
    translate(0, 5, 0);
    text("・音とノーツのズレがひどい場合はクラスPlayScreenのメソッドdraw1内の数値（78行目）を調節して頂けると幸いです", 0, 0, 0);
    
    translate(0, 5, 0);
     fill(color(240, 100, 100, 80));
    text("【スコア計算方法】", 0, 0, 0);
    
    translate(0, 5, 0);
    fill(color(0, 0, 0, 80));
    text("総スコア=PERFECTの個数 * 50 + GOODの個数 * 10 + BADの個数  * (-5) + MISSの個数  * (-10)", 0, 0, 0);
    
    translate(60, 10, 0);
    text("下のボタンを押すと始まります！", 0, 0, 0);
    
    translate(1, 2, 0);
    noFill();
    strokeWeight(3);
    stroke(color(210, 100, 100, 50));
    rect(0, 0, 50, 10);
    
    textSize(8);
    translate(13, 8, 0);
    fill(color(0, 0, 100, 100));
    text("START", 0, 0, 0);
    popMatrix();
   
   
   if(mousePressed  && (mouseX > 375 && mouseX < 615) && (mouseY > 480 && mouseY < 530)){//STARTボタンの範囲内を押すと、プレイ画面に遷移する
     scene = 0;
   }
  }
};
