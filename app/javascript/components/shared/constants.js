export const ROUTES = {
  HOME: '/',
  CUSTOMER_INFO: '/customer-info',
  ITEM_PRICING: '/items-pricing',
  NOT_FOUND: '*',
  LOGIN: '/users/sign_in',
}

export const ENDPOINTS = {
  QUOTES: '/api/v1/quotes',
  LOGOUT: '/users/sign_out',
}

export const STEPS = {
  ITEM_PRICING: 'items_pricing',
  CUSTOMER_INFO: 'customer_info',
  COMPLETED: 'completed',
}

// STEPS_DATA is for PcProgressBar component
export const STEPS_DATA = [
  // step_id must be a number
  { step_id: 1, step: ROUTES.CUSTOMER_INFO, title: 'Customer Information' },
  { step_id: 2, step: ROUTES.ITEM_PRICING, title: 'Items & Pricing' },
];

// Centralized storage for image assets
import logoUrl from '../../../assets/images/icons/logo.svg'
import logoutUrl from '../../../assets/images/icons/logout.svg'

export const IMAGE_ASSETS = {
  ICONS: {
    logo: logoUrl,
    logout: logoutUrl,
  },
  // future asset files can be added here
}
