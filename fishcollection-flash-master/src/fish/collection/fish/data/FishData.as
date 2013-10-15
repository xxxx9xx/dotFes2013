package fish.collection.fish.data
{
	/**
	 * 各金魚のデータ 
	 * @author bamba misaki
	 */
	public class FishData
	{
		public var code:String;
		public var name:String;
		public var part:Object;
		
		public function FishData(data:Object = null)
		{
			if (!data) return;
			if (data.code) 
				code = data.code;
			if (data.name) 
				name = data.name;
			if (data.part) 
				part = data.part;
		}
	}
}