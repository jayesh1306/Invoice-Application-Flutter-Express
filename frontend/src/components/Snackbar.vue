<template>
  <v-container>
    <v-snackbar :timeout="time" v-model="snackbarItem">{{ message }}</v-snackbar>
  </v-container>
</template>

<script>
export default {
  props: ["snackbarItem", "message", "time"],
};
</script>