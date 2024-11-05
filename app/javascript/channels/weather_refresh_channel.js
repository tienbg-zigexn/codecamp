import consumer from "channels/consumer"

const location = document.getElementById("location-name").textContent;

consumer.subscriptions.create(
  { channel: "WeatherRefreshChannel", location: location }, {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log(`WeatherRefreshChannel connected, with ${location}`);
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
    console.log("WeatherRefreshChannel disconnected");
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    console.log(data);
    console.log("WeatherRefreshChannel received");
  }
});
