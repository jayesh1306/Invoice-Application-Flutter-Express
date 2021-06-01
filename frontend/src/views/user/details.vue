<template>
  <v-container>
    <v-row justify="center" align-content="center">
      <v-col md="8">
        <v-container v-if="isLoading">
          <p>Getting your files</p>
          <v-progress-linear color="deep-purple accent-4" indeterminate rounded height="6"></v-progress-linear>
        </v-container>
        <v-card elevation="3" v-else>
          <v-simple-table>
            <template v-slot:default>
              <thead>
                <tr>
                  <th class="text-left">Name</th>
                  <th class="text-left">Address</th>
                  <th class="text-left">Contact</th>
                  <th class="text-left">Email</th>
                  <th class="text-center">Delete</th>
                  <th class="text-center">View Invoices</th>
                  <th class="text-center">Payments</th>
                  <th class="text-center">Download Invoice</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(item, index) in users" :key="index">
                  <td>{{ item.name }}</td>
                  <td>{{ item.address }}</td>
                  <td>{{ item.contact }}</td>
                  <td>{{ item.email }}</td>
                  <td class="text-center">
                    <v-btn icon>
                      <v-icon color="red">mdi-delete</v-icon>
                    </v-btn>
                  </td>
                  <td class="text-center">
                    <v-btn icon link :to="`/details/${item._id}`">
                      <v-icon color="orange">mdi-eye</v-icon>
                    </v-btn>
                  </td>
                  <td class="text-center">
                    <v-btn icon>
                      <v-icon color="green">money</v-icon>
                    </v-btn>
                  </td>
                  <td class="text-center">
                    <v-btn icon>
                      <v-icon color="orange" class="btn">mdi-file-pdf</v-icon>
                    </v-btn>
                  </td>
                </tr>
              </tbody>
            </template>
          </v-simple-table>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
export default {
  data() {
    return {
      headers: [
        {
          text: "Name",
          align: "start",
          sortable: true,
          value: "name",
        },
        { text: "Address", value: "address" },
        { text: "Contact", value: "contact" },
        { text: "Email", value: "email" },
      ],
    };
  },
  computed: {
    isLoading() {
      return this.$store.getters.getLoading;
    },
    users() {
      return this.$store.getters.getUsersFromStore;
    },
  },
  created() {
    this.initializeUsers();
  },
  methods: {
    initializeUsers() {
      this.$store.dispatch("getAllUsers");
    },
  },
};
</script>