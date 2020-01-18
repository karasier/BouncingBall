int N = 10; // ボールの数
float e = 0.7; // 反発係数
float damp = 0.95; // 床の減衰率
float threshold = 0.01/frameRate;
PVector gravity = new PVector(0.0, 9.8/frameRate); // 重力
Ball[] ball = new Ball[N];

void setup()
{
  size(500, 500);
  frameRate(60);
  fill(255);

  // インスタンス生成
  for (int i = 0; i < N; i++)
  {
    ball[i] = new Ball( random(1, 20) );
  }
}

void draw()
{
  background(170);
  for (int i = 0; i < N; i++)
  { 
    ball[i].update();
    ball[i].show();
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


  // コンストラクタ
  Ball(float r)
  {
    this.r = r;

    // 座標をランダムに初期化
    position = new PVector(random(r, width - r), random(r, height - r));

    // 速度をランダムに初期化
    velocity = new PVector(random(-10, 10), random(-10, 10));
  }

  // ボールを描画
  void show()
  {
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

  // ボールの衝突判定用
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
      y_flag = true;
    }

    invert();
  }

  // ボールの速度を変更
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
