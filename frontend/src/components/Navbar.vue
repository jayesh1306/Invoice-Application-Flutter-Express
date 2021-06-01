<template>
  <v-app-bar elevation="2" color="#ADD8E6" elevate-on-scroll app>
    <v-app-bar-nav-icon @click="drawer = !drawer"></v-app-bar-nav-icon>
    <v-toolbar-title>Practice</v-toolbar-title>
    <v-navigation-drawer app v-model="drawer" temporary absolute>
      <v-list nav>
        <v-list-item>
          <v-container>
            <v-card elevation="10" shaped>
              <v-img
                src="https://i.pinimg.com/originals/8e/8e/84/8e8e8463ab3d8d4a6a761c0d182d4de8.png"
              ></v-img>
            </v-card>
          </v-container>
        </v-list-item>
        <v-list-item>
          <v-container>
            <p class="display-0">Rameshwar Enterprise Application</p>
          </v-container>
        </v-list-item>
        <v-divider></v-divider>
        <v-container>
          <v-list-item link to="/">User Details</v-list-item>
        </v-container>
      </v-list>
    </v-navigation-drawer>
  </v-app-bar>
</template>

<script>
export default {
  data() {
    return {
      drawer: false,
    };
  },
};
</script>