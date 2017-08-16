--WiFi Loco decoder by Tamas Kovacs 2017-07-17

srv=net.createServer(net.TCP) 
srv:listen(80,function(conn) 
    conn:on("receive", function(client,request)        
        local buf = "";
        local head = "HTTP/1.1 200 OK\n\n<!DOCTYPE HTML>\n<html>\n<head><meta content=\"text/html; charset=utf-8\"></head>\n<body>\n";
        local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");
        if(method == nil)then 
            _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP");
        end
        local _GET = {}      
        if (vars ~= nil)then 
            for k, v in string.gmatch(vars, "(%w+)=(_*-*%w+_*-*%w*)&*") do 
                _GET[k] = v 
            end 
        end
        if (restart == 1)then node.restart() end
        buf=head; 
        buf=buf.."<h2>WiFi Settings</h2>\n"
        buf=buf.."<h3>MAC: "..wifi.sta.getmac().."</h3>\n"
        buf=buf.."<form src=\"/\">"
        buf=buf.."<p>SSID:</p><input type=\"text\" name=\"ssid\" size=\"20\" value=\"\" maxlength=\"32\">"
        buf=buf.."<p>KEY:</p><input type=\"text\" name=\"key\" size=\"20\" value=\"\" maxlength=\"32\"><br>"
        buf=buf.."<br><button type=\"submit\" name=\"wifi\" value=\"SAVE\">Save</button>"
        buf=buf.."</form>\n" 
        if(_GET.wifi == "SAVE")then
           --save ssid or key to configfile in flash wrmem(_GET.ssid), wrmem(_GET.key)
           file.remove("wificonf")
           file.open("wificonf","w")
           if ((_GET.ssid~=nil)and(_GET.ssid~=""))then file.writeline(_GET.ssid) else file.writeline("DEAD") end 
           if ((_GET.key~=nil)and(_GET.key~=""))then file.writeline(_GET.key) else file.writeline("0") end
           file.close()
           buf=head
           buf=buf.."<h2>Save OK!</h2>\n<form><input type=\"button\" value=\"OK and Reboot\" onclick=\"javascript:window.location=\'/\'\"/></form>\n"
           restart=1
        end     
        buf=buf.."</body></html>"
        client:send(buf)
        client:close()
        collectgarbage()
    end)
end)


