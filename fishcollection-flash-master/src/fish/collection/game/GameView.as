package fish.collection.game
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import fish.collection.game.view.Boid;
	
	
	public class GameView extends Sprite
	{
		private var _idelegate:GameInternalDelegate;
		private var _container:Sprite;
		
		// Boidの数
		private const NUMBOIDS:int = 40;
		// Boidクラス
		private var _boids:Vector.<Boid>;
		// 描画用Sprite
		//private var sprites:Array = new Array();
		//private var _fishes:Vector.<MovieClip>;
		
		// 魚描画レイヤー
		private var _fishLayer:Sprite;
		

		public function get view():Sprite {return _container;}
		
		public function GameView()
		{
			super();
		}
		
		/**
		 * 初期化
		 */
		public function initialize(idelegate:GameInternalDelegate):void
		{
			_idelegate = idelegate;
			_container = new Sprite();
			addChild(_container);
			
			// Boid初期設定
			var i:int;
			_boids = new Vector.<Boid>();
			//_fishes = new Vector.<MovieClip>();
			_fishLayer = new Sprite();
			for (i = 0; i < NUMBOIDS; i++) 
			{
				// Boid設定
				var b:Boid = new Boid();
				const ph:Number = i * 2.0 * Math.PI / NUMBOIDS;
				b.initialize( 
					200 + 90 * Math.cos(ph) * Math.sin(ph),
					200 + 40 * Math.sin(ph),
					90 * Math.cos(ph + Math.PI / 2 + 1),
					40 * Math.sin(ph + Math.PI / 2 + 1)
					);
				b.setFishCode('いまはなにも設定できない', 0.7);
				_fishLayer.addChild(b);
				_boids[i] = b;
				
				/*
				// 描画設定
				sprites[i] = new Sprite();
				_fishes[i] = new Deme();
				_fishes[i].scaleX = _fishes[i].scaleY = 0.7; 
				sprites[i].addChild(_fishes[i]);
				var g:Graphics = sprites[i].graphics;
				g.lineStyle(1, 0x0055ff);
				g.moveTo(4, 0); 
				g.lineTo(-3, -3);
				g.lineTo(-3, 3); 
				g.lineTo(4, 0); 
				g.lineTo(-8, 0);
				sprites[i].x = b.px;
				sprites[i].y = b.py;
				*/
			}
			/*
			_fishLayer = new Sprite();
			for (i = 0; i < NUMBOIDS; i++)
			{
				_fishLayer.addChild(sprites[i]);
			}
			*/
			_container.addChild(_fishLayer);
			
			/*
			// Starling test
			trace(stage);
			var myStarling:Starling = new Starling(hogeSprite, RootStage.stage);
			myStarling.start();
			*/
			
			// 毎フレーム処理イベント設定
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		/**
		 * 毎フレームイベントハンドラ
		 */
		public function onEnterFrame(ev:Event) : void 
		{ 
			// 毎フレーム関数
			frame(); 
		}
		
		/**
		 * 毎フレーム関数
		 */
		public function frame() : void 
		{
			var b:Boid;
			var i:int;
			for (i = 0; i < NUMBOIDS; i++) 
			{
				b = _boids[i];  
				b.force(_boids);
			}  
			
			// 回転値の差
			var rotationMargin:Number = .0;
			// 現在の回転値
			var currentRotaionVal:Number = .0;
			// 次の回転値
			var nextRotationVal:Number = .0;
			for (i = 0; i < NUMBOIDS; i++) 
			{             
				b = _boids[i];
				b.update();
				/*
				_boids[i].x = b.px;
				_boids[i].y = b.py;
				*/
				/*
				// 次の回転値
				nextRotationVal = Math.atan2(b.vy, b.vx) * 180 / Math.PI + 90;
				currentRotaionVal = _boids[i].rotation;
				// 現在の回転地との差(右回転:正 左回転:負)
				rotationMargin = (currentRotaionVal+360) - (nextRotationVal+360);
				_boids[i].fishMc.body_whole.rotation = nextRotationVal;
				
				_boids[i].fishMc.tail_whole.x = Util.smoothMoveFunc(_boids[i].fishMc.tail_whole.x, - 47.3 * Math.sin(nextRotationVal * Math.PI / 180.0), 0.2);
				_boids[i].fishMc.tail_whole.y = Util.smoothMoveFunc(_boids[i].fishMc.tail_whole.y, 47.3 * Math.cos(nextRotationVal * Math.PI / 180.0), 0.2);
				
				_boids[i].fishMc.tail_whole.rotation = Util.smoothMoveFunc(_boids[i].fishMc.tail_whole.rotation, nextRotationVal, 0.2);
				*/
				//trace(_fishes[i].tail_whole.x, _fishes[i].tail_whole.y);
				
				// 回転地を更新
				//sprites[i].rotation = nrv;
			}
		}
	}
}