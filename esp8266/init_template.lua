<<<<<<< HEAD:esp8266/init_template.lua
nome = %%NAME%%
uid = %%UID%%
portconfig = %%PORTCONFIG%%
=======
nome = "Prova1" -- Your choice try to keep them as short as possible
uid = "0000001" -- Must be unique on the network
>>>>>>> github/master:esp8266/init.lua

tmr.alarm(0, 1000, 1, function()
   if wifi.sta.getip() == nil then
      print("Connecting to AP...")
   else
      print('IP: ',wifi.sta.getip())
      tmr.stop(0)
   end
end)

--gpio.mode(3, gpio.OUTPUT)
--gpio.mode(4, gpio.OUTPUT)
--gpio.write(3, gpio.LOW)
--gpio.write(4, gpio.LOW)

--state = 0

%%STATES_DEF%%

function udprecv(c,pl)

	n = tonumber(pl)
	if pl == "A" then

		c:send(uid..","..nome..","..%%STATE_STRING_CONCAT%%)
		return
	end
	if n == nil then
		return
	end
	if n == 9 then
		c:send(uid)
		return
	end
	if n == 8 then
		c:send(tostring(state))
		return
	end
	if n == 7 then
		c:send(nome)
		return
	end
	if bit.band(n,1) ~= 0 then
		gpio.write(3, gpio.HIGH)		
		print("Enable 1")
			
	else
		gpio.write(3, gpio.LOW)
		print("Disable 1")
		
	end
	state = bit.band(n,3)
	c:send(tostring(state))
	
	
	if bit.band(n,2) ~= 0 then
		gpio.write(4, gpio.HIGH)
		print("Enable 2")	
	else
		gpio.write(4, gpio.LOW)
		print("Disable 2")

	end
end

srv=net.createServer(net.UDP)
srv:on("receive",udprecv)
srv:listen(8000)


