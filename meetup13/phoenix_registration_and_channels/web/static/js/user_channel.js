import {Socket} from "deps/phoenix/web/static/js/phoenix"

let server2client  = function(channel, incomingMessages){

  channel.on("msg", (payload) => {
    incomingMessages.append("<br/>" + payload.body)
  })
}

let client2server = function(channel){
  let commInput = $("#comm-input");

  if (commInput.length > 0){
    commInput.on("keypress", (event) => {

      if(event.keyCode === 13){
        channel.push("msg", {body: commInput.val()});
        commInput.val("");
      }
    })
  }
}


let setup = function(socket, user_id){

  let incomingMessages = $("#incoming-messages");

  if (incomingMessages.length > 0){

    let channel = socket.channel("user:" + user_id, {})

    channel.join()
      .receive("ok", resp => { console.log("Joined succesffuly to channel User", resp) })
      .receive("error", resp => { console.log("Unabled to join send_to_client", resp) })

    client2server(channel);

    server2client(channel, incomingMessages);

  }

}

export var UserChannel = {setup: setup}
