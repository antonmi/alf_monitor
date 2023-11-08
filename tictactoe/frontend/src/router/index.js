import { createRouter, createWebHashHistory } from "vue-router";
import Home from "../views/Home.vue";
import History from "../views/History";
import LeaderBoard from "../views/LeaderBoard";

const routes = [
  {
    path: "/",
    name: "Home",
    component: Home,
  },
  {
    path: "/history",
    name: "History",
    component: History,
  },
  {
    path: "/leaderboard",
    name: "LeaderBoard",
    component: LeaderBoard,
  }
];

const router = createRouter({
  history: createWebHashHistory(),
  routes,
});

export default router;
