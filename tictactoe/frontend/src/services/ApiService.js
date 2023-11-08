import axios from "axios";

const apiUrl = () => {
  let url = process.env.VUE_APP_API_URL ? process.env.VUE_APP_API_URL : 'http://localhost:4001'
  console.log("API_URL=" + url)
  return url
}

const apiClient = axios.create({
  baseURL: apiUrl(),
  withCredentials: false,
  headers: {
    Accept: 'application/json',
    'Content-Type': 'application/json'
  }
})


export default {
  userEnters(name, myUuid) {
    return apiClient.post('/user_enters/' + name, {token: myUuid})
  },
  gameInfo(uuid) {
    return apiClient.get('/game_info/' + uuid)
  },
  showLeaderBoard() {
    return apiClient.get('/show_leader_board')
  },
  userMoves(gameUuid, move, myUuid) {
    return apiClient.post('/user_moves/' + gameUuid + '/' + move, {token: myUuid})
  },
  userCancelsGame(gameUuid, myUuid) {
    return apiClient.post('/user_cancels_game/' + gameUuid, {token: myUuid})
  },
  userChecksTheirGames(myUuid) {
    return apiClient.post('/user_checks_their_games', {token: myUuid})
  },
}
