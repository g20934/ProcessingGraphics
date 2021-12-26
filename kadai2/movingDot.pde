//打ち上がった時の球体の動きを描画するクラス

class movingDot{
  PVector pos, vel,  gr; //位置、速度、重力
  float alpha;//不透明度

  movingDot(float z){//コンストラクタ
    init(z);//本来ならば、コンストラクタの中にinit()の中身を書くべきですが、変数の初期化をインスタンス生成時以外（キーが押されたときなど）にも行いたかったため、init()というメソッドを作成して変数の初期化を行いました。
  }
  
  void init(float z){//変数の初期化
    pos = new PVector(0, 0, z - 300);
    vel = new PVector(0, -5, 0);
    gr = new PVector(0, 0.95, 0);//0.98よりも0.95の方が重力に逆らっている感が出たため、0.95にしました
    alpha = 100;
  }
  
  void draw(){
    pos.add(vel);
    //球体
    pushMatrix();//元々の座標系のコピー、保存
    //コピーされた座標系で色々動かす
    fill(color(0, 0, 100, alpha));
    translate(pos.x, pos.y, pos.z);
    sphere(3);//sphere(半径）;
    popMatrix();//コピーしたものを破棄して、保存していた座標系に戻す
    
    vel.y *=  gr.y;//重力に合わせて速度を計算する
    alpha *= gr.y;//明度を重力に合わせる
    //尾を引いているようにするのは難しかったので、打ち上げる球体の動きと球体の明るさを重力に合わせるようにしてみました
    
    if(pos.y < -95){//花火の花が開く前には球体が見えなくなるようにする
      alpha = 0;
    }
  }
};
