<template>
  <div class="tictactoe-board">
    <div v-for="(n, i) in 3" :key="{ i }">
      <div v-for="(n, j) in 3" :key="{ j }" >
        <Cell :value="field[3*j + i]" @click="performMove(3*j + i)"></Cell>
      </div>
    </div>
  </div>
</template>

<script>
import Cell from "./Cell";

export default {
  name: "Board",
  props: {
    field: Array
  },
  components: {
    Cell
  },
  methods: {
    performMove(position) {
      this.$emit('perform-move', position)
    }
  }
}
</script>

<style>
.tictactoe-board {
  margin: auto;
  display: flex;
  flex-wrap: wrap;
  width: 204px;
  height: 204px;
}
</style>
