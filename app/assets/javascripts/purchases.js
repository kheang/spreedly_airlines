function checkout(env_key, price) {
  console.log('im here');
  SpreedlyExpress.init(env_key, {
    "amount": price,
    "company_name": "Spreedly Airlines",
    "sidebar_top_description": "The last airlines you will ever need",
    "sidebar_bottom_description": "Your order today",
  });

  SpreedlyExpress.openView();

  SpreedlyExpress.onPaymentMethod(function(token, paymentMethod) {
    var tokenField = document.getElementById("payment_method_token");

    tokenField.setAttribute("value", token);

    var masterForm = document.getElementById('payment-form');
    masterForm.submit();
  });
}
