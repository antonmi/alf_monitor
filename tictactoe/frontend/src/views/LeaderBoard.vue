<template>
  <table class="leaderboard">
    <tr>
      <th>Name</th>
      <th>Scores</th>
    </tr>
    <LeaderBoardItem v-for="user in users" :key="user.uuid" :user="user" />
  </table>
</template>

<script>
import ApiService from "../services/ApiService";
import LeaderBoardItem from "../components/LeaderBoardItem"

export default {
  name: "LeaderBoard",
  components: {
    LeaderBoardItem
  },
  data() {
    return {
      users: []
    }
  },
  created() {
    this.fetchLeaderBoard()
  },
  methods: {
    fetchLeaderBoard() {
      ApiService.showLeaderBoard()
      .then(response => {
        this.users = response.data
      })
      .catch(error => {
        console.log(error)
      })
    },
  }
};
</script>

<style scoped>
  table.leaderboard {
    margin: auto;
  }
</style>
