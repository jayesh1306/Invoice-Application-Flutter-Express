<template>
  <v-app app>
    <NavBar />
    <v-main>
      <router-view></router-view>
    </v-main>
  </v-app>
</template>



<script>
import NavBar from "../components/Navbar";

export default {
  components: {
    NavBar,
  },
};
</script>