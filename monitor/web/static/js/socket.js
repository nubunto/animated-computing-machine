import {Socket} from "phoenix"
import Vue from "vue"

let eventLogVM = new Vue({
  el: "#demo",
  data: {
    events: []
  },
  methods: {
    newEvent: (event) => {
      eventLogVM.$data.events.push(event)
    }
  }
})

let socket = new Socket("/socket", {params: {token: window.userToken}})
socket.connect()

let channel = socket.channel("events:lobby", {})

channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

channel.on("new event", payload => {
  eventLogVM.newEvent(payload)
})

export default socket
