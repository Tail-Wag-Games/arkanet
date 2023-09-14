// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import { Socket, Presence } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import topbar from "../vendor/topbar"

// var users = {};

// function addUserConnection(userUuid) {
//   if (users[userUuid] === undefined) {
//     users[userUuid] = {
//       peerConnection: null
//     }
//   }

//   return users
// }

// function removeUserConnection(userUuid) {
//   delete users[userUuid]

//   return users
// }

// function createPeerConnection(lv, fromUser, offer) {
//   let newPeerConnection = new RTCPeerConnection({
//     iceServers: [
//       { urls: "stun:stun.ekiga.net:3478" }
//     ]
//   })
//   users[fromUser].peerConnection = newPeerConnection;

//   let channel = newPeerConnection.createDataChannel('unreliable',
//     { negotiated: true, id: 0, maxRetransmits: 0, ordered: false });
//   channel.binaryType = 'arraybuffer';

//   channel.addEventListener('open', () => { onDataChannelOpened(this, channel) });
//   channel.addEventListener('error', () => { onDataChannelError(this, channel) });

//   if (offer !== undefined) {
//     newPeerConnection.setRemoteDescription({ type: "offer", sdp: offer })
//     newPeerConnection.createAnswer()
//       .then((answer) => {
//         newPeerConnection.setLocalDescription(answer)
//         console.log("Sending this ANSWER to the requester:", answer)
//         lv.pushEvent("new_answer", { toUser: fromUser, description: answer })
//       })
//       .catch((err) => console.log(err))
//   }

//   newPeerConnection.onicecandidate = async ({ candidate }) => {
//     // fromUser is the new value for toUser because we're sending this data back
//     // to the sender
//     lv.pushEvent("new_ice_candidate", { toUser: fromUser, candidate })
//   };

//   newPeerConnection.onsignalingstatechange = async (ev) => {
//     // fromUser is the new value for toUser because we're sending this data back
//     // to the sender
//     console.log('received signaling state change: ', ev);
//   };

//   newPeerConnection.onicecandidateerror = async (err) => {
//     // fromUser is the new value for toUser because we're sending this data back
//     // to the sender
//     console.log('received ice candidate error: ', err);
//   };

//   // newPeerConnection.addEventListener('signalingstatechange', () => { onSignalingStateChange(this) })
//   newPeerConnection.addEventListener('icegatheringstatechange', () => { onIceGatheringStateChanged(newPeerConnection) })

//   return newPeerConnection;
// }

// function onIceGatheringStateChanged(peerConnection) {
//   console.log('Ice gathering state changed: ', peerConnection);

//   // if (peer.peerConnection.iceGatheringState === 'complete') {
//   //     peer.logger.info('All candidates gathered, waiting for the remote peer to be ready to receive them')

//   //     waitForRemotePeerToBeReadyToReceiveIceCandidates(peer).then(() => {
//   //         if (peer.state !== 'connected') {
//   //             sendCandidates(peer)
//   //         }
//   //     }).catch((err) => {
//   //         raiseError(peer, `waitForRemotePeerToBeReadyToReceiveIceCandidates: ${err}`)
//   //     })
//   // }
// }

// function onDataChannelOpened(peer, dataChannel) {
//   console.log(dataChannel.label, ' data channel opened (id: ', dataChannel.id, ') peer: ', peer);

//   // peer.state = 'connected'

//   // peer.onConnected()
// }

// function onDataChannelError(peer, dataChannel) {
//   console.log(dataChannel.label, ' data channel error (id: ', dataChannel.id, ') peer: ', peer);

//   // peer.state = 'connected'

//   // peer.onConnected()
// }

let Hooks = {};

// Hooks.Init = {
//   mounted() {
//     const relay = this;
//     document.addEventListener("relay-event", (e) => {
//       console.log("game has started! creating peer connection!");

//       let newPeerConnection = new RTCPeerConnection({
//         iceServers: [
//           { urls: "stun:stun.ekiga.net:3478" }
//         ]
//       });
//       users[this.el.dataset.hostId].peerConnection = newPeerConnection;

//       let channel = newPeerConnection.createDataChannel('unreliable',
//         { negotiated: true, id: 0, maxRetransmits: 0, ordered: false });
//       channel.binaryType = 'arraybuffer';

//       channel.addEventListener('open', () => { onDataChannelOpened(this, channel) });
//       channel.addEventListener('error', () => { onDataChannelError(this, channel) });
//       channel.addEventListener('message', (ev) => { console.log('message event: ', ev) });

