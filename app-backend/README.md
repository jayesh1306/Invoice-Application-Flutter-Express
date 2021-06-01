# Backend Application for Flutter Android App

To run app, you need to install nodejs, npm and mongodb to youe system.

To install dependencies 
```npm i```

To run app ;
```npm run dev``` 
It will serve at your local ip address on port 3000.

(http://localhost:3000/app) Base endpoint.

## Api Endpoints
1. GET - /detials - Get details of all Customer. 
2. POST - /addCustomer - Add new Customer
3. GET - /details/delete/customer/:customerId - Delete Customer with ID 
4. POST - /details/edit/customer/:customerId - Edit Customer with ID 
5. POST - /create/:customerId - Add Invoices for customer with ID 
6. GET - /details/advance/:customerId - Get All Advances of Customer with ID 
7. POST - /details/advance/:customerId - Add Advance of Customer 
8. POST - /details/:customerId/:invoiceId/edit - Edit Invoice with customerId and InvoiceId 
9. GET - /details/:customerId - Get Details of Invoices of customer with Id 
10. GET - /details/:customerId/:invoiceId/delete - Delete Invoice with customerId and InvoiceId 
11. POST - /details/:customerId/getPDF - Generate PDF of Invoice 
12. GET - /details/:customerId/payments - Get Received Payments of Customer
13. GET - /details/:customerId/payments/delete/:paymentId -  Delete Payment
14. POST - /addPayment/:customerId - Add Payment for CustomerId 
15. GET - /sendSms/:customerId -  Send SMS of Pending Invoice to Customer
