<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
  <head>
    <link
      rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bulma@0.9.1/css/bulma.min.css"
    />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <script
      src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.0/sockjs.min.js"
      integrity="sha512-5yJ548VSnLflcRxWNqVWYeQZnby8D8fJTmYRLyvs445j1XmzR8cnWi85lcHx3CUEeAX+GrK3TqTfzOO6LKDpdw=="
      crossorigin="anonymous"
    ></script>
    <script
      src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"
      integrity="sha512-iKDtgDyTHjAitUDdLljGhenhPwrbBfqTKWO1mkhSFH3A7blITC9MhYon6SjnMhp4o0rADGw9yAC6EW4t5a4K3g=="
      crossorigin="anonymous"
    ></script>
  </head>
  <body>
    <div id="display"></div>
    <input
      type="text"
      class="input"
      id="msg"
      placeholder="메시지를 입력하세요"
      value=""
    />
  </body>
  <script>
	  			let user ='';
				window.addEventListener('DOMContentLoaded', evt => {
					user = window.prompt('대화명을 입력하세요','Stranger');
					connect();
					document.querySelector("#msg").addEventListener("keydown",onKeyDown);
				});
    			let socket = null;
    			function connect(){
    				const sock = new SockJS("/stomp");
    				const client = Stomp.over(sock);
    				socket=client;
					client.connect({}, ()=>{
						console.log("Connected stomp!");
						client.subscribe('/topic/greeting',(evt)=>{
							if(evt){
								const msg = evt.body.split('@');
								document.querySelector("#display").innerHTML = document.querySelector("#display").innerHTML + `
																	<div class="box" id="`+evt.headers['message-id']+`"">
																		<article class="media">
																			<div class="media-content">
																				<div class="content">
																					<p>
																					<strong>`+msg[0]+`</strong>
																					<br>`+
																					msg[1]	
																					+`</p>
																				</div>
																				<nav class="level is-mobile">
																					<div class="level-left">
																						<a class="level-item" aria-label="reply">
																							<span class="icon is-small">
																								<i class="fas fa-reply" aria-hidden="true"></i>
																							</span>
																						</a>
																						<a class="level-item" aria-label="retweet">
																							<span class="icon is-small">
																								<i class="fas fa-retweet" aria-hidden="true"></i>
																							</span>
																						</a>
																						<a class="level-item" aria-label="like">
																							<span class="icon is-small">
																								<i class="fas fa-heart" aria-hidden="true"></i>
																							</span>
																						</a>
																					</div>
																				</nav>
																			</div>
																		</article>
																	</div>`;
								location.href=location.pathname+"#"+evt.headers['message-id'];
								document.getElementById("msg").focus();
							}
						});
					});
    			}

    			function send(e){
    			socket.send('/greeting/'+user,{},document.querySelector("#msg").value);
    			document.querySelector("#msg").value='';
    			}

    			function onKeyDown(e){
    			if (e.key == "Enter") {
    			send();
    			}
    			}
  </script>
</html>
