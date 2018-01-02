package PackLocoCTRL.model
{

	/**
	 * ...
	 * @author Tamas Kovacs
	 */



	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import PackLocoCTRL.model.Device;
	
	import mx.collections.ArrayCollection;
	
	public class DeviceDAO
	{
		private var _sqlConnection:SQLConnection;

		public function get sqlConnection():SQLConnection
		{
			if (_sqlConnection)
				return _sqlConnection;
			openDatabase(File.documentsDirectory.resolvePath("DeviceDirectory.db"));
			
			//openDatabase(File.applicationStorageDirectory.resolvePath("DeviceDirectory.db"));
			
			return _sqlConnection;
		}

		public function getItem(id:int):Device
		{
			var sql:String = "SELECT id, firstName, lastName, subsys, ipAddress, speed, direction, state1, sw1, sw2, picture FROM devices WHERE id=?";
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = sql;
			stmt.parameters[0] = id;
			stmt.execute();
			var result:Array = stmt.getResult().data;
			if (result && result.length == 1)
				return processRow(result[0]);
			else
				return null;
		}

		public function findByManager(managerId:int):ArrayCollection
		{
			var sql:String = "SELECT * FROM employee WHERE managerId=? ORDER BY lastName, firstName";
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = sql;
			stmt.parameters[0] = managerId;
			stmt.execute();
			var result:Array = stmt.getResult().data;
			if (result)
			{
				var list:ArrayCollection = new ArrayCollection();
				for (var i:int=0; i<result.length; i++)
				{
					list.addItem(processRow(result[i]));	
				}
				return list;
			}
			else
			{
				return null;
			}
		}

		public function findByName(searchKey:String):ArrayCollection
		{
			 var sql:String = "SELECT * FROM devices WHERE firstName || ' ' || lastName LIKE '%"+searchKey+"%' ORDER BY lastName, firstName";
			 var stmt:SQLStatement = new SQLStatement();
			 stmt.sqlConnection = sqlConnection;
			 stmt.text = sql;
//			 stmt.parameters[0] = searchKey;
			 stmt.execute();
			 var result:Array = stmt.getResult().data;
			 if (result)
			 {
				 var list:ArrayCollection = new ArrayCollection();
				 for (var i:int=0; i<result.length; i++)
				 {
					 list.addItem(processRow(result[i]));	
				 }
				 return list;
			 }
			 else
			 {
				 return null;
			 }
		}

		public function create(device:Device):void
		{
			trace(device.firstName);
			
			var sql:String = 
				"INSERT INTO devices (id, firstName, lastName, subsys, ipAddress, speed, direction, state1, sw1, sw2, picture) " +
				"VALUES (?,?,?,?,?,?,?,?,?,?,?)";
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = sql;
			stmt.parameters[0] = device.id;
			stmt.parameters[1] = device.firstName;
			stmt.parameters[2] = device.lastName;
			stmt.parameters[3] = device.subsys;
			stmt.parameters[4] = device.ipAddress;
			stmt.parameters[5] = device.speed;
			stmt.parameters[6] = device.direction;
			stmt.parameters[7] = device.state1;
			stmt.parameters[8] = device.sw1;
			stmt.parameters[9] = device.sw2;
			stmt.parameters[10] = device.picture;
			stmt.execute();
			device.loaded = true;
		}
		
		
		public function createDevice(device:Device):int
		{
			var sql:String = 
				"INSERT INTO devices (firstName, lastName, subsys, ipAddress, speed, direction, state1, sw1, sw2, picture) " +
				"VALUES (?,?,?,?,?,?,?,?,?,?)";
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = sql;
			
			stmt.parameters[0] = device.firstName;
			stmt.parameters[1] = device.lastName;
			stmt.parameters[2] = device.subsys;
			stmt.parameters[3] = device.ipAddress;
			stmt.parameters[4] = device.speed;
			stmt.parameters[5] = device.direction;
			stmt.parameters[6] = device.state1;
			stmt.parameters[7] = device.sw1;
			stmt.parameters[8] = device.sw2;
			stmt.parameters[9] = device.picture;
			stmt.execute();
			device.loaded = true;
			return 1
		}
		
		
		public function updateDevice(device:Device,id:int):int
		{
			trace(device.firstName);
			
			var sql:String = 
				"UPDATE devices SET firstName='"+ device.firstName + "'," +
				"lastName='" + device.lastName + "'," +
				"subsys='" + device.subsys + "'," +
				"ipAddress='" + device.ipAddress + "'," +
				"state1='" + device.state1 + "'," +
				"picture='" + device.picture + "'" +
				"WHERE id="+id;
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = sql;
			
			stmt.execute();
			device.loaded = true;
			return 1
		}
		
		
		public function deleteDevice(device:Device,id:int):int
		{
			
			
			var sql:String = "DELETE FROM devices WHERE id="+id;
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = sql;
			stmt.execute();	
			device.loaded = false;
			return 1
		}
		
		
		
		
		protected function processRow(o:Object):Device
		{
			var device:Device = new Device();
			
			device.id = o.id;
			device.firstName = o.firstName == null ? "" : o.firstName;
			device.lastName = o.lastName == null ? "" : o.lastName;
			device.subsys = o.subsys == null ? "" : o.subsys;
			device.ipAddress = o.ipAddress == null ? "" : o.ipAddress;
			device.speed = o.speed == null ? "" : o.speed;
			device.direction = o.direction == null ? "" : o.direction;
			device.state1 = o.state1 == null ? "" : o.state1;
			device.sw1 = o.sw1 == null ? "" : o.sw1;
			device.sw2 = o.sw2 == null ? "" : o.sw2;
			device.picture = o.picture;
			
			
			
			device.loaded = true;
			return device;
		}

		public function openDatabase(file:File):void
		{
			var newDB:Boolean = true;
			if (file.exists)
				newDB = false;
			_sqlConnection = new SQLConnection();
			_sqlConnection.open(file);
			if (newDB)
			{
				createDatabase();
				populateDatabase();
			}
		}
		
		public function createDatabase():void
		{
			var sql:String = 
				"CREATE TABLE IF NOT EXISTS devices ( "+
				"id INTEGER PRIMARY KEY AUTOINCREMENT, " +
				"firstName VARCHAR(50), " +
				"lastName VARCHAR(50), " +
				"subsys VARCHAR(50), " +
				"ipAddress VARCHAR(50), " + 
				"speed VARCHAR(20), " +
				"direction VARCHAR(50), " +
				"state1 VARCHAR(30), " + 
				"sw1 VARCHAR(30), " +
				"sw2 VARCHAR(30), " +
				"picture VARCHAR(200))";
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = sql;
			stmt.execute();			
		}
		
		
		public function clearDatabase():void
		{
			var sql:String = 
				"DELETE FROM devices"
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = sql;
			stmt.execute();			
		}
		
		
		
		
		
		public function populateDatabase():void
		{
			var file:File = File.documentsDirectory.resolvePath("devices.xml");
			
			//var file:File = File.applicationDirectory.resolvePath("assets/devices.xml");
			
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.READ);
			var xml:XML = XML(stream.readUTFBytes(stream.bytesAvailable));
			stream.close();
			for each (var emp:XML in xml.device)
			{
				var device:Device = new Device();
				device.id = emp.id;
				device.firstName = emp.firstName;
				device.lastName = emp.lastName;
				device.subsys = emp.subsys;
				device.ipAddress = emp.ipAddress;
				device.speed = emp.speed;
				device.direction = emp.direction;
				device.state1 = emp.state1;
				device.sw1 = emp.sw1;
				device.sw2 = emp.sw2;
				device.picture = emp.picture;
				
				create(device);
			}
		}
		
	}
}