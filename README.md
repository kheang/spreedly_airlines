# README

## Local Setup

To run this locally, you will need to set ENV variables for `SPREEDLY_SECRET`, `SPREEDLY_GATEWAY_TOKEN`, and `SPREEDLY_RECEIVER_TOKEN`.  The env key is stored in `credentials.yml.enc`

## Questions

- To display payment methods, I am using the `gateways/<gateway-token>/transactions.json` endpoint.  It returns all of the credit card data (first 6 and last 4 digits). I was wondering about PCI compliance as a customer. In the view, I am only displaying the full name, last 4 digits, and the card type.
- With PMD, I didn't mock a callback/webhook from Expedia. I'm guessing customers would usually have some integration with a receiver like that?
