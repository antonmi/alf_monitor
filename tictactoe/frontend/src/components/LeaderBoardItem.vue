<template>
  <tr class="history-game-item">
    <td>{{ user.name }}</td>
    <td>{{ user.scores }}</td>
  </tr>
</template>

<script>
export default {
  name: "LeaderBoardItem",
  props: {
    user: null,
    myUuid: null
  }
}
</script>

<style scoped>

</style>
