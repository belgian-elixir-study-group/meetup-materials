import "deps/phoenix_html/web/static/js/phoenix_html"

import { UserSocket } from "web/static/js/user_socket";
import { UserChannel } from "web/static/js/user_channel";

import { BankAccountChannel } from "web/static/js/bank_account_channel";

export var App = {
  run: function(){
    UserSocket.run(function(socket, user_id){

      UserChannel.setup(socket, user_id);
      BankAccountChannel.setup(socket, user_id);

    });
  }
}
