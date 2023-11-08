<template>
  <tr class="history-game-item">
    <td>{{ opponentName(game) }}</td>
    <td>{{ gameStatus(game) }}</td>
  </tr>
</template>

<script>
export default {
  name: "HistoryGameItem",
  props: {
    game: null,
    myUuid: null
  },
  methods: {
    gameStatus(game) {
      if (game.status == 'victory' && this.myUuid != game.turn_uuid) {
        return "lost"
      }
      return game.status
    },
    opponentName(game) {
      if (game.opponent_name) {
        return game.opponent_name
      } else {
        return 'No opponent'
      }
    }
  }
}
</script>

<style scoped>

</style>
