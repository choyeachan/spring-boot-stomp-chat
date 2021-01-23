package com.example.demo.web;

import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.web.bind.annotation.RestController;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
public class MessageController {

	@MessageMapping("/greeting/{user}")
	@SendTo("/topic/greeting")
	public String hello(String greeting, @DestinationVariable String user){
		log.info("- greeting {} : {}",user,greeting);
		return user+"@"+greeting;
	}
}

