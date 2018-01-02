package PackLocoCTRL.model 
{
	/**
	 * ...
	 * @author Tamas Kovacs
	 */
	

    
           
			
            import flash.events.MouseEvent;
			import spark.components.IItemRenderer;
            import spark.components.List;
			import flash.events.*;
			
			
			
			
           
            public class SelectionList extends List {
                   
                    /**
                     * The property name for data that are section title items
                     */
                    private var _sectionField:String;
					
					private var _systemMessage:String;
					
					private var _systemMessage2:String;
					
					private var _ipAddress:String;
					
					private var _direction:String;
					
					private var _speed:int;
					
					
					private var _nema:NetworkManager= new NetworkManager();
					
					private var _ListTouchInd:int = 0;
					
					
                   
                    public function set sectionField(value:String):void {
                            _sectionField = value;
                    }
					
					
					
					// Added functionality by KovTam START
					
					
					public function set_sytemMessage(value:String):void {
                            
						_systemMessage = value;
                    }
					
					
					public function set_sytemMessage2(value:String):void {
                            
						_systemMessage2 = value;
                    }
					
									
					
					public function set_ipAddress(value:String):void {
                            
						_ipAddress = value;
						//_nema = new NetworkManager(value);
					
                    }
					
					
					
					public function get_sytemMessage():String {
                            
						return _systemMessage;
                    }
					
					
					public function get_sytemMessage2():String {
                            
						return _systemMessage2;
                    }
					
					
					public function init_sytemMessage2(value:String):void {
                            
						_systemMessage2 = value;
						
						_direction = "F";
						
						_speed = 0;
						
                    }
					
					
					public function get_NMSysInd():String {
						
						
						return _nema.get_statusInd_NM();
						
                    }
					
					public function get_NMSysMesAct():String {
						
						
						return _nema.get_systemMessage_NM();
						
                    }
					
					
					public function set_ListTouchInd (svalue:int):void 
					{
						_ListTouchInd = svalue;
					}
					
					public function get_ListTouchInd ():int 
					{
						return _ListTouchInd;
					}
					
					
					
					// Speed management part services ----------------
					
					public function speed_up_req ():void {
						
									var myintToString:String = _speed + "";
						
									_nema.set_myData("FAST");	
								
									_systemMessage = _nema.action_load_loader(_ipAddress);	
												
									//_speed = 0;
									
									//_direction = "F";
									
									
									if (_speed < 100) {
									
									_speed = _speed + 10
									
									}
									
									myintToString = _speed + "";
									
								
									
									_systemMessage2 = "Dir: " + _direction + "  Speed: " + myintToString;
						
						
                    }
					
					
					public function speed_down_req ():void {
						
									var myintToString:String = _speed + "";
						
									_nema.set_myData("SLOW");	
								
									_systemMessage = _nema.action_load_loader(_ipAddress);	
												
									
									//_speed = 0;
									
									//_direction = "F";
									
									
									if (_speed > 10) {
									
									_speed = _speed - 10
									
									}
									
									myintToString = _speed + "";
									
								
									
									_systemMessage2 = "Dir: " + _direction + "  Speed: " + myintToString;
						
						
                    }
					
					
					
					
					
					
					// Added functionality by KovTam STOP
					
					
                    /**
                     * Disable selection for section title items
                     */
                    override protected function item_mouseDownHandler(event:MouseEvent):void {
                            
							var action:Object;
							
							action = IItemRenderer(event.currentTarget).data;
							
							
							var myintToString:String = _speed + "";					
							
							
							
							
							switch (action.type)
							{
								case "start":
									
									
									 
									
									_nema.set_myData("START");	
								
									_systemMessage = _nema.action_load_loader(_ipAddress);	
									
									_speed = 10;
									
									//_direction = "F";
									
									myintToString = _speed + "";
									
								
									
									_systemMessage2 = "Dir: " + _direction + "  Speed: " + myintToString;
									
									
									
									set_ListTouchInd (1);
									
									
						
									break;
								
								case "stop":
									
									
									
									_nema.set_myData("STOP");	
								
									_systemMessage = _nema.action_load_loader(_ipAddress);	
									
									
									_speed = 0;
									
									//_direction = "F";
									
									myintToString = _speed + "";
									
								
									
									_systemMessage2 = "Dir: " + _direction + "  Speed: " + myintToString;
									
									
									set_ListTouchInd (2);
									
									break;
								
								case "reverse":
									
									
									
									
									_nema.set_myData("REW");	
								
									_systemMessage = _nema.action_load_loader(_ipAddress);	
												
									
									//_speed = 0;
									
									
									if (_direction == "R") 
									{
										_direction = "F";
									}
									
									else 
									{
										_direction = "R";
									}
									
									
									myintToString = _speed + "";
									
								
									
									_systemMessage2 = "Dir: " + _direction + "  Speed: " + myintToString;
									
									
									set_ListTouchInd (3);
									
									
									break;
									
								case "halt":
									
									
									
									_nema.set_myData("HLT");	
								
									_systemMessage = _nema.action_load_loader(_ipAddress);	
												
									//_speed = 0;
									
									_direction = "F";
									
									myintToString = _speed + "";
									
								
									
									_systemMessage2 = "Dir: " + _direction + "  Speed: " + myintToString;
														
									
									set_ListTouchInd (4);
									
									
									break;	
									
									
									
									
								case "up":
									
									
									
									_nema.set_myData("FAST");	
								
									_systemMessage = _nema.action_load_loader(_ipAddress);	
												
									//_speed = 0;
									
									//_direction = "F";
									
									
									if (_speed < 100) {
									
									_speed = _speed + 10
									
									}
									
									myintToString = _speed + "";
									
								
									
									_systemMessage2 = "Dir: " + _direction + "  Speed: " + myintToString;
									
									
									set_ListTouchInd (5);
									
									break;	
									
								case "down":
									
									
									
									
									_nema.set_myData("SLOW");	
								
									_systemMessage = _nema.action_load_loader(_ipAddress);	
												
									
									//_speed = 0;
									
									//_direction = "F";
									
									
									if (_speed > 10) {
									
									_speed = _speed - 10
									
									}
									
									myintToString = _speed + "";
									
								
									
									_systemMessage2 = "Dir: " + _direction + "  Speed: " + myintToString;
									
									
									set_ListTouchInd (6);
									
									
									break;		
									
									
									
								case "query":
									
									
									
									
									_nema.set_myData("QUE");	
									
									//_systemMessage2 = "Trying to query..";
								
									_systemMessage = _nema.action_load_loader(_ipAddress);	
									
									
									_systemMessage2 = _nema.get_statusInd_NM();
									
									//_systemMessage2 = _systemMessage
									
									
									
									//_systemMessage2 = "Dir: " + _direction + "  Speed: " + myintToString;
								
									
									//_systemMessage2 = "Trying to query...";
									
									
									set_ListTouchInd (7);
									
									
									break;		
								
							}					
							
							
                    }
                   
            }
    



}