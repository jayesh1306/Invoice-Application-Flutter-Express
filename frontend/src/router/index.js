import Vue from 'vue'
import VueRouter from 'vue-router'

//Routes
import user from './user';

Vue.use(VueRouter)

const routes = [
    user,
]

const router = new VueRouter({
    mode: 'history',
    base: process.env.BASE_URL,
    routes
})

export default router