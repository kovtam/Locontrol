package PackLocoCTRL.model 
{
	/**
	 * ...
	 * @author Tamas Kovacs
	 * 
	 * 
	 */
	
			import flash.events.HTTPStatusEvent;
			import flash.events.IOErrorEvent;
            import flash.events.SecurityErrorEvent;
            import spark.components.IItemRenderer;
            import flash.events.*;
			
			import flash.net.*;
	 
	 
	public class NetworkManager 
	{
		
		private var myRequest:URLRequest= new URLRequest("1.1.1.1");
			
		private	var myData:URLVariables = new URLVariables();
		
		//private	var loader:URLLoader = new URLLoader(myRequest);
		
		private var swr:Boolean = false;
		
		private var systemMessage_NM:String = "";
		
		private var statusInd_NM:String = "Inited";
		
		
		
		
		public function NetworkManager()
		{
			
			
			//myRequest.url = "http://"+ ipAddress;
			
			myRequest.data = myData;
												
			myRequest.method = URLRequestMethod.GET;
												
			//loader.dataFormat = URLLoaderDataFormat.VARIABLES;
			
			//
			//
			//loader.dataFormat = URLLoaderDataFormat.TEXT;
			//loader.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			//loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			//loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			//loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false,0, true);
			
		}
		
		public function set_myData(value:String):void {
                            
						myData.pin = value;
                    }
											
		
		public function get_systemMessage_NM():String {
                            
						return systemMessage_NM;
                    }
												
		
		public function get_statusInd_NM():String {
                            
						return statusInd_NM;
                    }			
					
					
		public function action_load_loader(ipAddress:String):String {
		
						
			
						statusInd_NM = "Loading...";
			
			
						myRequest.url = "http://"+ ipAddress;
			
			
						var loader:URLLoader = new URLLoader(myRequest);
						
						
						
						
						//loader.dataFormat = URLLoaderDataFormat.VARIABLES;
						loader.dataFormat = URLLoaderDataFormat.TEXT;
						loader.addEventListener(Event.COMPLETE, loaderCompleteHandler);
						loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
						loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
						loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false,0, true);
						
						loader.load(myRequest);
						
						// Waiting for load comlete or failed
						
						
						
						
						
						//do 
						//{
							//
						//} 
						//while (swr);
						
						
						
						
						
					//	return systemMessage_NM;
						
                    //}			
					
					
					
					
		 function loaderCompleteHandler(e:Event):void
			{
			//var variables:URLVariables = new URLVariables( e.target.data );
			//if(variables.success)
			//{
				//trace(variables.path);	
				//set_sytemMessage("HTTP GET req. Success!");
				//systemMessage_NM = "HTTP READ: "+ e.target.data;
				//systemMessage_NM = "HTTP GET req. Success! "+ e.type;
															
			//}
			
			
			//var loader:URLLoader = URLLoader(e.target);

			var rawhtml:String = loader.data;

			// <tr class="visibility">
			var tag:String = rawGetTagByAttrValue(rawhtml, "le", "tr", "at");
			
			
			
			//var response:String = e.target.data as String;
			
			//var response:String = e.target.data as String;
			//systemMessage_NM = trace("response:"+response);
			systemMessage_NM = "HTTP READ: " + tag;
			
			statusInd_NM = "Done!";
			
			
			swr = true;
			
			
			}
			
		
			
			
			
			
			
		 function httpStatusHandler (e:Event):void
													
			{
			
				//trace("httpStatusHandler:" + e);
				systemMessage_NM = "HTTP status: " + e.type;
				
				statusInd_NM = "Status!";
				
				swr = true;
				
			}	
				
		 function securityErrorHandler (e:Event):void
			{
				//trace("securityErrorHandler:" + e);
				
				systemMessage_NM = "HTTP security err.?! "+ e.type;
				
				swr = true;
				
				
			}
		 function ioErrorHandler(e:Event):void
			{
				//trace("ioErrorHandler: " + e);
				systemMessage_NM = "HTTP IO Error?! "+ e.type;
				//set_sytemMessage("IO jam " + " ioErrorHandler: " + e);
				
				statusInd_NM = "Failed!";
														
				swr = true;										
														
			}
													
			return systemMessage_NM;									
		
		}
		
		
		public static function rawGetTagByAttrValue(html:String, attrValue:String, tag:String = "",  attrName:String = ""):String
			{
				var pattern:RegExp = tag == "" ? 
				new RegExp("<(\\w+)[^>]+?"+attrName+"=\""+attrValue+"\".*?(/>|</\\1>)","is") :
				new RegExp("<"+tag+"[^>]+?"+attrName+"=\""+attrValue+"\".*?(/>|</"+tag+">)","is");

				var result:Array = html.match(pattern);  

				if (result != null && result.length > 0)
					return result[0];

			return "";
			
			
			}
		
		
		
		
		
			}

}