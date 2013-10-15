package fish.collection.fish
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.utils.getDefinitionByName;
	
	import fish.collection.fish.data.BodyPositionData;
	import fish.collection.fish.data.FishData;

	/**
	 * 金魚を生成
	 * @author bamba misaki
	 */
	public class FishView extends Sprite
	{
		//=========================================================
		// VARIABLES
		//=========================================================
		private var _container:Sprite;
		private var _data:FishData;
		private var _partData:Object;
		private var _positionData:BodyPositionData;
		private var _baceFish:BaseFishView;
		private var _head:Sprite;
		private var _body:Sprite;
		private var _rHand:Sprite;
		private var _lHand:Sprite;
		private var _tail:Sprite;
		
		//=========================================================
		// GETTER/SETTER
		//=========================================================
		public function get view():Sprite {return _container;}
		
		//===========================================================
		// PUBLIC METHODS
		//===========================================================
		public function FishView()
		{
		}
		
		/**
		 * 初期化 
		 */
		public function initialize(data:FishData):void
		{
			// データ
			_data = data;
			_partData = _data.part;
			
			_container = new Sprite();
			addChild(_container);

			// 金魚の骨組み
			_baceFish = new BaseFishView();
			
			// 各パーツ
			_head = new Sprite();
			_body = new Sprite();
			_rHand = new Sprite();
			_lHand = new Sprite();
			_tail = new Sprite();
			
			// 各パーツのコピーを生成
			copyShapes(_head, _baceFish.head, true, true); 
			copyShapes(_body, _baceFish.body, true, true); 
			copyShapes(_rHand, _baceFish.rHand, true, true); 
			copyShapes(_lHand, _baceFish.lHand, true, true); 
			copyShapes(_tail, _baceFish.tail, true, true);
		}
		
		/**
		 * 金魚を表示 
		 */
		public function show():void
		{
			while (numChildren > 0)
				removeChildAt(0);
			
			// 各パーツ表示
			showPart(_head);
			showPart(_body);
			showPart(_rHand);
			showPart(_lHand);
			showPart(_tail);

			_head.addChild(addParts(_data.code, 'head'));
			_body.addChild(addParts(_data.code, 'body'));
			_rHand.addChild(addParts(_data.code, 'rHand'));
			_lHand.addChild(addParts(_data.code, 'lHand'));
			_tail.addChild(addParts(_data.code, 'tail'));
		}
		
		/**
		 * clean 
		 */
		public function clean():void
		{
			removeAllChild(this);
			if (_container)
				removeAllChild(_container);
			_container = null;
			if (_baceFish)
				_baceFish.clean();
			_baceFish = null;
			_head = null;
			_body = null;
			_rHand = null;
			_lHand = null;
			_tail = null;
		}
		
		//===========================================================
		// PRIVATE METHODS
		//===========================================================
		/**
		 * コンテナ c2 に所属するオブジェクトを c1 に移動します。　
		 */
		private function copyShapes(
			c1:DisplayObjectContainer,
			c2:DisplayObjectContainer,
			shapeOnly:Boolean = false,
			keepPosition:Boolean = false):void
		{
			if (keepPosition)
			{
				c1.transform.matrix = c2.transform.matrix;
			}
			
			if (c2.name.indexOf("instance") < 0)
			{
				c1.name = c2.name;
			}
			
			while (c2.numChildren > 0)
			{
				var dobj:DisplayObject = c2.getChildAt(0);
				var name:String = dobj.name;
				var ct:ColorTransform = null;

				if (shapeOnly && dobj is MovieClip)
				{
					var mat:Matrix = dobj.transform.matrix;
					var c3:MovieClip = MovieClip(dobj);
					if (c3.totalFrames > 1)
						c1.addChild(c3);
					else
					{
						while (c3.numChildren > 0)
						{
							var c3c:DisplayObject = c3.getChildAt(0);
							var c3m:Matrix = c3c.transform.matrix;
							c3m.concat(mat);
							c3c.transform.matrix = c3m;
							c1.addChild(c3c);
						}
						c2.removeChild(dobj);
					}
				}
				else
				{
					c1.addChild(dobj);
				}
			}
		}
		
		/**
		 * 各パーツを表示 
		 * @param obj
		 * @param index
		 */
		private function showPart(obj:DisplayObject, index:int = -1):void
		{
			if (obj != null)
			{
				if (index == -1)
					_container.addChild(obj);
				else
					_container.addChildAt(obj, index);
			}
		}
		
		private function addParts(code:String, part:String):MovieClip
		{
			fish1_head;
			fish1_body;
			fish1_rHand;
			fish1_lHand;
			fish1_tail;
			
			var mcName:String = code + "_" + part;
			var myClass:Class = Class(getDefinitionByName(mcName));
			var mc:MovieClip = new myClass(); 
//			mc.x = _partData.part.x;
//			mc.y = _partData.part.y;
			return mc;
		}
	}
}