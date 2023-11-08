<template>
  <div class="cell">
    <span v-if="value !== ''">{{ value }}</span>
  </div>
</template>

<script>
export default {
  name: "Cell",
  props: {
    value: String,
  }
}
</script>
<style>
.cell {
  width: 64px;
  height: 64px;
  border: 2px solid rgb(75,75,75);
  font-size: 42px;
  display: flex;
  align-items: center;
  justify-content: center;
}
</style>
