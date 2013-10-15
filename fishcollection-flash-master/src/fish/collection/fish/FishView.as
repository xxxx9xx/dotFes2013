package fish.collection.fish
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.utils.getDefinitionByName;
	
	import fish.collection.fish.configuration.BodyConfiguration;
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
		private var _positionData:BodyPositionData;
		private var _baseFish:BaseFishView;
		private var _head:Sprite;
		private var _body:Sprite;
		private var _rFin:Sprite;
		private var _lFin:Sprite;
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
			
			_container = new Sprite();
			addChild(_container);

			// 金魚の骨組み
			_baseFish = new BaseFishView();
			_baseFish.type = _data.type;
			_baseFish.initialize();
			
			// 各パーツ
			_head = new Sprite();
			_body = new Sprite();
			_rFin = new Sprite();
			_lFin = new Sprite();
			_tail = new Sprite();
			
			// 各パーツのコピーを生成
			//copyShapes(_head, _baseFish.head, true, true); 
			copyShapes(_body, _baseFish.body, true, true); 
			//copyShapes(_rFin, _baseFish.rFin, true, true); 
			//copyShapes(_lFin, _baseFish.lFin, true, true); 
			copyShapes(_tail, _baseFish.tail, true, true);
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
			showPart(_rFin);
			showPart(_lFin);
			showPart(_tail);

			// MCを各パーツにアタッチ
			_head.addChild(addParts(_data.type, BodyConfiguration.HEAD));
			_body.addChild(addParts(_data.type, BodyConfiguration.BODY));
			_rFin.addChild(addParts(_data.type, BodyConfiguration.R_FIN));
			_lFin.addChild(addParts(_data.type, BodyConfiguration.L_FIN));
			_tail.addChild(addParts(_data.type, BodyConfiguration.TAIL));
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
			if (_baseFish)
				_baseFish.clean();
			_baseFish = null;
			_head = null;
			_body = null;
			_rFin = null;
			_lFin = null;
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
		
		/**
		 * MCを各パーツにアタッチ 
		 * @param code
		 * @param part
		 * @return 
		 */
		private function addParts(type:String, part:String):MovieClip
		{
			deme_body_1;
			deme_head_1;
			deme_rFin_1;
			deme_lFin_1;
			deme_tail_1;
			
			var mcName:String = type + "_" + part + "_" + "1";
			var myClass:Class = Class(getDefinitionByName(mcName));
			var mc:MovieClip = new myClass(); 
//			mc.x = _partData.part.x;
//			mc.y = _partData.part.y;
			return mc;
		}
	}
}