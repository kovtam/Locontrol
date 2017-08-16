--WiFi Loco decoder by Tamas Kovacs 2017-07-17

print('Load SMART Loco');
--tmr.delay(1000000);
ia=5;			-- GPIO14	luaID=5
ib=6;			-- GPIO12	luaID=6
led1=0;			-- GPIO18	luaID=0
led2=7;			-- GPIO13	luaID=7
restart=0;
level=0;
direction=0;
adcval=0;

--devsetup();
--set_pwm_on_pins (ia, ib);

gpio.mode (ia, gpio.OUTPUT); -- ia     - GPIO14
gpio.mode (ib, gpio.OUTPUT); -- ib     - GPIO12
gpio.mode(led1, gpio.OUTPUT);
gpio.mode(led2, gpio.OUTPUT);
gpio.write (led1, gpio.LOW);
gpio.write (led2, gpio.LOW);
gpio.write (ia, gpio.LOW);
gpio.write (ib, gpio.LOW);

-- Set the pins sent in as pwm
pwm.setup (ia, 100, 100)
pwm.setup (ib, 100, 100)
dofile("wifi.lua");
--dofile("loco.lua");