//       newPeerConnection.onicecandidate = async ({ candidate }) => {
//         // fromUser is the new value for toUser because we're sending this data back
//         // to the sender
//         relay.pushEvent("new_ice_candidate", { toUser: this.el.dataset.hostId, candidate })
//       };

//       newPeerConnection.onsignalingstatechange = async (ev) => {
//         // fromUser is the new value for toUser because we're sending this data back
//         // to the sender
//         console.log('received signaling state change: ', ev);
//       };

//       newPeerConnection.onicecandidateerror = async (err) => {
//         // fromUser is the new value for toUser because we're sending this data back
//         // to the sender
//         console.log('received ice candidate error: ', err);
//       };

//       newPeerConnection.addEventListener('icegatheringstatechange', () => { onIceGatheringStateChanged(newPeerConnection) });

//       newPeerConnection.createOffer({ mandatory: { OfferToReceiveAudio: true, OfferToReceiveVideo: true } }).then((description) => {
//         newPeerConnection.setLocalDescription(description).then(() => {
//           console.log('Offer created and set as local description. Pushing new sdp offer');
//           relay.pushEvent("new_sdp_offer", { toUser: null, description });
//         }).catch((err) => {
//           console.error(this, `setLocalDescription: ${err}`)
//         })
//       }).catch((err) => {
//         console.error(this, `createOffer: ${err}`)
//       })
//       // 
//     });
//   }
// }

// Hooks.InitUser = {
//   mounted() {
//     addUserConnection(this.el.dataset.userUuid)
//   },

//   destroyed() {
//     removeUserConnection(this.el.dataset.userUuid)
//   }
// }

// Hooks.StartGame = {
//   mounted() {

//   }
// };

// Hooks.HandleIceCandidateOffer = {
//   mounted() {
//     let data = this.el.dataset
//     let fromUser = data.fromUserUuid
//     let iceCandidate = JSON.parse(data.iceCandidate)
//     let peerConnection = users[fromUser].peerConnection

//     console.log("new ice candidate from", fromUser, iceCandidate)

//     peerConnection.addIceCandidate(iceCandidate)
//   }
// }

// Hooks.HandleSdpOffer = {
//   mounted() {
//     let data = this.el.dataset
//     let fromUser = data.fromUserUuid
//     let sdp = data.sdp

//     if (sdp != "") {
//       console.log("new sdp OFFER from", data.fromUserUuid, data.sdp)

//       createPeerConnection(this, fromUser, sdp)
//     }
//   }
// }

// Hooks.HandleAnswer = {
//   mounted() {
//     let data = this.el.dataset
//     let fromUser = data.fromUserUuid
//     let sdp = data.sdp
//     let peerConnection = users[fromUser].peerConnection

//     if (sdp != "") {
//       console.log("new sdp ANSWER from", fromUser, sdp)
//       peerConnection.setRemoteDescription({ type: "answer", sdp: sdp })
//     }
//   }
// }


let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, { hooks: Hooks, params: { _csrf_token: csrfToken } })

let serverSocket = new Socket("/socket", {params: {token: window.userToken}})
let severChannel = serverSocket.channel(`arkana:${window.lobbyId}`, {})
let serverPresence = new Presence(severChannel)

let clientSocket = new Socket("/socket", {params: {token: window.userToken}})
let clientChannel = clientSocket.channel(`arkana:${window.lobbyId}`, {})
let clientPresence = new Presence(clientChannel)


serverSocket.onOpen( ev => console.log("OPEN", ev) )
serverSocket.onError( ev => console.log("ERROR", ev) )
serverSocket.onClose( e => console.log("CLOSE", e))

clientSocket.onOpen( ev => console.log("OPEN", ev) )
clientSocket.onError( ev => console.log("ERROR", ev) )
clientSocket.onClose( e => console.log("CLOSE", e))

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" })
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()
liveSocket.enableDebug()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

serverSocket.connect()

clientSocket.connect()

// socket.onError((err) => console.error(err))
// socket.onMessage((msg) => console.info(`msg: ${JSON.stringify(msg)}`))
// socket.onClose((ev) => console.info('closing phoenix socket!!!'))

window.serverSocket = serverSocket
window.serverChannel = severChannel
window.serverPresence = serverPresence

window.clientSocket = clientSocket
window.clientChannel = clientChannel
window.clientPresence = clientPresence

// window.addEventListener(`phx:game-started`, (e) => {
//   let relay_event = new CustomEvent("relay-event", {
//     detail: { event: e },
//   });
//   document.dispatchEvent(relay_event);
// });