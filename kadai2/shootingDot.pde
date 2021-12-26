//movingDotの不透明度が0に近づいてきたら、花火を開く様子を表現するクラス
class shootingDot{
  PVector pos, vel,  gr, temp; //位置、速度、重力
  float hue, bright, size;//色相、彩度、明るさ（明度）、球体の大きさ
  shootingDot(){//コンストラクタ
    init();//movingDotと同様の理由で、init()で変数の初期化を行っています
  }
  
  void init(){//変数の初期化
    pos = new PVector(0,0,0);
    vel = new PVector(random(-1, 1), random(-1, 1), random(-1, 1));//ベクトルの向き
    vel.normalize();//ベクトルの正規化（長さ１にする）
    vel.mult(random(0.5, 1.5));//ベクトルの大きさ（距離）
    gr = new PVector(0, 0.098, 0);
    bright = 100;
    hue =0;
  }
  
  void draw(float mdZ){
    if(mdZ > -600){//カメラが止まる前の打ち上げ
      calc2();
    }else{//カメラが止まった後の打ち上げ
      calc1();
    }
    pos.add(vel);
    
    //球体
    pushMatrix();//元々の座標系のコピー、保存
    //コピーされた座標系で色々動かす
    fill(color(hue, 100, bright, 100));
    translate(pos.x, pos.y - 80, mdZ);
    //println(mdZ);
    sphere(size);//sphere(半径）;
    popMatrix();//コピーしたものを破棄して、保存していた座標系に戻す
  }
  
  void calc1(){//花ひらいた後に、重力に沿って落ちていくような花火
    size = 2;
    hue = random(0, 360);
    bright -= 0.2;   
    //中心から一定の距離になったら落ちていくようにする
    temp = pos.copy();//自分自身のベクトル（現在位置）をtmpに仮置きして、tmpを計算に使っている
    temp.add(vel);//速度を足している
    float dist = temp.mag();//距離判定 mag()ベクトルの大きさ（矢印の長さ）を計算するメソッド
    if(dist > 50 &&  vel.y > 0){//y軸が下向きが正なので、下に下がっていく球体
      vel.add(gr);
    }else if(dist > 50 &&  vel.y < 0){//上に上がっていく球体
      vel.y *= -1;//逆向きの移動にする
      vel.add(gr);
    }    
  }
  
  void calc2(){//花ひらいた後に、消える花火
    size = 1;
    //中心から一定の距離になったら①色がキラキラするようにする②yを大きな値にして、見えなくする
    temp = pos.copy();
    temp.add(vel);
    float dist = temp.mag();
    if(dist > 50){//②見えなくする
      pos.y = 1000;//見えなくする  
    }else if(dist > 30){//①色キラキラ
      hue = (hue + 10 )% 360;//キラキラ
    }
  }
}
