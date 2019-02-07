Rails.configuration.stripe = {
    :publishable_key => 'pk_test_9EXR0i6P3vlj7i0MN8wTphm4',
    :secret_key => 'sk_test_lhudy2A5dn1XFxUIRlNjteJv'
}
Stripe.api_key = Rails.configuration.stripe[:secret_key]