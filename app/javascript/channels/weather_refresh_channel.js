import consumer from "channels/consumer"

document.addEventListener('DOMContentLoaded', () => {
  if (window.location.pathname.match(/locations\/\d+/)) {
    const locationId = window.location.pathname.split("/")[2];

    consumer.subscriptions.create(
      { channel: "WeatherRefreshChannel", location: locationId }, {
      connected() {
        console.log(`WeatherRefreshChannel connected, id: ${locationId}`);
      },

      disconnected() {
        console.log("WeatherRefreshChannel disconnected");
      },

      received(data) {
        document.getElementById('weather-forecast').innerHTML = data;
        console.log("WeatherRefreshChannel received");
      }
    });
  }
});
