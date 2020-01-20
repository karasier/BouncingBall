// ボールの衝突シミュレーション

int N = 5; // ボールの数
float e = 0.7; // 反発係数
float damp = 0.95; // 床の摩擦
float threshold = 0.01/frameRate;
PVector gravity = new PVector(0.0, 9.8/frameRate); // 重力
float min = 20; // ボールの半径(最小値)
float max = 100; // ボールの半径(最大値)
Ball[] ball = new Ball[N];

void setup()
{
  size(700, 700);
  frameRate(60);

  // インスタンス生成
  for (int i = 0; i < N; i++)
  {
    ball[i] = new Ball( random(min, max) );
  }
}

void draw()
{
  N = ball.length;
  background(170);
  for (int i = 0; i < N; i++)
  { 
    ball[i].update();
    ball[i].show();
    collide(); // ボール同士の衝突判定
  }
}

// マウスクリックでボールを増やせる
void mouseClicked()
{
  ball = (Ball[])append(ball, new Ball(random(min,max)));
  ball[ball.length-1].position = new PVector(mouseX,mouseY);
}

// ボール同士の衝突判定用関数
void collide()
{
  for(int i = 0; i < N; i++)
  {
    for(int j = i + 1; j < N; j++)
    {
      // 2つのボール間の直線距離を計算
      float d = PVector.dist(ball[i].position, ball[j].position);
      
      // ボール間の直線距離がボールの半径の和以下の場合衝突となる
      if(d < ball[i].r + ball[j].r)
      {
        float overlap = ball[i].r + ball[j].r - d; // ボールのめり込み量
        PVector vector = PVector.sub(ball[i].position, ball[j].position); // ボール j からボール i へのベクトル        
        
        vector.normalize(); // ベクトルの正規化                
        
        // ボール同士が重ならない位置まで移動
        ball[i].position.add(vector.mult(overlap/2.0));
        ball[j].position.sub(vector.mult(overlap/2.0));        
        
        // 速度の方向を変更        
        ball[i].velocity.rotate(random(0,TWO_PI));
        ball[j].velocity.rotate(random(0,TWO_PI));
      }
    }
  }
}


// ボールのクラス
class Ball
{  
  float r; // ボールの半径
  float x, y; // ボールの座標
  PVector position; // ボールの座標
  PVector velocity; // ボールの速度
  boolean x_flag, y_flag; // 衝突フラグ
  float R,G,B; // ボールの色

  // コンストラクタ
  Ball(float r)
  {
    this.r = r;

    // 座標をランダムに初期化
    position = new PVector(random(r, width - r), random(r, height - r));

    // 速度をランダムに初期化
    velocity = new PVector(random(-300, 300)/frameRate, random(-300, 300)/frameRate);
    
    R = random(0,255);
    G = random(0,255);
    B = random(0,255);
  }

  // ボールを描画
  void show()
  {
    fill(R,G,B);
    ellipse(position.x, position.y, 2 * r, 2 * r);
  }

  // ボールの位置と速度を更新
  void update()
  {
    velocity.add(gravity);
    position.add(velocity);    

    // ボールの衝突判定
    bound();

    // 速度がある程度小さくなったら停止させる
    if (Math.abs(velocity.x) < threshold)
      velocity.x = 0;

    if (Math.abs(velocity.y) < threshold)
      velocity.y = 0;
  }

  // ボールの衝突判定用関数
  // ボールが画面から出たらボールを画面内に戻して
  // 速度を反転させる
  void bound()
  {
    if (position.x + r > width)
    {
      position.x = width - r;
      x_flag = true;
    }

    if (position.x - r < 0)
    {
      position.x = r;
      x_flag = true;
    }

    if (position.y + r > height)
    {
      position.y = height - r;
      velocity.x *= damp;
      y_flag = true;
    }

    if (position.y - r < 0)
    {
      position.y = r;
      velocity.x *= damp;
      y_flag = true;
    }

    invert();
  }

  // ボールの速度を変更する関数
  void invert()
  {
    if (x_flag)
      velocity.x = - e * velocity.x;

    if (y_flag)    
      velocity.y = - e * velocity.y;          
    
    x_flag = false;
    y_flag = false;
  }
}
