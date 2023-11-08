<template>
  <div class="home">
    <div v-if="showGame">
      <Game
          :gameUuid="gameUuid"
          :myUuid="myUuid"
          @game-cancelled="gameCancelled"
          @next-game="nextGame"
      />
    </div>
    <div v-else>
      <form @submit.prevent="enterGame" class="enter-form">
        <h3>Enter your name</h3>
        <label for="username">Name:</label>
        <input id="username" v-model="username">

        <input class="button" type="submit" value="Submit">
      </form>
    </div>
  </div>
</template>

<script>
// @ is an alias to /src
import ApiService from "../services/ApiService";
import Game from "../components/Game";

export default {
  name: "Home",
  components: {
    Game
  },
  data() {
    return {
      username: '',
      myUuid: null,
      gameUuid: null
    }
  },
  computed: {
    showGame() {
      return (this.gameUuid ? true : false)
    }
  },
  created() {
    this.myUuid = localStorage.myUuid
    this.username = localStorage.username
    if (this.myUuid && this.username) {
      this.enterGame()
    }
  },
  methods: {
    enterGame() {
      ApiService.userEnters(this.username, this.myUuid)
      .then(response => {
        if (response.data.error == 'no_such_user') {
          localStorage.clear()
        } else {
          this.myUuid = localStorage.myUuid = response.data["token"]
          this.username = localStorage.username = response.data["username"]
          this.gameUuid = response.data["game"]["uuid"]
        }
      })
      .catch(error => {
        console.log(error)
      })
    },
    gameCancelled() {
      this.enterGame()
    },
    nextGame() {
      this.enterGame()
    }
  }
};
</script>
