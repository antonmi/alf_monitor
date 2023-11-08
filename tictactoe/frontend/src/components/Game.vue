<template>
  <div class="current-game">
    <div v-if="gameStatus != 'pending'">
      <h4>{{ myName }} ({{ mySymbol }}) vs {{ opponentName }} ({{ opponentSymbol }})</h4>
    </div>
    <div v-else>
      <h4>Please wait for opponent</h4>
    </div>

    <h4>Game Status: {{ gameStatus }} </h4>
    <h3 v-if="myTurn">You turn</h3>
    <h3 v-else>{{ opponentName }}'s turn</h3>

    <Board :field="field" @perform-move="performMove"/>
    <div v-if="gameStatus == 'pending'">
      <h4>Please wait for opponent</h4>
    </div>
    <div v-else-if="gameStatus == 'active'">
      <button @click="cancelGame">Cancel Game</button>
    </div>
    <div v-else>
      <button @click="nextGame">Next Game</button>
    </div>
  </div>
</template>

<script>
// @ is an alias to /src
import Board from "@/components/Board.vue";
import ApiService from "../services/ApiService";

const pollInterval = 3000

export default {
  name: "Game",
  components: {
    Board,
  },
  props: {
    gameUuid: String,
    myUuid: String
  },
  data() {
    return {
      game: null,
      myName: '',
      mySymbol: null,
      myTurn: null,
      opponentName: '',
      opponentSymbol: null,
      polling: null
    }
  },
  computed: {
    field() {
      if (this.game) {
        return this.game["field"].map(function (el) {
          if (el == 1) {
            return 'x'
          } else if (el == 0) {
            return 'o'
          } else {
            return ''
          }
        })
      } else {
        return ['', '', '', '', '', '', '', '', '']
      }
    },
    gameStatus() {
      var status = this.game ? this.game.status : 'loading'
      if (status == 'victory' && this.myUuid != this.game.turn_uuid) {
        status = "lost"
      }
      return status
    }
  },
  methods: {
    performMove(position) {
      if (this.canMove()) {
        ApiService.userMoves(this.game.uuid, position, this.myUuid)
        .then(response => {
          this.game = response.data["game"]
        })
        .catch(error => {
          console.log(error)
        })
      } else {
        console.log("Can't move")
      }
    },
    canMove() {
      return (this.game.status == 'active' && this.myTurn)
    },
    setGameData() {
      ApiService.gameInfo(this.gameUuid)
      .then(response => {
        this.game = response.data["game"]
        let user_x = response.data["user_x"]
        let user_o = response.data["user_o"]
        if (user_x.uuid == this.myUuid) {
          this.myName = user_x.name
          this.mySymbol = 'x'
          this.opponentName = user_o.name
          this.opponentSymbol = 'o'
        } else if (user_o.uuid == this.myUuid) {
          this.myName = user_o.name
          this.mySymbol = 'o'
          this.opponentName = user_x.name
          this.opponentSymbol = 'x'
        }
        this.myTurn = this.game["turn_uuid"] == this.myUuid ? true : false
      })
      .catch(error => {
        console.log(error)
      })
    },
    cancelGame() {
      ApiService.userCancelsGame(this.gameUuid, this.myUuid)
      .then(() => {
        this.$emit('game-cancelled')
      }).catch(error => {
        console.log(error)
      })
    },
    nextGame() {
      this.$emit('next-game')
    }
  },
  created() {
    this.setGameData()
    this.polling = setInterval(() => {
      this.setGameData()
    }, pollInterval)
  },
  beforeUnmount () {
    clearInterval(this.polling)
  },
};
</script>

<style scoped>
.small-uuid {
  font-size: 10px;
}
</style>
