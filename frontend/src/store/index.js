import Vue from 'vue'
import Vuex from 'vuex'

// Modules
import user from './user';

Vue.use(Vuex)

export default new Vuex.Store({
    getters: {},
    modules: { user, }
})