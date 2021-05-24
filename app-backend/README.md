# Backend Application for Flutter Android App

To run app, you need to install nodejs, npm and mongodb to youe system.

To install dependencies 
```npm i```

To run app ;
```npm run dev``` 
It will serve at your local ip address on port 3000.

(http://localhost:3000/app) Base endpoint.

## Api Endpoints
1. GET - /detials - Get details of all Customer. (GET)
2. POST - /addCustomer - Add new Customer(POST)
3. GET - /details/delete/customer/:customerId - Delete Customer with ID (GET)
4. POST - /details/edit/customer/:customerId - Edit Customer with ID (POST)
5. POST - /create/:customerId - Add Invoices for customer with ID (POST)
6. GET - /details/advance/:customerId - Get All Advances of Customer with ID (GET)
7. POST - /details/advance/:customerId - Add Advance of Customer (POST)
8. POST - /details/:customerId/:invoiceId/edit - Edit Invoice with customerId and InvoiceId (POST)
9. GET - /details/:customerId - Get Details of Invoices of customer with Id (GET)
10. GET - /details/:customerId/:invoiceId/delete - Delete Invoice with customerId and InvoiceId (GET)
11. POST - /details/:customerId/getPDF - Generate PDF of Invoice (POST)
12. GET - /details/:customerId/payments - Get Received Payments of Customer (GET)
13. GET - /details/:customerId/payments/delete/:paymentId -  Delete Payment (GET)
14. POST - /addPayment/:customerId - Add Payment for CustomerId (POST)
15. GET - /sendSms/:customerId -  Send SMS of Pending Invoice to Customer (GET)
