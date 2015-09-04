import {Socket} from "deps/phoenix/web/static/js/phoenix"


let server2client  = function(channel, bankAccount){
  channel.on("msg", (payload) => {
    bankAccount.html(payload.body)
  })
}


let setup = function(socket, user_id){

  let bankAccount = $("#bank-account");

  console.log("!!!");
  if (bankAccount.length > 0){
    console.log("2323");
    let channel = socket.channel("bank_account:" + user_id, {})

    channel.join()
      .receive("ok", resp => { console.log("Joined succesffuly to channel Bank Account", resp) })
      .receive("error", resp => { console.log("Unabled to join Bank Account", resp) })

    server2client(channel, bankAccount);

  }
}

export var BankAccountChannel = {setup: setup}
