--ESP8266 WiFi+WEB server basic connection demo by Tamas Kovacs 2017-07-17

print("ESP8266 RT Demo")
local str=wifi.ap.getmac();
local ssidTemp=string.format("%s%s%s",string.sub(str,10,11),string.sub(str,13,14),string.sub(str,16,17));
wifi.setmode(wifi.STATIONAP)
     
local cfg={}
cfg.ssid="ESP8266_"..ssidTemp;  -- ESP modul SSID, ESP8266_ + MAC cim utolso 6 karaktere, igy egyedi lesz
cfg.pwd="12345678"              -- ESP modul jelszo, minimum 8 karakter!
wifi.ap.config(cfg)
cfg={}
cfg.ip="192.168.2.1";           -- ESP modul IP cime.
cfg.netmask="255.255.255.0";
cfg.gateway="192.168.2.1";
wifi.ap.setip(cfg);
  
wifi.sta.config("TP-LINK-LOCO","ABCD1234") -- Wifi router SSID, jelszo minimum 8 karakter!
wifi.sta.connect()
   
local cnt = 0
tmr.alarm(0, 1000, 1, function() 
if (wifi.sta.getip() == nil) and (cnt < 20) then 
    print("Trying Connect to Router, Waiting...")
    cnt = cnt + 1 
else 
    tmr.stop(0);
    print("Soft AP started")
    print("MAC:"..wifi.ap.getmac().."\r\nIP:"..wifi.ap.getip());
    if (cnt < 20) then print("Conected to Router\r\nMAC:"..wifi.sta.getmac().."\r\nIP:"..wifi.sta.getip())
        else print("Conected to Router Timeout")
    end
    cnt = nil;cfg=nil;str=nil;ssidTemp=nil;
    collectgarbage()
    end 
end)

-- Web HTTP server part

srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
    conn:on("receive", function(client,request)
        local buf = "";
        buf = buf.."HTTP/1.0 200 OK\r\nContent-Type: text/html\r\n\r\n<h3> Hello, NodeMCU!</h3>";
        client:send(buf);
        client:close();
        collectgarbage();
    end)
end)
