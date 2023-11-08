<template>
  <div id="nav">
    <router-link to="/">Game</router-link> |
    <router-link to="/history">History</router-link> |
    <router-link to="/leaderboard">LeaderBoard</router-link>
  </div>
  <router-view />
</template>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}

#nav {
  padding: 0px;
}

#nav a {
  font-weight: bold;
  color: #2c3e50;
}

#nav a.router-link-exact-active {
  color: #42b983;
}

h4 {
  margin: 5px;
}
h3 {
  margin: 5px;
}
</style>
