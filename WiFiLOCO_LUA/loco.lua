-- LocoDecoder by Tamas Kovacs Date:2017-07-20 15_45 Ver:1.2

srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
    conn:on("receive", function(client,request)
        local buf = "";
		local head = "HTTP/1.1 200 OK\n\n<!DOCTYPE HTML>\n<html>\n<head></head>\n<body>\n";
        local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");
        if(method == nil)then
            _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP");
        end
        local _GET = {}
        if (vars ~= nil)then
            for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
                _GET[k] = v
            end
        end
		buf = head;
        buf = buf.."<h1> LOCOntrol";
        buf = buf.."<p>Motion <a href=\"?pin=START\"><button>START</button></a>&nbsp;<a href=\"?pin=STOP\"><button>STOP</button></a></p>";
        buf = buf.."<p>Direction <a href=\"?pin=REW\"><button>REW</button></a>&nbsp;<a href=\"?pin=HLT\"><button>HALT!</button></a></p>";
		buf = buf.."<p>Speed <a href=\"?pin=SLOW\"><button>-</button></a>&nbsp;<a href=\"?pin=FAST\"><button>+</button></a></p>"
        
        if(_GET.pin == "START")then
              start_handler();

        elseif(_GET.pin == "STOP")then
              stop_handler();
			  
        elseif(_GET.pin == "REW")then
		
			if (direction == 0) then 
				dreverse ();
			elseif (direction == 1) then
				dforward ();
			end
		
        elseif(_GET.pin == "HLT")then
              halt ();
		elseif(_GET.pin == "SLOW")then
              slow_maker ();
        elseif(_GET.pin == "FAST")then
			  fast_maker ();
		
        end
		
        local levelp = 0;
        local directionp = "";
        
		if (level > 0) then 
			levelp = level/100
		
		end
		
		if (direction == 0) then
		     directionp = "F"
		elseif (direction == 1) then
			 directionp = "R"
		end
				
		buf = buf.."<tr at=\"le\">D:"..directionp.." L:"..levelp.."</tr>";
		
        buf = buf.."<form src=\"/\"><br><button type=\"submit\" name=\"set\" value=\"RST\">Reset WiFi</button></form>\n";
        buf=buf.."</body></html>";
        client:send(buf);
        client:close();
        collectgarbage();
	
		if(_GET.set == "RST")then 
           file.remove("wificonf");
           node.restart();   
        end 		
  end)  
end)

-- functions ---------------

function start_handler ()

   if (level == 0)then
    
		level=200

        if (direction == 0) then

    
            pwm.stop (ib)
            delay_ms (1000)
            pwm.start (ia)
            direction=0
    
            gpio.write (led2, gpio.LOW);
            gpio.write (led1, gpio.HIGH);
    
    
  
         elseif (direction == 1) then

    
            pwm.stop (ia)
            delay_ms (1000)
            pwm.start (ib)
            direction=1
    
            gpio.write (led1, gpio.LOW);
            gpio.write (led2, gpio.HIGH);

        end
	
		deltaspeed_handler_up ()
	
	end

end

function stop_handler ()

	level=0
	deltaspeed_handler_down ()
	gpio.write (led2, gpio.LOW);
	gpio.write (led1, gpio.LOW);
	
end

function fast_maker ()
	
	if (level<800) then
	level=level+100
	deltaspeed_handler_up ()
	end
	
end

function slow_maker ()
	
	if (level>=100) then
	level=level-100
	deltaspeed_handler_down ()
	end
	
end

function deltaspeed_handler_up ()

   local dutyval = 0
   local speednow = level
   local directionl = ia
   
   if (direction == 1) 
   then directionl=ib; 
   end
   
   dutyval = pwm.getduty(directionl)
   
    
	if (speednow > dutyval) then
      
	  while (speednow > dutyval) do
		
		dutyval = dutyval + 100
		
		pwm.setduty(directionl, dutyval)
		
		delay_ms (500)
	  
		end      
    end  
end

function deltaspeed_handler_down ()

   local dutyval = 0
   local speednow = level
   local directionl = ia
   
   if (direction == 1) then 
   directionl=ib; 
   end
   
   dutyval = pwm.getduty(directionl)
   
   
   if (speednow < dutyval) then
      
	  while (speednow < dutyval) do
		
		dutyval = dutyval - 100

		pwm.setduty(directionl, dutyval)
		
		delay_ms (500)
	  
		end		
	end  
end

function dforward ()

	if (direction == 1)then

    local levelmemo = level

	stop_handler ()	
	
	pwm.stop (ib)
	delay_ms (1000)
	pwm.start (ia)
	direction=0
	
	gpio.write (led2, gpio.LOW);
	gpio.write (led1, gpio.HIGH);
		
	level=levelmemo
	deltaspeed_handler_up ()
  
	end  
end

function dreverse ()
 
	if (direction == 0)then

    local levelmemo = level

	stop_handler ()
 
	pwm.stop (ia)
	delay_ms (1000)
	pwm.start (ib)
	direction=1
	
	gpio.write (led1, gpio.LOW);
	gpio.write (led2, gpio.HIGH);
	
	level=levelmemo
	deltaspeed_handler_up ()
	
	end	
end

function halt ()

	level=0
	pwm.setduty(ia, 0)
    pwm.setduty(ib, 0)
    
end

function delay_ms (milli_secs)
   local ms = milli_secs * 1000
   local timestart = tmr.now ()

   while (tmr.now () - timestart < ms) do
      tmr.wdclr ()
   end
end


