package fish.collection.game.view
{
	import fish.collection.game.util.Util;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;

	/**
	 * タスク
	 * 
	 * マウスから逃げていく
	 * マウスクリックで捕まえる(消える)
	 */
	public class Boid extends Sprite
	{
		// 整列パラメータ
		private const ALIGNMENT_X:Number = 0.2;
		private const ALIGNMENT_Y:Number = 0.2;
		// 分離パラメータ
		private const SEPARATION_X:Number = 0.9;
		private const SEPARATION_Y:Number = 0.9;
		// 結合パラメータ
		private const COHESION_X:Number = 0.2;
		private const COHESION_Y:Number = 0.2;
		// Boidの領域
		private const BOUNDING_WIDTH:int = 900;
		private const BOUNDING_HEIGHT:int = 600;
		
		// 座標
		private var _px:Number, _py:Number;
		// 速度
		private var _vx:Number, _vy:Number;
		private var _vxSmooth:Number, _vySmooth:Number;
		private var _vxSpring:Number, _vySpring:Number;
		
		// 加速度
		private var _ax:Number, _ay:Number;
		
		// ムービークリップ
		private var _fishMc:MovieClip;
		
		/**
		 * コンストラクタ
		 */
		public function Boid() 
		{
			super();
		}
		
		public function get fishMc():MovieClip
		{
			return _fishMc;
		}
		/**
		 * 初期化
		 * @param  : 
		 * @return 
		 */
		public function initialize(px:Number, py:Number, vx:Number, vy:Number):void 
		{
			_px = px;
			_py = py;
			_vx = vx;
			_vy = vy;
			_vxSmooth = vx;
			_vySmooth = vy;
			_vxSpring = vx;
			_vySpring = vy;
		}
		/**
		 * 魚の種類を決定
		 * @param fishCode : 魚のコード
		 * @return 
		 */
		public function setFishCode(fishCode:String, scale:Number = 0.7):void 
		{
			// とりあえず絶対Demeになる今は
			_fishMc = new Deme();
			_fishMc.scaleX = _fishMc.scaleY = scale;
			addChild(_fishMc);
		}
		
		/**
		 * 他のBoidからの影響
		 */
		public function force(boids:Vector.<Boid>) : void 
		{
			// 一番近いBoidを探す
			var nearlest:Boid = null;
			// 距離
			var dx:Number, dy:Number;
			var dist2:Number;	// 距離の自乗
			// 最短距離を保持する
			var mindist2:Number = Number.MAX_VALUE;
			// index用
			var i:String;
			// 探す用Boidインスタンス
			var b:Boid;
			var count:int = 0;
			var cx:Number = 0, cy:Number = 0;
			for (i in boids) 
			{
				// Boidを指定
				b = boids[i];
				if (b == this)	// 自分自身なら次に飛ぶ
					continue;
				// 指定したBoidまでの距離を算出
				dx = b._px - _px; 
				dy = b._py - _py;
				dist2 = dx * dx + dy * dy;
				// 最短距離より小さい場合
				if (dist2 < mindist2) 
				{
					mindist2 = dist2;
					// 直近のBoidを更新
					nearlest = b;
				}
				// 指定したBoidまでの距離が1500未満の場合
				if (dist2 < 1500) 
				{
					cx += b._px; 
					cy += b._py;
					count++;
				}
			}
			// 直近のBoidがいなければ抜ける
			if (nearlest == null)
				return;
			
			_ax = _ay = 0;
			// 直近のBoidの情報を保持
			var npx:Number = nearlest._px;
			var npy:Number = nearlest._py;
			var nvx:Number = nearlest._vx;
			var nvy:Number = nearlest._vy;            
			dx = (npx - _px);
			dy = (npy - _py);
			dist2 = dx * dx + dy * dy;
			// 遠すぎれば抜ける
			if (dist2 > 1500)
				return;
			
			// Separation(分離)
			var dist:Number = Math.sqrt(dist2);
			_ax += dx / dist * (dist - 30) * SEPARATION_X;
			_ay += dy / dist * (dist - 30) * SEPARATION_Y;
			
			// Alignment(整列)
			_ax += (nvx - _vx) * ALIGNMENT_X; 
			_ay += (nvy - _vy) * ALIGNMENT_Y;
			
			// Cohesion(結合)
			dx = (cx / count - _px); 
			dy = (cy / count - _py);
			_ax += dx * COHESION_X; 
			_ay += dy * COHESION_Y;
			_ax += 3 * (Math.random() - 0.5);
			_ay += 3 * (Math.random() - 0.5);
			
			// boundary(境界)
			if (_px < 50)
				_ax += (50 - _px) * 0.1;
			else if (_px > BOUNDING_WIDTH-50)
				_ax += (BOUNDING_WIDTH-50 - _px) * 0.1;
			if (_py < 50)
				_ay += (50 - _py) * 0.1;
			else if (_py > BOUNDING_HEIGHT-50)
				_ay += (BOUNDING_HEIGHT-50 - _py) * 0.1;
		}
		
		/**
		 * 自身の更新関数
		 */
		public function update() : void
		{
			_px += _vx * (1.0 / 5); 
			_py += _vy * (1.0 / 5);
			_vx += _ax * (1.0 / 5); 
			_vy += _ay * (1.0 / 5);
			
			// speed limit
			var v:Number = Math.sqrt(_vx * _vx + _vy * _vy);
			if (v > 25) 
			{
				_vx = _vx / v * 25;
				_vy = _vy / v * 25;
			} 
			else if (v < 8) 
			{
				_vx = _vx / v * 8;
				_vy = _vy / v * 8;
			}
			
			
			// 回転の更新
			var nextRotVal:Number = Math.atan2(_vy, _vx) * 180 / Math.PI + 90;
			var currentRotVal:Number = this.rotation;
			
			// 現在の回転地との差(右回転:正 左回転:負)
			var rotMargin:Number = (currentRotVal+360) - (nextRotVal+360);
			fishMc.body_whole.rotation = nextRotVal;
			
			fishMc.tail_whole.x = Util.smoothMoveFunc(fishMc.tail_whole.x, - 47.3 * Math.sin(nextRotVal * Math.PI / 180.0), 0.5);
			fishMc.tail_whole.y = Util.smoothMoveFunc(fishMc.tail_whole.y, 47.3 * Math.cos(nextRotVal * Math.PI / 180.0), 0.5);
			
			
			_vxSmooth += (_vx - _vxSpring) * 1.0;
			_vySmooth += (_vy - _vySpring) * 1.0;
			//_vySmooth = Util.smoothMoveFunc(_vySmooth, _vy, 0.05);
			
			var vs:Number = Math.sqrt(_vxSmooth * _vxSmooth + _vySmooth * _vySmooth);
			trace('vs', vs);
			if (vs > 50)
			{
				_vx += _ax * (2.0); 
				_vy += _ay * (2.0);
				trace('加速', _vx, _vy);
			}
			
			_vxSpring += _vxSmooth;
			_vySpring += _vySmooth;
			
			_vxSmooth *= 0.95;
			_vySmooth *= 0.95;
			
			var tailRotVal:Number = Math.atan2(_vySpring, _vxSpring) * 180 / Math.PI + 90;
			fishMc.tail_whole.rotation = tailRotVal;
			
			
			// 座標更新
			x = _px;
			y = _py;
		}
	}
}