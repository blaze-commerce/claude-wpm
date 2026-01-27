/**
 * Default WooCommerce Selectors
 *
 * These are standard WooCommerce selectors that work with most themes.
 * Sites can override specific selectors in their own selectors.ts file.
 */

export const WooSelectors = {
  // Shop/Archive pages
  shop: {
    productGrid: '.products',
    productItem: '.product',
    productTitle: '.woocommerce-loop-product__title',
    productPrice: '.price',
    addToCartBtn: '.add_to_cart_button',
    addedToCartBtn: '.added_to_cart',
    viewCartLink: '.added_to_cart',
    pagination: '.woocommerce-pagination',
    resultCount: '.woocommerce-result-count',
    ordering: '.woocommerce-ordering',
  },

  // Single product page
  product: {
    title: '.product_title',
    price: '.price',
    addToCartBtn: 'button.single_add_to_cart_button',
    quantityInput: 'input.qty',
    variationSelect: '.variations select',
    variationForm: '.variations_form',
    productGallery: '.woocommerce-product-gallery',
    productTabs: '.woocommerce-tabs',
    relatedProducts: '.related.products',
    productMeta: '.product_meta',
    sku: '.sku',
    categories: '.posted_in',
    tags: '.tagged_as',
  },

  // Cart page
  cart: {
    form: '.woocommerce-cart-form',
    table: '.shop_table.cart',
    itemRow: '.woocommerce-cart-form__cart-item',
    productName: '.product-name',
    productPrice: '.product-price',
    productQty: 'input.qty',
    productSubtotal: '.product-subtotal',
    removeBtn: '.remove',
    couponInput: '#coupon_code',
    applyCouponBtn: 'button[name="apply_coupon"]',
    updateCartBtn: 'button[name="update_cart"]',
    cartTotals: '.cart_totals',
    orderTotal: '.order-total .amount',
    checkoutBtn: '.checkout-button',
    emptyCartMsg: '.cart-empty',
  },

  // Checkout page
  checkout: {
    form: 'form.checkout',
    billingFields: {
      firstName: '#billing_first_name',
      lastName: '#billing_last_name',
      company: '#billing_company',
      country: '#billing_country',
      address1: '#billing_address_1',
      address2: '#billing_address_2',
      city: '#billing_city',
      state: '#billing_state',
      postcode: '#billing_postcode',
      phone: '#billing_phone',
      email: '#billing_email',
    },
    shippingFields: {
      firstName: '#shipping_first_name',
      lastName: '#shipping_last_name',
      company: '#shipping_company',
      country: '#shipping_country',
      address1: '#shipping_address_1',
      address2: '#shipping_address_2',
      city: '#shipping_city',
      state: '#shipping_state',
      postcode: '#shipping_postcode',
    },
    shipToDifferent: '#ship-to-different-address-checkbox',
    orderNotes: '#order_comments',
    orderReview: '.woocommerce-checkout-review-order',
    orderTable: '.woocommerce-checkout-review-order-table',
    paymentMethods: '.woocommerce-checkout-payment',
    placeOrderBtn: '#place_order',
    termsCheckbox: '#terms',
  },

  // My Account page
  account: {
    loginForm: '.woocommerce-form-login',
    registerForm: '.woocommerce-form-register',
    dashboard: '.woocommerce-MyAccount-content',
    navigation: '.woocommerce-MyAccount-navigation',
    orders: '.woocommerce-orders-table',
    addresses: '.woocommerce-Addresses',
    accountDetails: '.woocommerce-EditAccountForm',
  },

  // Mini cart / Cart widget
  miniCart: {
    widget: '.widget_shopping_cart',
    itemCount: '.cart-contents .count',
    total: '.cart-contents .amount',
    viewCartBtn: '.woocommerce-mini-cart__buttons .button:first-child',
    checkoutBtn: '.woocommerce-mini-cart__buttons .checkout',
  },

  // Messages and notices
  messages: {
    success: '.woocommerce-message',
    error: '.woocommerce-error',
    info: '.woocommerce-info',
    notice: '.woocommerce-notice',
  },

  // General/Common
  general: {
    loader: '.blockUI, .loading, .wc-block-components-spinner',
    breadcrumb: '.woocommerce-breadcrumb',
    saleFlash: '.onsale',
    outOfStock: '.out-of-stock',
    inStock: '.in-stock',
    starRating: '.star-rating',
  },
};

export type WooSelectorsType = typeof WooSelectors;
