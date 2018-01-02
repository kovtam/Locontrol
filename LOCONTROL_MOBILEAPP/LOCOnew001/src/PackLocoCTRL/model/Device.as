package PackLocoCTRL.model
{

	/**
	 * ...
	 * @author Tamas Kovacs
	 */



	import mx.collections.ArrayCollection;
	
	[Bindable]
	public class Device
	{
		public var loaded:Boolean = false;
		
		public var id:int;
		public var firstName:String;
		public var lastName:String;
		public var subsys:String;
		public var ipAddress:String;
		public var speed:String;
		public var direction:String;
		public var state1:String;
		public var sw1:String;
		public var sw2:String;
		public var picture:String;
		
		
		
	}
}