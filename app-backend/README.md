# Backend Application for Flutter Android App

To run app, you need to install nodejs, npm and mongodb to youe system.

To install dependencies 
```npm i```

To run app
```npm run dev``` 
It will serve at your local ip address on port 3000.

(http://localhost:3000/app) Base endpoint.

## Api Endpoints
1. /detials - Get details of all Customer. (GET)
2. /addCustomer - Add new Customer(POST)
3. /details/delete/customer/:customerId - Delete Customer with ID (GET)
4. /details/edit/customer/:customerId - Edit Customer with ID (POST)
5. /create/:customerId - Add Invoices for customer with ID (POST)
6. /details/advance/:customerId - Get All Advances of Customer with ID (GET)
7. /details/advance/:customerId - Add Advance of Customer (POST)
8. /details/:customerId/:invoiceId/edit - Edit Invoice with customerId and InvoiceId (POST)
9. /details/:customerId - Get Details of Invoices of customer with Id (GET)
10. /details/:customerId/:invoiceId/delete - Delete Invoice with customerId and InvoiceId (GET)
11. /details/:customerId/getPDF - Generate PDF of Invoice (POST)
12. /details/:customerId/payments - Get Received Payments of Customer (GET)
13. /details/:customerId/payments/delete/:paymentId -  Delete Payment (GET)
14. /addPayment/:customerId - Add Payment for CustomerId (POST)
15. /sendSms/:customerId -  Send SMS of Pending Invoice to Customer (GET)
