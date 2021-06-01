//Container
import Container from '../container/Container';

import UserDetailView from '../views/user/details';
import InvoiceDetailView from '../views/user/invoiceDetail';
import InvoiceEditView from '../views/user/invoiceEdit'

export default {
    path: '/',
    redirect: '/details',
    component: Container,
    children: [{
            path: '/details',
            component: UserDetailView,
            name: 'UserDetailView'
        }, {
            path: '/details/:id',
            component: InvoiceDetailView,
            name: 'InvoiceDetailView'
        },
        {
            path: '/details/:userId/:invoiceId/edit',
            component: InvoiceEditView,
            name: 'InvoiceEditView'
        }
    ]
}