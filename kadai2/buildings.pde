//建物を描画するクラス
//実行ごとに建物の高さや色が変化します
class buildings{
  int buildingNum = 10;//片側の道にあるビルの数（ビルは道の両側にあるので、合計の数はbuildingNum*2)
  float y[], hue[];//ビルの高さ、色
  buildings(){//コンストラクタ
    y = new float[buildingNum];
    hue = new float[buildingNum];
    for(int i = 0; i < buildingNum; i++){
      y[i] = random(10, 50);
      hue[i] = random(0, 360);
    }
    
  }
  
  void draw(){
    noLights();//ライト設定をリセット
    lights();//processingおすすめライトセット
    for(int i = 0; i < buildingNum; i++){
      //iが同じである2つのビルの高さと色は同じです
      //進行方向右側のビル
      pushMatrix();
      fill( color( hue[i],50,100,100 ));
      translate(40, -10, 30 - i*40);
      box( 10, y[i], 20);//box(x, y, z長さ)
      popMatrix();//コピーしたものを破棄して、保存していた座標系に戻す
      
      //進行方向左側のビル
      pushMatrix();
      fill( color( hue[i],50,100,100 ));
      translate(-40, -10, 30 - i * 40);
      box( 10, y[i], 20);//box(x, y, z長さ)
      popMatrix();//コピーしたものを破棄して、保存していた座標系に戻す
    }
  }
}
