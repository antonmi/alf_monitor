<template>
  <table class="history">
    <tr>
      <th>Opponent</th>
      <th>Status</th>
    </tr>
    <HistoryGameItem v-for="game in games" :key="game.uuid" :game="game" :myUuid="myUuid" />
  </table>
</template>

<script>
import ApiService from "../services/ApiService";
import HistoryGameItem from "../components/HistoryGameItem"

export default {
  name: "History",
  components: {
    HistoryGameItem
  },
  data() {
    return {
      username: '',
      games: []
    }
  },
  created() {
    this.myUuid = localStorage.myUuid
    this.username = localStorage.username
    if (this.myUuid && this.username) {
      this.fetchGamesList()
    }
  },
  methods: {
    fetchGamesList() {
      ApiService.userChecksTheirGames(this.myUuid)
      .then(response => {
        this.games = response.data
      })
      .catch(error => {
        console.log(error)
      })
    },
  }
};
</script>

<style scoped>
  table.history {
    margin: auto;
  }
</style>
