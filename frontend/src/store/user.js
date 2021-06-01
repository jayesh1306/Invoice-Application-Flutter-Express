// Axios Instance 
import axios from '../axios';

// GLobal state 
import store from './index';

const state = {
    user: [],
    invoices: [],
    totalAmount: 0,
    loading: false,
}

const actions = {
    getAllUsers({ commit }) {
        commit('loadingState', true);
        axios.get('/details')
            .then((response) => {
                commit('saveUsers', response.data)
                commit('loadingState', false);
                // console.log(response.data)
            }).catch((err) => {
                commit('loadingState', false);

                commit('snackbar', { isTrue: true, message: err.message, color: 'error' })
            });
    },
    getInvoice({ commit }, userId) {
        commit('loadingState', true);
        axios.get(`/details/${userId}`)
            .then((response) => {
                console.log(response.data)
                commit('saveInvoices', response.data)
                commit('loadingState', false);
                commit('calculateTotalAmount');
                return response.data;
                // console.log(response.data)
            }).catch((err) => {
                console.log(err)
                commit('loadingState', false);
            });
    },
    deleteInvoice({ commit }, data) {
        commit('loadingState', true);

        axios.get(`/details/${data.userId}/${data.invoiceId}/delete`)
            .then((result) => {
                commit('loadingState', false);
                commit('removeInvoice', data.index);
                commit('calculateTotalAmount');
            }).catch((err) => {
                commit('loadingState', false);
                console.log(err)
            });
    },
    editInvoice({ commit }, data) {
        commit('loadingState', false);
        axios.post(`/details/${data.userId}/${data.invoiceId}/edit`, {
                products: data.products,
                rate: data.rate,
                quantity: data.quantity,
                invoiceDate: data.date
            })
            .then((result) => {
                commit('loadingState', false);
                return true;
            })
            .catch((err) => {
                commit('loadingState', false);
                return false;
            });
    },
    addInvoices({ commit }, data) {
        console.log(data)
        console.log(data.userId)
        axios.post(`/create/${data.userId}`, data.data)
            .then((result) => {
                console.log(result);
                commit('pushInvoice', data.data);
            }).catch((err) => {
                return err;
            });
    }
}
const mutations = {
    saveUsers(state, users) {
        state.user = users;
    },
    saveInvoices(state, invoices) {
        state.invoices = invoices;
    },
    calculateTotalAmount(state) {
        var invoices = state.invoices;
        var sum = 0;
        invoices.forEach(element => {
            sum += element.rate * element.quantity;
        });
        state.totalAmount = sum;
    },
    pushInvoice(state, data) {
        state.invoices.push(data);
    },
    loadingState(state, isLoading) {
        state.loading = isLoading;
    },
    removeInvoice(state, index) {
        console.log(state, index)
        var invoices = state.invoices;
        invoices.splice(index, 1)
        console.log(invoices);
        state.invoices = invoices;
    },
}
const getters = {
    getUsersFromStore(state) {
        return state.user
    },
    getLoading(state) {
        return state.loading;
    },
    getInvoicesFromStore(state) {
        return state.invoices
    },
    getTotalInvoiceAmount(state) {
        return state.totalAmount;
    }
}

export default {
    state,
    actions,
    mutations,
    getters
}