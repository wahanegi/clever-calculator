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
  SETTING: '/api/v1/setting',
  CUSTOMERS: '/api/v1/customers',
  CUSTOMERS_UPSERT: '/api/v1/customers/upsert',
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
]

// Centralized storage for image assets
import logoUrl from '../../../assets/images/icons/logo.svg'
import logoutUrl from '../../../assets/images/icons/logout.svg'
import placeholderUrl from '../../../assets/images/icons/placeholder.svg'
import dropdownArrowDownUrl from '../../../assets/images/icons/arrow-down.svg'
import dropdownArrowUpUrl from '../../../assets/images/icons/arrow-up.svg'
import crossUrl from '../../../assets/images/icons/cross.svg'

export const IMAGE_ASSETS = {
  ICONS: {
    logo: logoUrl,
    logout: logoutUrl,
    placeholder: placeholderUrl,
    dropdownArrowDown: dropdownArrowDownUrl,
    dropdownArrowUp: dropdownArrowUpUrl,
    cross: crossUrl,
  },
  // future asset files can be added here
}

export const EMPTY_ENTITIES = {
  customer: {
    company_name: '',
    full_name: '',
    email: '',
    position: '',
    address: '',
    notes: '',
    logo_url: null,
  }
  // future empty entities can be added here
}

export const INPUT_VALIDATORS = {
  emailFormat:/^[^\s@]+@[^\s@]+\.[^\s@]+$/,
  maxSizeFile: 2 * 1024 * 1024,
  allowedFileTypes: ['image/jpeg', 'image/png'],
  // future validation rules can be added here
}