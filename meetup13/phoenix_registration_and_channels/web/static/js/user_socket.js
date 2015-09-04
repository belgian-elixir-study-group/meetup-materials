import {Socket} from "deps/phoenix/web/static/js/phoenix"

let establishSocket = function(token){

  let socket = new Socket("/ws")

  socket.onError( () => console.log("there was an error with the socket!") )
  socket.onClose( () => console.log("the socket was closed") )

  socket.connect({token: token})

  console.log("socket connected")

  return socket;
}

let run = function(callback){
  $.ajax({
    url: "/api/auth_ticket",
    dataType: 'json',

    success: (data, textStatus, jqXHR) => {

      if (data && data.token){
        let socket = establishSocket(data.token)
        callback(socket, data.id)
      }
    }

  })
}

export var UserSocket = {run: run}
