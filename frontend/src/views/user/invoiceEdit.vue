<template>
  <v-container>
    <v-row justify="center">
      <v-col md="4">
        <v-card class="pa-5 ma-5">
          <v-card-title>Edit Invoice</v-card-title>
          <v-card-text>
            <v-form>
              <v-text-field label="Name" v-model="product" :value="product" type="text"></v-text-field>
              <v-text-field label="Rate" v-model="rate" :value="rate" type="number"></v-text-field>
              <v-text-field label="Quantity" v-model="quantity" :value="quantity" type="number"></v-text-field>
              <v-menu
                v-model="menu2"
                :close-on-content-click="false"
                :nudge-right="40"
                transition="scale-transition"
                offset-y
                min-width="auto"
              >
                <template v-slot:activator="{ on, attrs }">
                  <v-text-field v-model="date" label="Date" readonly v-bind="attrs" v-on="on"></v-text-field>
                </template>
                <v-date-picker v-model="date" @input="menu2 = false"></v-date-picker>
              </v-menu>
              <v-btn class="primary" @click="editInvoice">Confirm</v-btn>
            </v-form>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
    <v-container v-if="snackbar">
      <SnackBar :snackbarItem="snackbar" :message="message" :time="timeout" />
    </v-container>
  </v-container>
</template>

<script>
import SnackBar from "../../components/Snackbar";

export default {
  data() {
    return {
      snackbar: false,
      message: "",
      timeout: "",
    };
  },
  components: {
    SnackBar,
  },
  data() {
    return {
      product: this.$route.params.invoice.products,
      rate: this.$route.params.invoice.rate,
      quantity: this.$route.params.invoice.quantity,
      date: new Date().toISOString().substr(0, 10),
      menu2: false,
    };
  },
  methods: {
    editInvoice() {
      this.$store
        .dispatch("editInvoice", {
          userId: this.$route.params.userId,
          invoiceId: this.$route.params.invoice._id,
          products: this.product,
          rate: this.rate,
          quantity: this.quantity,
          date: new Date(this.date).toISOString(),
        })
        .then((result) => {
          this.snackbar = true;
          this.message = "Success";
          this.timeout = 3000;
          this.$router.back();
        })
        .catch((err) => {});
    },
  },
};
</script>