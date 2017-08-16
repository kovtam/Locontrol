--WiFi Loco decoder by Tamas Kovacs 2017-07-17

-- wifi init
-- wifi read sttings from wificonf file
cfg_wifi_ssid,cfg_wifi_key = "DEAD","12345678";
if (file.open('wificonf') == true)then
   cfg_wifi_ssid = string.gsub(file.readline(), "\n", "");
   cfg_wifi_key = string.gsub(file.readline(), "\n", "");
   file.close();
end

wifi.setmode(wifi.STATION);
wifi.sta.config(cfg_wifi_ssid,cfg_wifi_key);
wifi.sta.autoconnect(1);
-- tmr connect establish
tmr_count = 0;
tmr.alarm(0, 1000, 1, function()
  if(wifi.sta.getip() == nil)then
    -- wifi connect try
    print("Conn to AP (ssid="..cfg_wifi_ssid.."/key="..cfg_wifi_key..") try:"..tmr_count);
    tmr_count = tmr_count+1;
    if(tmr_count > 60)then 
      -- set ESP to alarm wifi AP mode
      wifi.sta.disconnect(); 
      wifi.setmode(wifi.SOFTAP);
      --wifi.setmode(wifi.STATIONAP);
      wifi.ap.config({ssid="LocoC",pwd="12345678"});
      -- print wifi status
      print("WiFi AP (ssid=LocoC/key=12345678)");
      print('IP:',wifi.ap.getip());
      print('Mode=AP');
      print('MAC:',wifi.ap.getmac());
      dofile("setwifi.lua");
      tmr.stop(0);
    end
  else
    --print wifi status
    print('IP: ',wifi.sta.getip());
    print('Mode=Client');
    print('MAC:',wifi.sta.getmac());
    dofile("loco.lua");
    tmr.stop(0);
  end
end)
